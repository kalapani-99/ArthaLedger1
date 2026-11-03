#!/usr/bin/env bash
# ==============================================================================
# ArthaLedger — Automated Android APK Builder Script
# Package ID : com.arthaledger.boianalyzer
# Version    : 1.2.0 (12)
# Target URL : https://ais-pre-svjaydfcd433bqpwvr75y2-967070040423.asia-east1.run.app
# ==============================================================================
set -euo pipefail

echo "============================================================"
echo "  Building ArthaLedger Android APK (com.arthaledger.boianalyzer)"
echo "============================================================"

MODE="${1:-capacitor}"

if [ "$MODE" = "twa" ]; then
  echo "[1/3] Checking @bubblewrap/cli..."
  npx --yes @bubblewrap/cli --version
  echo "[2/3] Initializing Android TWA project from twa-manifest.json..."
  npx --yes @bubblewrap/cli update --manifest="./twa-manifest.json" || npx --yes @bubblewrap/cli init --manifest="https://ais-pre-svjaydfcd433bqpwvr75y2-967070040423.asia-east1.run.app/manifest.webmanifest"
  echo "[3/3] Building signed APK..."
  npx --yes @bubblewrap/cli build
  echo "Done! Signed APK generated at: ./app-release-signed.apk"
else
  echo "[1/4] Building production web bundle (dist/)..."
  npm run build
  echo "[2/4] Installing Capacitor Android platform..."
  npm install @capacitor/core @capacitor/cli @capacitor/android
  echo "[3/4] Syncing web assets into Android native project..."
  npx cap add android || npx cap sync android
  echo "[4/4] Compiling debug & release APK via Gradle..."
  cd android && ./gradlew assembleDebug
  echo "Done! Standalone offline APK ready at:"
  echo "  android/app/build/outputs/apk/debug/app-debug.apk"
fi
