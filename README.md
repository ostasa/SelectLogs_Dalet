# Select Logs Dalet

**Select Logs Dalet** is a lightweight PowerShell tool with a graphical interface that allows users to remotely browse and collect log folders from Dalet systems.  
It is designed to simplify the process of identifying, selecting, and copying relevant log files for diagnostics, support, or auditing.

> ⚠️ **Disclaimer:** This project is not affiliated with Dalet Digital Media Systems. See full disclaimer below.

---

## 🖥️ Features

- Simple graphical interface using Windows Forms
- Allows selection of remote machines to access Dalet log directories
- Displays available Dalet log folders per service
- Lets users select destination folder for collected logs
- Automatically copies selected logs into a dated folder structure

---

## 🔧 Requirements

- Windows OS with PowerShell
- Access to remote machines with Dalet logs
- Network access and permissions to read from `\\machine\c$\ProgramData\Dalet\DaletLogs`

---

## 🚀 How It Works

1. Enter the name of the machine where Dalet is installed.
2. Click **"Show Logs"** to view available service folders.
3. Select one or more folders from the list.
4. Click **"Set Destination"** to choose where logs should be copied locally.
5. Click **"Copy Selected Logs"** to copy the selected folders into the destination directory.

The logs will be copied into a subfolder named with the current date and machine name.

---

MIT License

Copyright (c) 2025 ostasa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
