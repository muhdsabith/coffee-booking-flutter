@echo off
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Install Flutter 3.35 or newer and add flutter to PATH first.
  exit /b 1
)
call flutter create --empty --platforms=android,ios,web --project-name=coffee_booking .
if errorlevel 1 exit /b 1
call dart run tool/apply_branding.dart
if errorlevel 1 exit /b 1
call flutter pub get
if errorlevel 1 exit /b 1
call dart format lib test
if errorlevel 1 exit /b 1
call flutter analyze
if errorlevel 1 exit /b 1
call flutter test
if errorlevel 1 exit /b 1
echo Ready. Run: flutter run
