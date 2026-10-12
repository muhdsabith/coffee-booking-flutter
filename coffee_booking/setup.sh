#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v flutter >/dev/null 2>&1; then
  echo "Install Flutter 3.35 or newer and add flutter to PATH first."
  exit 1
fi
flutter create --empty --platforms=android,ios,web --project-name=coffee_booking .
dart run tool/apply_branding.dart
flutter pub get
dart format lib test
flutter analyze
flutter test
echo "Ready. Run: flutter run"
