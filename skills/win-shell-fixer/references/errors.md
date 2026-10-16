# Error to Fix Table

Format: **message** | cause | first fix (shell). Give ONE fix at a time, then ask for output.

## Not found / PATH

| Message | Cause | Fix |
|---|---|---|
| `'x' is not recognized as an internal or external command` (CMD) | Not installed, or not on PATH, or terminal opened before install | `where x`. If missing: install (winget). If installed: add its folder to PATH via Settings > System > About > Advanced system settings > Environment Variables, then reopen terminal. Avoid `setx PATH "%PATH%;..."` (truncates at 1024 chars). |
| `The term 'x' is not recognized as the name of a cmdlet, function, script file...` (PS) | Same, or typo, or module not loaded | `Get-Command x`. Module: `Install-Module <name> -Scope CurrentUser`. Local script: run as `.\x.ps1`. |
| `python` opens Microsoft Store | App execution alias intercepting | Settings > Apps > Advanced app settings > App execution aliases: turn off python.exe / python3.exe. Use `py` launcher meanwhile. |
| `pip is not recognized` | pip not on PATH | `py -m pip --version`; use `py -m pip install x`. |
| `npm/node is not recognized` after install | Terminal not restarted or PATH missing `C:\Program Files\nodejs\` | Reopen terminal; `where node`; reinstall with `winget install OpenJS.NodeJS.LTS`. |
| `git is not recognized` | Not installed | `winget install -e --id Git.Git`, reopen terminal. |
| `winget is not recognized` | App Installer missing/old | Update "App Installer" from Microsoft Store; then `winget --version`. |

## Permissions / policy

| Message | Cause | Fix |
|---|---|---|
| `Access is denied.` / `UnauthorizedAccessException` / `Requested registry access is not allowed` | Needs admin, or file locked/protected | Reopen as Admin (Start > type PowerShell > Run as administrator). Check `whoami /groups`. |
| `File ...ps1 cannot be loaded because running scripts is disabled on this system` | Execution policy | `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` (confirm Y). One-off alternative: `powershell -ExecutionPolicy Bypass -File .\x.ps1`. |
| `...is not digitally signed` | Downloaded script blocked (Zone.Identifier) | After inspecting the script: `Unblock-File .\x.ps1`. |
| `The process cannot access the file because it is being used by another process` | File locked | Close the app. Find: `Get-Process` / `tasklist \| findstr name`; or restart Explorer; or reboot then retry. |
| `Cannot remove item ... because it is being used` | Same | Same; then `Remove-Item <path> -Recurse -Force` after confirming path. |

## Paths / files

| Message | Cause | Fix |
|---|---|---|
| `The system cannot find the path specified` / `Cannot find path ... because it does not exist` | Typo, wrong drive, or wrong folder | `dir "<parent>"`. In CMD change drive with `cd /d D:\folder` (plain `cd` does not switch drives). |
| `The system cannot find the file specified` | Wrong filename/extension, hidden extension | `dir /a`; Explorer > View > File name extensions. |
| `The filename, directory name, or volume label syntax is incorrect` | Unquoted spaces, stray quote, bad char | Wrap path in `"..."`; remove trailing `\"`. |
| `The specified path, file name, or both are too long` | >260 chars | Enable long paths: Admin PS: `New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -Value 1 -PropertyType DWORD -Force`; reboot. Or move folder closer to root. |
| Garbled characters / `?` in output | Encoding | CMD: `chcp 65001`. PS: `[Console]::OutputEncoding=[Text.Encoding]::UTF8`. |

## PowerShell syntax

| Message | Cause | Fix |
|---|---|---|
| `The token '&&' is not a valid statement separator in this version` | PS 5.1 | Use `;` or `cmd1; if ($?) { cmd2 }`, or install PowerShell 7 (`winget install Microsoft.PowerShell`). |
| `Missing closing '}'` / `Unexpected token` | Unbalanced braces/quotes, smart quotes from copy-paste | Retype quotes as plain `"` `'`. |
| `A parameter cannot be found that matches parameter name 'x'` | Wrong flag or alias (curl, wget, ls flags) | `Get-Help <cmd> -Parameter *` or use `curl.exe`. |
| `Cannot bind argument to parameter 'Path' because it is null` | Variable empty | `Write-Output $var` to inspect upstream step. |
| `Unable to find type [x]` | Assembly not loaded | `Add-Type -AssemblyName <name>`. |
| `Import-Module: The specified module was not found` | Not installed | `Install-Module <name> -Scope CurrentUser -Force`; if NuGet prompt, accept. |

## Network

| Message | Cause | Fix |
|---|---|---|
| `Ping request could not find host` | DNS issue | `ping 8.8.8.8`: if OK, DNS: `ipconfig /flushdns`; try DNS 8.8.8.8 via Settings. |
| `Request timed out` (to 8.8.8.8) | No connectivity | `ipconfig /all`; check adapter; `ipconfig /release` then `ipconfig /renew`. |
| `Could not create SSL/TLS secure channel` (PS 5.1) | Old TLS default | `[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12` |
| `SSL certificate problem` / `CERT_UNTRUSTED` | Proxy/AV intercepting, wrong clock | Check date/time sync: `w32tm /resync` (Admin). Corporate proxy: ask IT for CA. |
| `Unable to connect to the remote server` | Firewall/proxy/service down | `Test-NetConnection host -Port N`. |
| Port already in use / `EADDRINUSE` / `Address already in use` | Another process | `netstat -ano \| findstr :PORT` to get PID, `tasklist /fi "PID eq <pid>"` to identify, then `taskkill /PID <pid> /F` (confirm first). |
| Persistent weirdness after many fixes | Winsock corruption | Admin: `netsh winsock reset` then reboot (confirm first). |

## System repair

| Symptom | Fix (Admin, in order) |
|---|---|
| Corrupted Windows files, odd system errors | `sfc /scannow`. Expect "found corrupt files and successfully repaired" or "did not find any integrity violations". If it cannot repair: `DISM /Online /Cleanup-Image /RestoreHealth`, then `sfc /scannow` again. |
| `Error: 87` in DISM | Syntax typo: space before each `/`. |
| `Error: 0x800f081f` DISM source not found | Windows Update component issue: run `DISM /Online /Cleanup-Image /StartComponentCleanup`, retry. |
| Disk errors | `chkdsk C: /scan` (read-only). Fixing (`/f`) needs reboot; confirm first. |
| Windows Update stuck | `net stop wuauserv` then `net stop bits`; rename `C:\Windows\SoftwareDistribution` to `.old`; `net start wuauserv` then `net start bits`. (Confirm first.) |

## winget / package managers

| Message | Fix |
|---|---|
| `Failed when searching source: msstore` / source errors | `winget source reset --force` then `winget source update`. |
| `No package found matching input criteria` | `winget search <name>`; use exact `--id`. |
| `0x8a15000f Data required by the source is missing` | `winget source reset --force`. |
| Hash mismatch | Wait/retry; do NOT use `--ignore-security-hash` unless user accepts risk. |
| `npm ERR! EACCES` / `EPERM` | Close editors/AV locking files; run `npm cache verify`; avoid global installs as non-admin: use `npm config set prefix "%APPDATA%\npm"`. |
| `npm ERR! code ERESOLVE` | Dependency conflict: `npm install --legacy-peer-deps` (state the tradeoff). |
| `pip: ... externally-managed / permission denied` | `py -m pip install --user x` or use a venv: `py -m venv .venv` then `.venv\Scripts\activate`. |
| `error: Microsoft Visual C++ 14.0 or greater is required` | Install Build Tools: `winget install Microsoft.VisualStudio.2022.BuildTools`, include "Desktop development with C++". |

## git

| Message | Fix |
|---|---|
| `fatal: not a git repository` | `cd` to repo root or `git init`. |
| `fatal: detected dubious ownership` | `git config --global --add safe.directory "<path>"`. |
| `Filename too long` | `git config --global core.longpaths true`. |
| `Authentication failed` | Use a personal access token or `gh auth login`; never paste the token in chat. |
| CRLF/LF warnings | `git config --global core.autocrlf true`. Harmless warning. |

## WSL

| Message | Fix |
|---|---|
| `wsl is not recognized` or feature missing | Admin: `wsl --install`, reboot. |
| `0x80370102` / virtualization disabled | Enable virtualization (Intel VT-x/AMD-V) in BIOS; Admin: `dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`. |
| `WSL 2 requires an update to its kernel component` | `wsl --update`. |
| Distro will not start | `wsl --shutdown`, then retry; `wsl -l -v` to check state. |

## Services / processes

| Message | Fix |
|---|---|
| `Cannot open <name> service on computer '.'` | Needs Admin. |
| `Service cannot be started... disabled` | `Set-Service <name> -StartupType Manual` (Admin), then `Start-Service <name>`. |
| `Cannot find any service with service name` | `Get-Service *keyword*` for the real name. |
| `ERROR: The process "x.exe" not found` | Already closed; `tasklist \| findstr x`. |

## Unknown error protocol

1. Ask for the exact full message and the command that produced it.
2. Request `echo %errorlevel%` (CMD) or `$Error[0] | Format-List * -Force` (PS).
3. Search the error code (e.g. `0x...`) before inventing a fix. If you cannot verify a fix, say so and give the safest read-only diagnostic.
