# 🐧 ROS 2 on Apple Silicon using Lima: Lightweight Ubuntu VM with Docker & GUI Support

This repository helps you run Ubuntu 22.04 with ROS 2 Humble inside a Lima VM on Apple Silicon (M1/M2/M3/M4). It provides GUI access via RDP, seamless Docker support (including Rosetta emulation for amd64 images), and full VS Code remote development, all within a lightweight and fast macOS-native virtual machine.

## 📁  Repository Layout

```
lima-ros-ubuntu/
├── .lima/
│   └── lima.yaml
├── scripts/
│   └── install_gui_desktop.sh
│   └── install_ros2_humble.sh
├── docs/
│   └── troubleshooting.md
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🎯 Why use Lima?

✅ Efficient & Seamless Docker Integration
Lima reuses your macOS host’s Docker engine and socket, so you don't need to install or run Docker inside the VM. This setup is resource-friendly, fast, and works out of the box—even with amd64 images using Rosetta.

✅ Lightweight & Native Virtualization
Lima uses Apple’s built-in vz hypervisor instead of heavy emulators like QEMU or full hypervisors like VirtualBox. It shares host resources (Docker socket, file mounts) and boots quickly with minimal memory overhead—making it far more lightweight and efficient than tools like UTM or VirtualBox.
➡️ In contrast, UTM requires installing and running a full Docker engine inside the guest OS.

✅ Rosetta Support for amd64 Docker Images
Run x86_64 Docker images via Rosetta (rosetta.enabled: true), great for cross-platform ROS and ML containers.

✅ Better Than Docker Alone
Docker Desktop alone can’t run GUI tools or a full Ubuntu system. Lima gives you both a container runtime and a full ROS-compatible Linux VM with GUI support.

✅ Seamless File Sharing & SSH Access
Use your macOS home directory inside the VM and connect instantly via VS Code Remote SSH.

✅ Flexible GUI Access via RDP
Use the VM headlessly for typical ROS workflows, or launch the full Ubuntu desktop when needed—ideal for tools like rviz, PlotJuggler, or rqt. Connect easily via Microsoft Remote Desktop over RDP.

---

> ⚠️ **Disclaimer**
> This setup was originally pieced together about half a year ago—and rebuilt from memory with a mix of confidence and caffeine. While it *should* work as described, you might run into a few bumps along the way.
>
> Don’t worry though: with a quick fix here and there, everything should run just fine. And if not—check the [troubleshooting guide](docs/troubleshooting.md), or open an issue and we’ll figure it out together!

---

## 🛠️ Prerequisites

- macOS 12+ on M1/M2/M3/M4
- [Homebrew](https://brew.sh/)
- [Microsoft Remote Desktop](https://apps.apple.com/app/microsoft-remote-desktop/id1295203466)
- (Optional) VS Code + Remote SSH extension

---

Perfect — here’s the updated **Setup Guide** with clear placeholders instead of hardcoded paths like `/mnt/ros2-lima-apple-silicon/...`. This makes your README more reusable and user-friendly.

---

## 🚀 Lima Setup Guide for ROS 2 on Apple Silicon

This guide walks you through creating a Lima VM, installing ROS 2 Humble, enabling GUI access, and integrating Docker and VS Code.

---

### ✅ 1. Install Lima

Install Lima using Homebrew:

```bash
brew install lima
```

---

### ✅ 2. Clone This Repository

Pick a workspace directory and clone the repo:

```bash
git clone https://github.com/oscarbreiner/ros2-lima-apple-silicon.git
cd ros2-lima-apple-silicon
```

---

### ✅ 3. Configure the Lima VM

Before launching, open `.lima/lima.yaml` and:

* Replace `YOUR_MAC_USERNAME` with your actual macOS username
* (Optional) Uncomment the provisioning scripts for ROS and GUI
* Confirm `mounts:` are correct for your setup

---

### ✅ 4. Create & Launch the Lima VM

Start the Lima VM using the provided config:

```bash
limactl start .lima/lima.yaml
```

Then check its status and open a shell:

```bash
limactl list
limactl shell lima-vm
```

---

### ✅ 5. Install ROS 2 Humble (Inside the VM)

Once inside the Lima VM shell:

```bash
chmod +x /mnt/<your-mount-path>/scripts/install_ros2_humble.sh
/mnt/<your-mount-path>/scripts/install_ros2_humble.sh
```

> 📁 Replace `<your-mount-path>` with your actual mount location.
> If your Lima config mounts your whole home directory (default), it’s likely:
>
> `/mnt/Users/<your-mac-username>/ros2-lima-apple-silicon`

To verify, run:

```bash
ls /mnt
```

This script will:

* Install ROS 2 dependencies and `ros-humble-desktop`
* Configure environment sourcing
* Initialize `rosdep`

---

### ✅ 6. (Optional) Enable GUI Access via RDP

Still inside the Lima VM:

```bash
chmod +x /path-to-repo/scripts/install_gui_desktop.sh
/path-to-repo/scripts/install_gui_desktop.sh
```

Then set your user password (repeat after each VM reboot):

```bash
sudo passwd $USER
```

On your **Mac**:

1. Open **Microsoft Remote Desktop**
2. Add a new PC:

   * **PC Name**: `127.0.0.1:3389`
   * **User**: your Linux username
   * **Password**: as set above

🔌 **Make sure the port (`3389`) matches the one defined in your `lima.yaml`:**

```yaml
portForwards:
  - hostPort: 3389
    guestPort: 3389
```

---

### ✅ 7. VS Code Integration (Remote SSH)

To connect from VS Code:

1. Install the **Remote - SSH** extension.
2. **Enable Lima's auto-generated SSH config**

   Edit (or create) your SSH config file:

   ```bash
   nano ~/.ssh/config
   ```

   Add this line at the top (if not already present):

   ```ssh
   Include ~/.lima/vm/ssh.config
   ```

3. **Connect in VS Code**

   * Open VS Code
   * Go to the **Remote Explorer** panel (🖧 icon)
   * You should see `lima-vm` listed under **SSH Targets**
   * Click it to open a remote session inside your Lima VM

> 💡 No need to manually define username, port, or identity — Lima handles all of that in `~/.lima/vm/ssh.config`.

---

### ✅ 8. Docker Integration with Rosetta

By default, the Lima VM **uses your macOS host’s Docker engine** by mounting the Docker socket. This allows you to run containers from **inside the VM** without installing Docker in the VM itself.

To enable this, run the following **once on your macOS host**:

```bash
docker context create lima-vm --docker "host=unix://$HOME/.lima/vm/sock/docker.sock"
docker context use lima-vm
```

Then, from **inside the Lima VM**, you can use Docker as usual:

```bash
docker run --platform=linux/amd64 hello-world
```

✅ This will:

* Use your Mac’s Docker daemon (no separate install in VM)
* Automatically emulate `amd64` images via **Rosetta**, thanks to Lima's `rosetta.enabled: true`

> ⚠️ **Only needed if you want to run Docker commands inside the VM**
> If you only use Docker on macOS (outside the VM), this step is optional.

---

## ❓ Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for help with:

* RDP not connecting
* `rosdep` issues
* Docker socket not working
* GUI login problems

---

## 📎 Tips

* **User passwords are not persistent** — rerun `sudo passwd $USER` after VM restarts.
* Start and stop the VM anytime:

  ```bash
  limactl stop lima-vm
  limactl start .lima/lima.yaml
  ```
* Reset everything (⚠️ deletes your VM):

  ```bash
  limactl delete lima-vm
  ```

---

## 🤝 Contributing

Pull requests and improvements are welcome!
Feel free to submit fixes, new scripts, or notes for other ROS distros.
