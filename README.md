# SpotX Fix Guide — New Spotify Versions

Newer versions of Spotify (post ~1.2.14+) extract `xpui.spa` into a plain folder called `xpui/`.
SpotX expects the old `xpui.spa` zip file and errors out if it's missing.

This script works around that by:
1. Zipping the `xpui/` folder into `xpui.spa`
2. Running SpotX (which patches `xpui.spa`)
3. Extracting the patched `xpui.spa` back over the `xpui/` folder
4. Cleaning up

---

## Requirements

- Spotify **standalone** installer (NOT Microsoft Store version)
  - Download from: https://www.spotify.com/download/windows/
- PowerShell (run as Administrator recommended)
- Windows Defender / antivirus may block the SpotX download step — temporarily disable real-time protection if needed

---

## How to Run

1. Open PowerShell as **Administrator**
2. Allow scripts to run (if not already):
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
   ```
3. Navigate to this folder:
   ```powershell
   cd "C:\Users\danny\OneDrive\Desktop\Ongidev\spotx-fix"
   ```
4. Run the script:
   ```powershell
   .\patch-spotify.ps1
   ```
5. Answer the SpotX prompts (hide podcasts, block updates, etc.)
6. Launch Spotify when done

---

## After Patching

Re-apply Spicetify so themes/marketplace still work:
```powershell
spicetify backup apply
```

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `xpui.spa not found` | You're on the Store version — reinstall from spotify.com |
| Script blocked by antivirus | Temporarily disable Windows Defender real-time protection |
| Spotify looks broken after patch | Restore from backup: rename `xpui.backup` back to `xpui` |
| SpotX doesn't support this version | Check https://github.com/SpotX-Official/SpotX for updates |
