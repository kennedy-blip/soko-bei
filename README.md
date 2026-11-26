# SokoBei

**Market Price Benchmark · Unit Cost · Trader Margin OS**

SokoBei is an offline-first Flutter application for market traders. It stores market quotes and daily purchase, sale and spoilage entries locally, calculates cost per local unit and provides a daily margin snapshot.

## Features
- Market price observations by commodity, market, date, unit and quantity.
- Unit cost calculation for kg, bag, crate, gorogoro, tin and piece.
- Daily purchase, sale and spoilage ledger with estimated net margin.
- Watchlist flags tagged perishables and recorded prices at least 15% above another observation for the same commodity.
- Three visual themes and Market Lead / Buyer-Stall Clerk role switch.
- Local persistence with SharedPreferences (web local storage on Flutter Web; platform preferences on Android).
- Responsive Flutter navigation and glass-style panels.

## Run locally
Install Flutter stable and Android Studio / Android SDK as appropriate.

```bash
flutter create --platforms=web,android --project-name soko_bei .
flutter pub get
flutter run -d chrome
# Android
flutter run
```

## Vercel deployment
The repository includes `scripts/vercel-build.sh`, which installs Flutter stable in the Vercel build environment, generates the web platform scaffold, and builds the static bundle. Import `kennedy-blip/soko-bei` into Vercel with:
- Framework preset: **Other**
- Build command: `bash scripts/vercel-build.sh`
- Output directory: `build/web`

## Android APK
GitHub Actions generates the Android platform scaffold, runs analysis, builds the web app and compiles the release APK. Run the workflow manually from **Actions → Flutter build and Android release → Run workflow** to publish the APK asset. The Settings screen links to:
https://github.com/kennedy-blip/soko-bei/releases/latest/download/soko-bei.apk

## Notes
- Prices and ledger values are user-entered; no live market-feed integration is claimed.
- The role switch is a local UI privilege mode, not authenticated or server-enforced access control.
- Net margin is estimated as sales revenue minus recorded purchases and spoilage amounts in the device's ledger.
