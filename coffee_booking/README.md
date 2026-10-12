# Brew & Go — Flutter coffee booking app

A dark coffee pickup app inspired by the supplied reference: orange highlights, large coffee photography, rounded product cards, customisation and bottom navigation. Includes responsive layouts for phones, tablets and wide screens.

## What works

- Browse six sample coffees; search by name and filter by category.
- Save favourites and customise size, milk, sweetness and quantity.
- Add variants to the bag, adjust quantities, remove items and calculate totals in rupees.
- Choose a pickup slot within the next seven days, with a 20-minute lead time.
- Validate customer details and save a booking with its item and price snapshot.
- View and cancel saved bookings. Cart, favourites and bookings persist on the device.
- Photos are bundled: no internet connection is needed to display the menu after installation.

## Run on your computer

Requires Flutter 3.35+ with its bundled Dart 3.9+, and Android Studio/Android SDK for Android builds. Use a supported current stable Flutter release. iOS builds require macOS and Xcode.

1. Extract the ZIP and open `coffee_booking` in VS Code or Android Studio.
2. Run `setup.bat` on Windows, or `bash setup.sh` on macOS/Linux.
3. Connect an Android phone with USB debugging enabled, or start an emulator.
4. Run `flutter run`.

For Chrome: `flutter run -d chrome`.

The setup script generates standard Android, iOS and web platform folders using your installed Flutter SDK, fetches packages and runs analysis/tests. This download contains app source, assets and tests; it is not an APK. Flutter's `create --empty` fills missing scaffold files without overwriting the existing app source.

Manual setup:

```sh
flutter create --empty --platforms=android,ios,web --project-name=coffee_booking .
flutter pub get
flutter analyze
flutter test
flutter run
```

Build an Android APK after setup:

```sh
flutter build apk --release
```

The APK appears at `build/app/outputs/flutter-apk/app-release.apk`. Configure your own signing key and application ID before distributing to a store.

## Source map

| File | Purpose |
| --- | --- |
| `lib/main.dart` | App theme and responsive navigation |
| `lib/responsive.dart` | Breakpoints and grid columns |
| `lib/apis.dart` | Sample menu and API replacement boundary |
| `lib/models.dart` | Coffee, cart, booking and pickup-slot logic |
| `lib/store.dart` | Local state, totals and persistence; no Provider |
| `lib/screens/` | Discover, details, cart, checkout and booking history |
| `lib/widgets/common.dart` | Shared components |

## Demo boundary

This is a functional **local demo**, not a live café service. Menu prices, ratings, café name and hours are sample data. No money is collected; no booking is transmitted to a café. The checkout and booking history say this explicitly. The app does not invent order preparation or delivery tracking.

For real orders, provide a café backend and real menu/availability. Replace `Api.fetchCoffees()` with your API client, and replace local `CoffeeStore.book()` with a server-confirmed request. The backend must own prices, stock, available slots, order IDs and status. Add authentication and an owner/admin workflow as needed. SharedPreferences is for demo persistence and does not provide encrypted, durable server storage. Clearing app/browser data clears the demo history.

## Verification status

Dart syntax was checked with a Dart grammar parser and every bundled image was decoded successfully. Flutter/Dart SDK execution was unavailable in the creation environment; the app has **not** been compiled, rendered or run here, and included Flutter tests have **not** been executed. Run the setup checks locally before relying on the build.

Included tests cover variant totals, lead time and opening hours, booking persistence, cancellation, invalid pickup protection, corrupt local data and responsive menu navigation.

## Manual review checklist

- Search for a coffee, then try a term that has no results.
- Filter the categories and save/remove a favourite.
- Select large + oat milk: the price should include ₹60 + ₹40 above small.
- Add matching variants twice; verify merged quantity and correct totals.
- Remove the last item; verify the empty bag screen.
- Enter invalid customer details; confirm booking is blocked.
- Save tomorrow's pickup; restart the app and confirm the booking remains.
- Cancel that booking, restart, and confirm cancellation remains.
- Check phone, landscape, tablet and desktop layouts.

## References and images

- Flutter responsive design: https://docs.flutter.dev/ui/adaptive-responsive/general
- Flutter SDK installation: https://docs.flutter.dev/get-started/install
- SharedPreferences: https://pub.dev/packages/shared_preferences
- Coffee images are bundled from Unsplash image endpoints, listed in `ASSET_SOURCES.md`.
