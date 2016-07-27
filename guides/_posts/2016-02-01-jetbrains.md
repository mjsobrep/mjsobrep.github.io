---
layout: guide
title:  "JetBrains IDEs"
categories: guides
tags:
- c++
- IDE
- Python
---

## Hanging on Linux:
- Bind process to a small number of cores: `taskset -c 4-5 ./clion.sh`
    - you can substitute 4-5 for whatever you like

## PowerShell in Terminal
- It will run PowerShell 32bit if you have a 32 bit IDE:
    - Set execution policy to remote signed in 32bit
    - Install needed programs in 32 bit
- Window length is cut off:
    - `powershell.exe -NoProfile -Command "mode con:cols=800; powershell.exe"`
- Colors are off:
    - Regedit
    - Go to: `HKEY_CURRENT_USER\Console`
    - Delete: `ScreenColors`
