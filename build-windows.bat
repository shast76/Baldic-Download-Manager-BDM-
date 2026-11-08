@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo === Baldic Download Manager - Windows build / derleme ===
where python >nul 2>nul || (echo Python not found / bulunamadi. Install from https://www.python.org/downloads/ ^(tick Add to PATH^). & pause & exit /b 1)
python -m pip install --upgrade pip pywebview pystray pillow pyinstaller || (echo Package install failed / Paket kurulumu basarisiz. & pause & exit /b 1)
python -m PyInstaller --noconfirm --clean --onefile --windowed ^
  --name Baldic --icon assets\baldic.ico ^
  --add-data "app\ui;ui" --paths app --collect-submodules webview --collect-submodules pystray ^
  app\baldic.py || (echo Build failed / Derleme basarisiz. & pause & exit /b 1)
echo.
echo Done / Tamam: dist\Baldic.exe
set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if not exist "%ISCC%" set "ISCC=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if not exist "%ISCC%" set "ISCC=%LocalAppData%\Programs\Inno Setup 6\ISCC.exe"
if exist "%ISCC%" (
  "%ISCC%" installer\baldic.iss && echo Setup wizard / Kurulum sihirbazi: dist\Baldic-Setup.exe
) else (
  echo Inno Setup 6 not found - skipping the setup wizard. Install it from https://jrsoftware.org/isdl.php and run this again.
  echo Inno Setup 6 bulunamadi - kurulum sihirbazi atlandi. https://jrsoftware.org/isdl.php adresinden kurup tekrar calistirin.
)
pause
