#!/usr/bin/env bash
# Test harness for cca search agent

set -e

# Setup Env
TEST_DIR="$(pwd)/tmp/test_cca_search"
mkdir -p "$TEST_DIR/bin"
mkdir -p "$TEST_DIR/home/.cca/sessions"
mkdir -p "$TEST_DIR/prompts/search_agents"

export COMME_CA_HOME="$TEST_DIR"
export HOME="$TEST_DIR/home"
export PATH="$TEST_DIR/bin:$PATH"
export COMME_CA_ENGINE="claude"

# Copy cca
cp bin/cca "$TEST_DIR/bin/cca"
chmod +x "$TEST_DIR/bin/cca"

# Mock Prompts
echo "System Prompt: Smart" > "$TEST_DIR/prompts/search_agents/haiku45.md"
echo "System Prompt: Fast" > "$TEST_DIR/prompts/search_agents/cerebras-120b.md"

# Mock Claude
cat <<'EOF' > "$TEST_DIR/bin/claude"
#!/bin/bash
# Mock engine
input=$(cat)
echo "[MOCK OUTPUT] Received input length: ${#input}"
echo "$input" >> "$HOME/.mock_log"
EOF
chmod +x "$TEST_DIR/bin/claude"

# Test 1: Single Shot
echo ">>> Test 1: Single Shot"
cca search "Hello World" > "$TEST_DIR/output_1.txt"
if grep -q "Received input length" "$TEST_DIR/output_1.txt"; then
    echo "PASS: Single shot executed"
else
    echo "FAIL: Single shot output missing"
    exit 1
fi

# Verify session file created
LATEST_SESSION=$(readlink "$HOME/.cca/sessions/latest")
if [[ -f "$HOME/.cca/sessions/$LATEST_SESSION" ]]; then
    echo "PASS: Session file created"
else
    echo "FAIL: Session file missing"
    exit 1
fi

# Test 2: Resume
echo ">>> Test 2: Resume"
cca search --resume "Follow up" > "$TEST_DIR/output_2.txt"
# Verify log contains history
if grep -q "User: Hello World" "$HOME/.mock_log"; then
    echo "PASS: History preserved in resume"
else
    echo "FAIL: History missing in resume"
    cat "$HOME/.mock_log"
    exit 1
fi

# Test 3: Model Selection
echo ">>> Test 3: Model Fast"
cca search --model fast "Go fast" > "$TEST_DIR/output_3.txt"
# Check if "System Prompt: Fast" was sent (it's in the log)
if grep -q "System Prompt: Fast" "$HOME/.mock_log"; then
    echo "PASS: Fast model selected"
else
    echo "FAIL: Wrong prompt selected"
    exit 1
fi

echo "All tests passed."
rm -rf "$TEST_DIR"
