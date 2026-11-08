# Baldic Download Manager

🇬🇧 English · 🇹🇷 [Türkçe](README.tr.md)

An open-source (MIT) IDM-style download manager with a **Material 3 Expressive** interface, yt-dlp / ffmpeg support and a Chrome extension. It runs as a standalone desktop app (its own window, no browser).

![Dark theme](docs/screenshot-dark-en.png)

## Features
- **Multi-connection downloads** (1–16 segments per file), pause / resume, resume after restart, queue (N at a time)
- **Chrome extension:** captures downloads started in Chrome, forwards cookies/referer, and the **Baldic desktop window comes to the front** with the download options (file name, folder, format). Nothing opens inside Chrome.
- **YouTube and hundreds of sites** (yt-dlp): quality selection (best … 360p), MP4 / MKV / WEBM, audio only (MP3, M4A, OPUS, FLAC, WAV, AAC), cover-image download (JPG / PNG / WEBP), embed subtitles / cover / tags
- **Format conversion** (ffmpeg): video (MP4, MKV, WEBM, MOV, AVI, GIF), audio, **photos** (JPG, PNG, WEBP, AVIF, BMP, TIFF, GIF); quality and resolution choice; optional automatic conversion after download
- Categories, context menu, paste a link with Ctrl+V, drag & drop
- Two themes: **Dark** (default) and **Orange** (`#ee8206` background, `#b44900` accent, `#3e180d` buttons)
- **English / Turkish UI** (Settings → Language; follows the system language by default)
- One-click install/update of yt-dlp and ffmpeg under **Settings → Tools** (Windows / Linux; on macOS use `brew install ffmpeg`)

## Install

### Setup wizard (Windows, recommended)
`Baldic-Setup.exe` installs Baldic with a step-by-step wizard (English / Turkish): install folder, Start-menu and desktop shortcuts, optional *start with Windows*, the Chrome extension folder, and a clean uninstaller. No admin rights needed (per-user install by default).
- After uploading the project to GitHub: **Actions → Build Windows exe → Run workflow**. `Baldic-Setup.exe`, the portable `Baldic.exe` and the extension zip appear under *Artifacts*. Push a tag such as `v1.0.0` to also attach them to a *Release*.
- Or on your own PC: install Python 3.8+ and [Inno Setup 6](https://jrsoftware.org/isdl.php), then double-click `build-windows.bat` → `dist\Baldic.exe` and `dist\Baldic-Setup.exe` (without Inno Setup you still get the portable `Baldic.exe`).

`Baldic.exe` alone is a portable single file with its own window (it uses Windows' built-in WebView2).

### Background mode
Under **Settings → Background** you choose whether closing the window keeps Baldic running in the **system tray** (default: on), whether it **starts with Windows**, and whether it then starts **minimised to the tray**. Left-click the tray icon to open the window, right-click for *Pause all / Resume all / Quit*. Run with `--hidden` to start in the tray manually.

### Run from source
```bash
pip install pywebview               # native window
python app/baldic.py                # Windows: start-windows.bat, Linux/macOS: ./start.sh
python app/baldic.py --browser      # open in a web browser instead of a window
python app/baldic.py --no-window    # run in the background
```
Then install yt-dlp and ffmpeg under **Settings → Tools** (or install them yourself and add them to PATH).

### Chrome extension
1. Open `chrome://extensions` and turn on **Developer mode** (top right)
2. **Load unpacked** → choose the `extension/` folder of this project
3. With Baldic running, start a download in Chrome: the Baldic window comes up. If Baldic is not running, the extension stays out of the way and Chrome downloads normally.

Use the toolbar icon to turn capturing off or to choose **Download the video on this page**. The extension follows Chrome's UI language (English / Turkish).

### Troubleshooting
- **"Port 6877 is busy" message:** an earlier Baldic may still be running in the background. The new version detects this: it brings the open window to the front, or closes a windowless leftover process and takes over. If another program uses the port, start with `Baldic.exe --port 6900` (the extension expects 6877).

## Architecture
```
Chrome ──(extension)──► POST /api/pending ──► Baldic (Python, http://127.0.0.1:6877)
                                                ├─ segmented HTTP engine
                                                ├─ yt-dlp process (progress parsing)
                                                ├─ ffmpeg process (conversion)
                                                └─ Web UI (app/ui) shown in a native window (pywebview)
```

## Security
The server binds to `127.0.0.1` only and checks `Host` and `Origin` (websites cannot reach the API; only the app UI and the extension can). Only `http(s)` links are accepted. Cookies are not sent on cross-domain redirects.

## Tests
```bash
python -m unittest discover tests -v   # conversion tests run when ffmpeg is on PATH
```
yt-dlp is simulated in the tests by `tests/fake_ytdlp.py`.

## Known limits / roadmap
- Real YouTube downloads could not be tried while writing this (the sandbox had no internet); the yt-dlp integration is tested at the output-format and command-line level. If YouTube breaks, update yt-dlp; recent versions may also need a JavaScript runtime (Deno) — see the yt-dlp wiki.
- To do: tray icon, scheduler, speed limit, Firefox extension, playlists, checksum verification.

## License
MIT — see [LICENSE](LICENSE).
