Game Launcher – Full Installation Guide

This Launcher have been coded using AI tools like ChatGPT.
This is a Python-based game launcher coded featuring:

* 🔹 A **Tkinter**- GUI Interface
* 🔹 A **Flask**- API Backend
* 🔹 One-click build process into a standalone `.exe` or binary


## 🚀 Step-by-Step Installation Instructions

### 1️⃣ Download and Install Python (3.10+ recommended)

#### 🪟 Windows:

* Go to: [https://www.python.org/downloads/](https://www.python.org/downloads/)
* Download the latest **Python 3.x** version.
* Run the installer:

  * ✅ Check **“Add Python to PATH”** before clicking install.
  * ✅ Choose “Install for all users” if available.

#### 🐧 Linux:

```bash
sudo apt update && sudo apt install python3 python3-pip -y
```

---

### 2️⃣ Install Required Python Packages

Once Python is installed, install the required dependencies:

```bash
pip install flask pillow requests
```

If you're using a `requirements.txt` file, use:

```bash
pip install -r requirements.txt
```

---

### 3️⃣ Deploy the Flask API Server

Inside the project folder, locate the Flask API script, typically named `api.py` or `server.py`.

To launch the API server:

```bash
python server.py
```

You should see output like:

```
* Running on http://127.0.0.1:5000
```

This indicates the API is now serving requests locally.

✅ **Leave this window open** — the GUI launcher communicates with this server.

---

### 4️⃣ Modify `config/config.ini`

Edit the configuration file to suit your environment.

Typical values to customize:

```ini
[DEFAULT]
DEBUG = True
SERVER = http://127.0.0.1:5000
VERSION_FILENAME = d2version.json
CONFIG_PATH = config.json
BACKGROUND_IMAGE = images/background.jpg
ICON_PATH = images/diablo.ico
WINDOW_TITLE = Diablo II Updater

[ENDPOINTS]
VERSION_ENDPOINT = {SERVER}/version
UPDATE_ENDPOINT = {SERVER}/update
NEWS_ENDPOINT = {SERVER}/news
```

🛠️ **Tip:** Make sure all paths exist (especially `images/background.jpg` and `images/diablo.ico`).

---

### 5️⃣ Run the GUI Launcher

Simply run:

```bash
python updater.py
```

You should see the launcher window with background, icon, and any other visuals you've customized.

---

## 🧱 Optional: Build Executable (.exe or binary)

### 🪟 Windows – Using PyInstaller

Install PyInstaller:

```bash
pip install pyinstaller
```

Then build:

```bash
pyinstaller --noconfirm --onefile --windowed --icon=images/diablo.ico --add-data "images;images" --add-data "config;config" updater.py
```

📁 After build completes, your `.exe` will appear in the `dist/` folder.

### 🐧 Linux – Build Binary

```bash
pyinstaller --noconfirm --onefile --windowed updater.py
```

Make sure `updater.py` uses relative paths and avoids Windows-specific APIs if running on Linux.

---

## ⚙️ One-Step Setup Script

To make this easier, run the provided shell script:

```bash
chmod +x launcher.sh
./launcher.sh
```

This script automates:

* Python environment setup
* Dependency installation
* API server deployment
* Configuration patching
* Optional executable build

---

## ✅ Final Checklist

| Task              | Status |
| ----------------- | ------ |
| Python installed  | ✅      |
| Flask API running | ✅      |
| GUI functional    | ✅      |
| Config adjusted   | ✅      |
| Build complete    | ✅      |

---
