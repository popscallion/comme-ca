## Prompt for the “Raspberry‑Pi Gateway Setup Agent”

> **Goal:**  
> SSH into a Raspberry Pi 4 B that is running a *minimal* Alpine Linux install and configure it to act as the **Tail‑scale Subnet‑Router / Wi‑Fi gateway** for the office. The agent must perform all required system steps **and** interactively ask the user for any preference that cannot be inferred automatically.

IMPORTANT: this pertains to the raspberry pi 4b hardware That may already be referenced elsewhere in this project. It has not yet been set up with Alpine Linux, so we will have to do that as well. I recognize that some parts of this will have to be manual. Read through the requirements and then pull the documentation to see the s setup flow and then tell me which parts you can accomplish by yourself and which parts you need me to step in for. 

---  

### 1️⃣ High‑Level Tasks (must be executed in this order)

| Step | Command(s) (Alpine) | Description |
|------|----------------------|-------------|
| **A. Connect** | `ssh <user>@<raspberry_ip>` | Open an SSH session (the user will provide the IP/username). |
| **B. Update & install required packages** | `apk update && apk upgrade`<br>`apk add tailscale nftables dnsmasq hostapd iw` | - `tailscale` – the VPN client.<br>- `nftables` – firewall/NAT.<br>- `dnsmasq` – optional DHCP/DNS for Wi‑Fi clients.<br>- `hostapd` & `iw` – configure the built‑in Wi‑Fi as an AP. |
| **C. Enable and start Tail‑scale** | `rc-update add tailscaled`<br>`service tailscaled start`<br>`tailscale up --accept-routes --advertise-routes=<LAN_SUBNET>` | The `<LAN_SUBNET>` will be supplied by the user (e.g., `10.10.0.0/24`). |
| **D. Enable IP forwarding** | `sysctl -w net.ipv4.ip_forward=1`<br>`echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf` | Required for routing between the Ethernet interface (`eth0`) and the Tail‑scale interface (`tailscale0`). |
| **E. Configure nftables firewall** | Create `/etc/nftables.conf` with: <pre>#!/usr/sbin/nft -f\n\nflush ruleset\n\ntable ip filter {\n    chain input {\n        type filter hook input priority 0; policy drop;\n        ct state { established, related } accept\n        iif lo accept\n        udp dport 51820 ct state new accept   # WireGuard port\n    }\n    chain forward {\n        type filter hook forward priority 0; policy drop;\n        ip saddr <LAN_SUBNET> ip daddr <LAN_SUBNET> accept\n        ip saddr <LAN_SUBNET> iifname "tailscale0" accept\n        ip daddr <LAN_SUBNET> oifname "tailscale0" accept\n    }\n}\n</pre> | Replace `<LAN_SUBNET>` with the user‑provided subnet. Then run `rc-update add nftables && service nftables start`. |
| **F. (Optional) Set up Wi‑Fi AP** | 1. Edit `/etc/hostapd/hostapd.conf` with user‑provided **SSID**, **passphrase**, **channel**, **interface = wlan0**.<br>2. Enable `hostapd` (`rc-update add hostapd && service hostapd start`).<br>3. If DHCP is desired, configure `dnsmasq` to serve the same `<LAN_SUBNET>` on `wlan0`. | Only performed if the user wants the Pi to provide Wi‑Fi. |
| **G. (Optional) Enable Tailnet Lock** | `tailscale lock status` (show current keys).<br>`tailscale lock add <TRUSTED_KEY>` (ask user for the key or generate a new one). | Provides zero‑trust protection for any node that requests the advertised routes. |
| **H. Verify** | `tailscale status` – ensure the Pi appears as a **Subnet Router** and the advertised routes are visible.<br>`ping <LAN_DEVICE_IP>` – test internal connectivity.<br>`curl https://ifconfig.co` – confirm internet works through Tail‑scale. | Report success/failure to the user. |

---  

### 2️⃣ Interactive Questions (ask **only if** the answer cannot be derived automatically)

| # | Question | Expected answer format | Why we need it |
|---|----------|------------------------|----------------|
| 1 | **What is the SSH login for the Raspberry?** (username @ IP) | `user@192.168.1.42` | Needed to open the SSH session. |
| 2 | **Which LAN subnet should be advertised to the Tail‑net?** | CIDR notation, e.g., `10.10.0.0/24` | Defines the range of internal IPs the gateway will expose. |
| 3 | **Do you want the Pi to provide Wi‑Fi for the office?** | `yes` / `no` | Determines whether steps F (hostapd/dnsmasq) are executed. |
| 4 | *If Wi‑Fi = yes:* **What SSID and passphrase should be used?** | `MyOfficeNet` and a 8‑+‑character password | Required for `hostapd.conf`. |
| 5 | *If Wi‑Fi = yes:* **Do you need DHCP on the Wi‑Fi network?** | `yes` / `no` | Controls whether `dnsmasq` will hand out IPs. |
| 6 | **Do you want to enable Tailnet Lock (zero‑trust signing of nodes)?** | `yes` / `no` | If yes, the agent will ask for a trusted signing key or generate one. |
| 7 | *If Tailnet Lock = yes:* **Provide the public signing key (or press Enter to generate a new one).** | Base‑64/hex string or blank | Used with `tailscale lock add`. |
| 8 | **Do you want the firewall to allow any additional ports (e.g., SSH from the Tail‑net, custom services)?** | List of `port/protocol` pairs (e.g., `22/tcp, 443/tcp`) or `none` | The agent will add corresponding `nft` rules. |
| 9 | **Do you prefer the Pi to run as a “headless” device (no console login) or keep console access?** | `headless` / `console` | Determines whether to disable `tty` login (`/etc/inittab` adjustments). |
| 10 | **Any other custom scripts or services you want started at boot?** | Free‑form list (e.g., `my‑backup.sh`) | Agent will add them to `/etc/local.d/` or `rc-update`. |

---  

### 3️⃣ Example Dialogue (illustrative)

```
Agent: Please provide the SSH login (user@IP) for the Raspberry Pi.
User:  pi@10.0.0.15

Agent: Which LAN subnet should be advertised to the Tail‑net? (CIDR)
User: 10.10.0.0/24

Agent: Do you want the Pi to provide Wi‑Fi for the office? (yes/no)
User: yes

Agent: What SSID and passphrase should be used?
User: OfficeNet   SuperSecret123

Agent: Should the Pi run a DHCP server on the Wi‑Fi network? (yes/no)
User: yes

Agent: Do you want to enable Tailnet Lock? (yes/no)
User: yes

Agent: Provide a trusted signing key (or press Enter to generate a new one).
User: <presses Enter>

Agent: Do you need any extra ports opened in the firewall? (e.g., 22/tcp)  Type "none" if no.
User: none

Agent: Do you prefer headless operation? (headless/console)
User: headless

Agent: Any additional startup scripts?
User: none
```

---  

### 4️⃣ Final Output (what the agent should return)

- **Success summary** (commands executed, any errors).  
- **Tail‑scale status** showing the Pi as a Subnet Router and the advertised routes.  
- **Wi‑Fi details** (SSID, channel, DHCP range) if enabled.  
- **Firewall rules** snapshot (`nft list ruleset`).  
- **Tailnet Lock** status (list of trusted keys).  

If any step fails, the agent must **prompt the user** for corrective action before proceeding.  

---  

#### End of Prompt  

*Copy‑paste the above into the AI/automation framework that will act as the “Raspberry‑Pi Gateway Setup Agent”.*
