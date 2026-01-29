# XnViewMP Safe DNG Converter

A robust shell script for Linux users to convert RAW images (CR2, NEF, ARW, etc.) to Lossless DNG using `dnglab`. This script is specifically engineered to function as an external "Open With" tool within **XnViewMP** (Debian/Ubuntu version).

## 🚀 The Problem This Solves

When running external binaries like `dnglab` directly from the XnViewMP `.deb` installation, the application often forces its internal libraries (Qt/C++) onto the child process. This leads to:
* **Binary Conflicts:** Instant crashes because `dnglab` tries to use XnView's bundled libraries instead of system ones.
* **Ghost Files:** 0-byte files being created because the process dies mid-execution.
* **Write Permissions:** Issues writing directly to external NTFS/exFAT drives with deep folder structures.

## ✨ Features

* **Environment Sanitization:** Clears `LD_LIBRARY_PATH` to ensure a clean execution environment.
* **Local-First Processing:** Uses the system `/tmp` directory to bypass external drive permission bottlenecks.
* **Lossless Compression:** Forces LJPEG-92 lossless compression for maximum quality and reduced file size.
* **Integrity Verification:** Runs a "Round-trip" check using `dnglab analyze` before finalizing.
* **Safety First:** The original RAW is **only** deleted if the new DNG is confirmed healthy and exists on disk.
* **Desktop Feedback:** Provides native Linux system notifications via `notify-send`.

## 🛠️ Installation

1. **Prepare the Script:**
   Save the script as `convert_dng.sh` in your home folder and make it executable:
   ```bash
   chmod +x ~/convert_dng.sh
2. **Customize your paths**
It's all set for my own user. Adjust paths/user to your own.
