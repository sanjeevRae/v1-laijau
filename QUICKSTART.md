# Quick Start Guide - Laijau Ride Sharing App

## ✅ Installation Complete

All dependencies have been successfully installed and the project is error-free!

## 🚀 Running the App

### Option 1: Android Emulator/Device
```bash
flutter run
```

### Option 2: iOS Simulator (Mac only)
```bash
flutter run -d ios
```

### Option 3: Web Browser
```bash
flutter run -d chrome
```

## 🔧 Before Running

### 1. Configure Backend URLs

Edit these files to point to your Go backend:

**lib/services/api_service.dart** (Line 11)
```dart
static const String baseUrl = 'http://YOUR-BACKEND-IP:8080/api';
```

**lib/services/socket_service.dart** (Line 11)
```dart
static const String socketUrl = 'http://YOUR-BACKEND-IP:8080';
```

### 2. Test User Types

The app has three user modes:
- **Rider** - Book and track rides
- **Driver** - Accept and complete rides  
- **Admin** - Manage platform

You can switch between modes in the authentication flow based on backend response.

## 📱 App Flow

### Rider Journey
1. **Login** → WhatsApp OTP verification
2. **Home** → Interactive map with current location
3. **Set Locations** → Tap search to set pickup/dropoff
4. **Select Vehicle** → Choose standard/premium/xl
5. **View Fare** → See estimated fare
6. **Request Ride** → Find a driver
7. **Track Driver** → Live location on map
8. **In-Trip** → Navigate to destination
9. **Complete** → Rate your driver

### Driver Journey
1. **Login** → WhatsApp OTP verification
2. **Go Online** → Toggle online status
3. **Receive Request** → New ride notification
4. **Accept Ride** → View pickup/dropoff
5. **Navigate** → Drive to pickup location
6. **Start Ride** → Begin trip
7. **Complete** → End trip and get paid

### Admin Journey
1. **Login** → Admin credentials
2. **Dashboard** → View platform stats
3. **Manage Users** → User administration
4. **Verify Drivers** → Approve/reject drivers
5. **View Analytics** → Platform insights

## 🎯 Features Implemented

✅ Real-time location tracking
✅ OpenStreetMap integration (no API key needed)
✅ Address search with Photon
✅ Fare estimation
✅ WebSocket for live updates
✅ In-app voice/video calls (Jitsi Meet)
✅ Ride history
✅ Rating system
✅ Multi-platform support (Android, iOS, Web)

## 🔌 Backend Requirements

Your Go backend should provide:

### REST Endpoints
- `POST /api/auth/send-otp`
- `POST /api/auth/verify-otp`
- `POST /api/rides/request`
- `GET /api/rides/:id`
- `POST /api/rides/:id/accept`
- `POST /api/rides/:id/start`
- `POST /api/rides/:id/complete`
- `POST /api/rides/:id/cancel`
- `GET /api/rides/history`
- `POST /api/rides/estimate-fare`
- `GET /api/geocode/search`

### WebSocket Events
- `ride_update` - Status changes
- `driver_location` - GPS updates
- `new_ride_request` - For drivers
- `ride_accepted` - For riders
- `ride_cancelled` - Cancellation

## 🛠️ Development Commands

```bash
# Run app in debug mode
flutter run

# Run with specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Hot reload (press 'r' in terminal)
# Hot restart (press 'R' in terminal)

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build web
flutter build web --release

# Run tests
flutter test

# Check code quality
flutter analyze

# Format code
flutter format lib/
```

## 🐛 Troubleshooting

### Android Build Issues
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### iOS Build Issues
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

### Permission Issues (Windows)
If you see symlink errors:
1. Open Settings → Developer Mode
2. Enable Developer Mode
3. Restart terminal
4. Run `flutter pub get` again

### Location Not Working
- Check permissions in AndroidManifest.xml and Info.plist (already configured)
- Test on physical device (emulators may have location issues)
- Ensure location services are enabled on device

## 📦 Project Structure

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── ride_model.dart
│   ├── user_model.dart
│   └── place_model.dart
├── pages/                    # UI screens
│   ├── splash_screen.dart
│   ├── login_page.dart
│   ├── home.dart
│   ├── rider/
│   │   └── rider_home.dart
│   ├── driver/
│   │   └── driver_home.dart
│   ├── admin/
│   │   └── admin_dashboard.dart
│   └── widgets/
│       ├── ride_request_sheet.dart
│       ├── ride_status_card.dart
│       └── address_search_page.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── location_provider.dart
│   └── ride_provider.dart
└── services/                 # Backend services
    ├── api_service.dart
    ├── socket_service.dart
    ├── location_service.dart
    └── call_service.dart
```

## 🎨 Customization

### Change App Name
1. **Android**: `android/app/src/main/AndroidManifest.xml`
2. **iOS**: `ios/Runner/Info.plist`
3. **pubspec.yaml**: Update `name` field

### Change App Icon
```bash
# Install flutter_launcher_icons
flutter pub add flutter_launcher_icons

# Add icon configuration to pubspec.yaml
# Then run:
flutter pub run flutter_launcher_icons
```

### Change Theme Colors
Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Change color
  useMaterial3: true,
  primaryColor: Colors.blue, // Change color
),
```

## 📝 Next Steps

1. ✅ **Frontend Complete** - All UI and features implemented
2. ⏳ **Backend Setup** - Deploy Go REST API
3. ⏳ **Testing** - Test with real backend
4. ⏳ **Payment Integration** - Add payment gateway
5. ⏳ **Push Notifications** - Firebase setup
6. ⏳ **App Store Submission** - Prepare for release

## 🆘 Support

If you encounter issues:
1. Check [IMPLEMENTATION.md](IMPLEMENTATION.md) for detailed architecture
2. Review [README.md](README.md) for setup instructions
3. Ensure backend is running and accessible
4. Test on physical devices for location features

---

**Status**: ✅ Ready to Run (Configure backend URLs first)

Happy coding! 🚀
