# CMD vs PowerShell Equivalents and Recipes

Load only for "how do I..." questions. Give ONE command, not the table.

## Equivalents

| Task | CMD | PowerShell |
|---|---|---|
| List files | `dir` | `ls` / `Get-ChildItem` |
| Show hidden | `dir /a` | `ls -Force` |
| Change folder | `cd /d D:\x` | `cd D:\x` |
| Make folder | `mkdir x` | `mkdir x` |
| Copy | `copy a b` / `xcopy /e /i src dst` | `Copy-Item a b` / `Copy-Item src dst -Recurse` |
| Move / rename | `move a b` / `ren a b` | `Move-Item a b` / `Rename-Item a b` |
| Delete file | `del file` | `Remove-Item file` |
| Delete folder | `rd /s /q x` (confirm) | `Remove-Item x -Recurse -Force` (confirm; preview with `-WhatIf`) |
| Show file | `type f.txt` | `Get-Content f.txt` |
| Last N lines | n/a | `Get-Content f.txt -Tail 20` |
| Search text | `findstr /i "word" f.txt` | `Select-String "word" f.txt` |
| Search recursive | `findstr /s /i "word" *.txt` | `Get-ChildItem -Recurse -Filter *.txt \| Select-String "word"` |
| Find file by name | `dir /s /b name*` | `Get-ChildItem -Recurse -Filter name* -ErrorAction SilentlyContinue` |
| Env var show | `echo %VAR%` | `$env:VAR` |
| Env var set (session) | `set VAR=val` | `$env:VAR="val"` |
| Env var set (permanent, user) | `setx VAR "val"` | `[Environment]::SetEnvironmentVariable("VAR","val","User")` |
| Running processes | `tasklist` | `Get-Process` |
| Kill process | `taskkill /PID n /F` | `Stop-Process -Id n` |
| Services | `sc query` | `Get-Service` |
| IP info | `ipconfig /all` | `Get-NetIPConfiguration` |
| DNS lookup | `nslookup host` | `Resolve-DnsName host` |
| Download file | `curl -L -o f url` | `curl.exe -L -o f url` or `Invoke-WebRequest url -OutFile f` |
| Clear screen | `cls` | `cls` |
| Output to file | `cmd > out.txt 2>&1` | `cmd *> out.txt` |
| Copy output to clipboard | `cmd \| clip` | `cmd \| Set-Clipboard` |

## Recipes

**System info (for diagnosis paste)**
- CMD: `systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"`
- PS: `Get-ComputerInfo OsName,OsVersion,OsArchitecture`

**Disk space**
- CMD: `wmic logicaldisk get caption,freespace,size` (deprecated on new builds)
- PS: `Get-PSDrive -PSProvider FileSystem`

**Largest folders in current dir**
- PS: `Get-ChildItem -Directory | ForEach-Object { [pscustomobject]@{Name=$_.Name; GB=[math]::Round((Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum/1GB,2)} } | Sort GB -Desc`

**Find what is using a port**
- CMD: `netstat -ano | findstr :3000` then `tasklist /fi "PID eq <pid>"`
- PS: `Get-NetTCPConnection -LocalPort 3000 | Select OwningProcess` then `Get-Process -Id <pid>`

**Wi-Fi saved profiles (no passwords)**
- CMD: `netsh wlan show profiles`

**Network reset (confirm, Admin, reboot after)**
- `ipconfig /flushdns` then `netsh winsock reset` then `netsh int ip reset`

**Installed apps list**
- `winget list`

**Upgrade all apps**
- `winget upgrade --all` (shows list first with `winget upgrade`)

**Create venv and install**
- `py -m venv .venv` then `.venv\Scripts\activate` then `pip install -r requirements.txt`

**Run last command as admin**
- Open new Admin terminal; there is no safe in-place elevation in CMD.

**Check a downloaded file hash**
- CMD: `certutil -hashfile file.exe SHA256`
- PS: `Get-FileHash file.exe -Algorithm SHA256`

**Schedule a task (user level)**
- `schtasks /create /tn "MyTask" /tr "C:\path\script.bat" /sc daily /st 09:00`

**Export command output to share**
- `cmd > "%USERPROFILE%\Desktop\out.txt" 2>&1` then ask user to paste (redact secrets).

## Redaction reminder
Before pasting output: remove usernames in paths if private, tokens, keys, passwords, Wi-Fi keys, license keys, emails.
