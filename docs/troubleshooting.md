# 🛠️ Troubleshooting

## 🚫 RDP Connection Fails

- **Symptom**: "Can't connect to remote desktop."
- **Fix**:
  - Ensure you ran:
    ```bash
    sudo apt install xrdp xfce4 xfce4-goodies
    sudo systemctl enable xrdp
    sudo systemctl start xrdp
    sudo passwd $USER
    ```
  - Verify port 3389 is open in `.lima/lima.yaml`

---

## ❌ `limactl start` fails

- **Symptom**: Config or image errors.
- **Fix**:
  - Validate your Lima config: `limactl validate .lima/lima.yaml`
  - Ensure the image URLs are reachable and correct.
  - Try `limactl delete lima-vm` and re-run `start`.

---

## 🐢 VM boots but is very slow

- **Fix**:
  - Check if you accidentally enabled QEMU (should be `vmType: vz` in YAML).
  - Ensure you're using a supported Ubuntu cloud image for ARM.

---

## 🔁 ROS Not Found After Reboot

- **Symptom**: `ros2` not found in terminal after restart.
- **Fix**:
  - Make sure this line is in your `~/.bashrc`:
    ```bash
    source /opt/ros/humble/setup.bash
    ```
  - You can add it manually if missing.

---

## 🐳 Docker Doesn’t Work in VM

- **Fix**:
  - Confirm this is in your lima config:
    ```yaml
    portForwards:
      - guestSocket: "/Users/youruser/.docker/run/docker.sock"
        hostSocket: "{{.Dir}}/sock/docker.sock"
    ```
  - On macOS:
    ```bash
    docker context create lima-vm --docker "host=unix://$HOME/.lima/vm/sock/docker.sock"
    docker context use lima-vm
    ```

---

## 💡 Tips

- **RDP user password is not persistent**: You need to rerun `sudo passwd $USER` after each VM restart.
- Always exit Lima cleanly using `limactl stop` before rebooting macOS.

