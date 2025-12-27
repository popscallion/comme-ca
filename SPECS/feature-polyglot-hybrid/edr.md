# 🤝 One‑Tool‑Many‑Languages: How Much Can You Share Across JS/TS · Python · Rust · Swift?  

You already work with **Zed**, **Ghostty → Claude**, and occasionally **Jupyter notebooks**.  
Below is a practical “core‑plus‑overlay” map that shows which tools, configurations, and workflows you can **reuse verbatim** for all four languages, and which ones need a thin language‑specific layer.

| ✅  Shared Piece (works for *all* four languages) | 🛠️  Concrete Tool / File | 📚  Why It Works |
|---|---|---|
| **Version control** | `git` + `.gitignore` (shared) | Git is language‑agnostic. Keep a *single* repo (monorepo) or *multiple* repos that follow the same conventions. |
| **Editor/IDE config** | `.editorconfig`, `settings.json` (Zed), LSP servers | `editorconfig` normalises indent, line‑ending, charset, etc. Zed can load **multiple LSPs** (`tsserver`, `pylsp`, `rust-analyzer`, `sourcekit-lsp`). |
| **Code‑style enforcement** | `prettier` (JS/TS), `black` (Python), `rustfmt` (Rust), `swiftformat` (Swift) **+** a *meta* `lint-staged`/`husky` or `pre-commit` hook that runs the appropriate formatter automatically. |
| **Static analysis / security scanning** | `semgrep` (multi‑language), `git‑secrets`, `dependabot` | `semgrep` ships patterns for TS, Python, Rust, Swift; you can keep one `.semgrep.yml`. |
| **Dependency updates** | `dependabot` (GitHub), `renovate` | Works on `package.json`, `requirements.txt`, `Cargo.toml`, `Package.swift`. |
| **Build orchestration** | `just`, `make`, **Bazel**, **Nix**, or **Docker** `Dockerfile` with multi‑stage builds | These tools can call language‑specific compilers (`npm run build`, `cargo build`, `swift build`, `pytest`) from a single entry point (`just build`). |
| **Continuous Integration** | **GitHub Actions**, **GitLab CI**, **CircleCI** – single workflow file (`.github/workflows/ci.yml`) that defines jobs for each language. | You can reuse the same cache keys (e.g., `~/.cache/pip`, `~/.cargo`, `~/.npm`) and share step definitions (`setup-node`, `setup-python`, `setup-rust`, `setup-swift`). |
| **Testing harness** | **`just test`** or a **Makefile** that runs `npm test`, `pytest`, `cargo test`, `swift test`. | All four test runners output JUnit XML → can be consumed by CI dashboards. |
| **Documentation** | **Markdown** (`README.md`, `CHANGELOG.md`), **MkDocs**/**Docusaurus**, **`mdbook`** for Rust, **`swift-doc`** for Swift, **Sphinx** for Python, **Typedoc** for TS – *but* you can generate a *single* site with **Docusaurus** or **MkDocs** that pulls in the generated docs as sub‑folders. |
| **Package publishing** | **GitHub Packages** (or a private Nexus/Artifactory) | Publish NPM packages, PyPI wheels, Cargo crates, and Swift Packages to the same registry endpoint (or at least to the same **GitHub Release** asset). |
| **Polyglot notebooks** | **Jupyter** (with kernels: `ipython`, `evcxr` for Rust, `IRkernel`/`SwiftKernel` for Swift, plus JS/TS via `ijavascript`) | One notebook can contain cells in any language; you can embed results, share the same `.ipynb` file across the team. |
| **Environment definition** | **`direnv`**, **`.envrc`** + **`asdf`** (or **`mise`**) for managing multiple runtimes (`node`, `python`, `rust`, `swift`). | The same `.envrc` installs the exact versions for all four languages on any developer’s machine. |
| **Task‑automation (CLI scripts)** | **`scripts/`** folder with Bash/PowerShell/Node scripts that invoke language‑specific tools | A single script like `scripts/lint.sh` can dispatch to `npm run lint`, `cargo clippy`, `swiftlint`, `flake8`. |
| **LLM‑assisted workflow** | **Ghostty → Claude** (or Claude Direct) + **Zed** prompts | The LLM just sees the *file names* and can produce code for any of the languages; you keep a *single* prompt template (e.g., “Write a function that … in {language}”). |
| **Issue / PR templates** | `.github/ISSUE_TEMPLATE`, `.github/PULL_REQUEST_TEMPLATE` | Identical templates for all language contributions; you only add a small “language” selector in the template. |
| **Project metadata** | `LICENSE`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md` | Universally shared. |
| **Metrics / Telemetry** | `Prometheus` exporter, `OpenTelemetry` SDK (available for all four) | Same instrumentation library can be used across services written in different languages. |

---  

## 🎯 How to Organise a Polyglot Repo

```
my‑project/
│
├─ .editorconfig
├─ .pre-commit-config.yaml        # runs black / rustfmt / swiftformat / prettier
├─ .github/
│   ├─ workflows/
│   │   └─ ci.yml                # single CI, multiple matrix jobs
│   └─ dependabot.yml
│
├─ justfile                       # common commands: test, lint, fmt, build
├─ Makefile (optional)            # wrapper around just
│
├─ packages/
│   ├─ js/            # package.json, tsconfig.json, src/
│   ├─ py/            # requirements.txt, pyproject.toml, src/
│   ├─ rust/          # Cargo.toml, src/
│   └─ swift/         # Package.swift, Sources/
│
├─ notebooks/
│   └─ exploration.ipynb        # contains python, rust, swift, ts cells
│
├─ scripts/
│   ├─ lint.sh
│   └─ release.sh
│
└─ DOCS/
    └─ mkdocs.yml
```

- **`justfile` example**

```make
# justfile – one source of truth for all commands

fmt:
    # format every language
    cd packages/js && npm run fmt
    cd packages/py && black .
    cd packages/rust && cargo fmt
    cd packages/swift && swiftformat .

lint:
    # run language‑specific linters
    cd packages/js && npm run lint
    cd packages/py && flake8 .
    cd packages/rust && cargo clippy -- -D warnings
    cd packages/swift && swiftlint

test:
    cd packages/js && npm test
    cd packages/py && pytest -vv
    cd packages/rust && cargo test --all
    cd packages/swift && swift test

build:
    cd packages/js && npm run build
    cd packages/py && python -m build   # optional wheel build
    cd packages/rust && cargo build --release
    cd packages/swift && swift build -c release
```

All four languages are **triggered from the same command** (`just test`), which you can run from Zed’s terminal pane, Ghostty, or any CI runner.

---

## 🧩 Polyglot Notebook Workflow (Jupyter)

| Kernel | Install | Example Cell Header |
|--------|----------|----------------------|
| Python | `pip install ipykernel` | `%%python` |
| Rust   | `cargo install evcxr_jupyter` → `evcxr_jupyter --install` | `%%rust` |
| Swift  | `python -m pip install swift_kernel` → `python -m swift_kernel.install` | `%%swift` |
| JavaScript/TS | `npm i -g ijavascript` → `ijsinstall` | `%%javascript` |

*Result*: One `.ipynb` can run a data‑processing pipeline in Python, invoke a Rust‑implemented algorithm for speed, call a Swift UI helper, and finish with a TS visualisation—all within the same notebook.

---

## 🛠️ LLM‑Centric Development (Ghostty → Claude)

1. **Standard Prompt Template** (saved as a Zed snippet)

```
You are a code assistant. Write idiomatic {language} code that:
- follows the project style (see .editorconfig, pre‑commit config)
- includes appropriate tests
- works on macOS, Linux, and Windows if applicable
```

2. **Reuse across languages** – just replace `{language}` with `JavaScript`, `Python`, `Rust`, or `Swift`. The same prompt yields consistent, style‑aware output because the tooling (formatters, linters) is shared.

3. **Automate with Ghostty** – bind a hotkey that sends the current buffer to Claude, receives the answer, and writes it back to the file. Zed’s “Code Actions” can be set up to call this workflow for any file type.

---

## 📦 Packaging & Distribution Cheat‑Sheet

| Artifact | Tool | Cross‑language sharing |
|----------|------|------------------------|
| **Web front‑end** | `npm publish` (or GitHub Packages) | Same `package.json` for TS UI; embed a compiled Rust WASM binary (`wasm-pack`) as an npm dependency. |
| **Python library** | `twine` / `pip` | Include a compiled Rust extension via `pyo3` (exposes Rust functions as Python modules). |
| **Rust crate** | `cargo publish` | Can be linked from Swift via `swift-package-manager` (use `cargo lipo` to build a static library). |
| **Swift package** | `swift build` / `swift package` | Can import a compiled Rust static lib (`.a`) or a C wrapper generated by `cbindgen`. |

You can **publish a single GitHub Release** that bundles:

- `dist/your-tool.tar.gz` (contains compiled binaries for every language)
- `dist/npm.tgz`
- `dist/pypi.whl`
- `dist/SwiftPackage.zip`

All four ecosystems can then reference the *same* version tag (`v1.2.3`).

---

## 📈 What You **Can’t** Completely Share

| Area | Why a language‑specific piece is inevitable |
|------|--------------------------------------------|
| **Runtime** | Node.js, CPython, Rust’s `cargo`, Swift’s `swiftc` – each has its own REPL, debugger, and runtime semantics. |
| **Error handling idioms** | `Result<T,E>` (Rust), `throw/catch` (TS/JS), `Exception` (Python), `throw` (Swift). |
| **Package metadata format** (`package.json`, `pyproject.toml`, `Cargo.toml`, `Package.swift`) – you must maintain four files. |
| **Native UI frameworks** | SwiftUI/AppKit/UIKit vs. Tauri (WebView) vs. React/TS – UI layer is language‑specific. |
| **Build artefacts** | `node_modules`, `target/`, `.build/`, `DerivedData/` – each lives in its own folder. |
| **Testing frameworks** | Jest/Mocha, pytest, cargo test, swift test – distinct APIs, though you can unify the *report* format. |

The **strategy** is to wrap these language‑specific bits behind **scripts** (`just`, `make`) and **CI jobs** so that from the team’s point‑of‑view you run **one** command and the tooling invokes the right language‑specific tool under the hood.

---

## 📚 Quick‑Start Checklist (first‑day setup)

| ✅  Step | Command / Action |
|----------|------------------|
| **1️⃣ Install runtime managers** | `brew install node python3 rustup swift asdf && asdf plugin add node && asdf plugin add python && asdf plugin add rust && asdf plugin add swift` |
| **2️⃣ Bootstrap repo** | `git clone <repo>.git && cd my-project && asdf install` |
| **3️⃣ Install LLM bridge** | `cargo install gh-claude` (or your preferred CLI) and add an alias to Ghostty. |
| **4️⃣ Install Jupyter kernels** | `pip install ipykernel && python -m ipykernel install --user`; `cargo install evcxr_jupyter && evcxr_jupyter --install`; `pip install swift_kernel && python -m swift_kernel.install` |
| **5️⃣ Set up pre‑commit** | `pip install pre-commit && pre-commit install` (the config runs `black`, `rustfmt`, `swiftformat`, `prettier`). |
| **6️⃣ Verify CI locally** | `just test && just lint && just fmt --check` |
| **7️⃣ Try a polyglot notebook** | `jupyter notebook notebooks/exploration.ipynb` and add a `%%rust` cell. |
| **8️⃣ Run an LLM‑generated snippet** | In Zed, select a .rs/.py/.ts/.swift file → `Ctrl+Shift+P` → “Ask Claude for implementation”. |

---

## 🎉 Takeaway

| ✔️  What you can **reuse** everywhere | ❌  What you’ll still **customise** per language |
|--------------------------------------|-------------------------------------------------|
| Git, CI, Docker, Just/Make, Pre‑commit, `editorconfig`, `semgrep`, issue templates, Release pipelines, LLM prompt library, Jupyter polyglot notebooks, cross‑platform docs site. | Language‑specific build files (`package.json`, `pyproject.toml`, `Cargo.toml`, `Package.swift`), test runner configs, formatter configs, native UI code (SwiftUI vs. Tauri WebView), runtime debugging tools, binary packaging (npm vs. PyPI vs. crates.io vs. SwiftPM). |

By **centralising** the *infrastructure* (repo layout, CI, linting, formatting, LLM workflow) and **encapsulating** the *language‑specific* steps behind tiny scripts, you get **one coherent development experience** no matter whether you’re writing JavaScript/TypeScript, Python, Rust, or Swift.

Happy polyglot coding! 🚀

