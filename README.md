<!-- Typing animation header -->
<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=26&duration=3500&pause=500&color=14B8A6&center=true&vCenter=true&width=500&lines=Laijau+App;Ride+Sharing+Made+Easy;Flutter+%2B+Go" alt="Typing SVG" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.22%2B-02569B?style=flat-square&logo=flutter" />
  <img src="https://img.shields.io/badge/Backend-Go-00ADD8?style=flat-square&logo=go" />
  <img src="https://img.shields.io/badge/Maps-OpenStreetMap-7F8C8D?style=flat-square&logo=openstreetmap" />
  <img src="https://img.shields.io/badge/RealTime-WebSocket-4A90E2?style=flat-square" />
  <img src="https://img.shields.io/badge/Video-Jitsi_Meet-00B8D4?style=flat-square" />
</p>

---

## 📱 Laijau – Ride Sharing App

![App Banner](https://chitratech.com.np/mobileview1-optimized.webp)


**Laijau** is a complete ride‑sharing solution built with **Flutter** for riders, drivers, and administrators.  
It features real‑time location tracking, fare estimation, live driver tracking, in‑app video calls, and WhatsApp OTP authentication – all powered by a **Go backend**.

---

## ✨ Features

### 👤 For Riders
- 📍 Real‑time location tracking (OpenStreetMap + `flutter_map`)
- 🔍 Address search with autocomplete (Photon service)
- 💰 Fare estimation before booking
- 🚗 Live driver tracking on map
- 📞 In‑app voice & video calls (Jitsi Meet SDK)
- 📜 Ride history and driver ratings
- 🔐 Secure WhatsApp OTP authentication

### 🚛 For Drivers
- 🔛 Online/offline status toggle
- 🔔 Real‑time ride requests (WebSocket)
- 🧭 Live navigation to pickup & dropoff
- 💵 Earnings tracking & trip history
- ⭐ Passenger ratings

### 👑 For Admins
- 📊 Dashboard with platform analytics
- 👥 User management & driver verification
- 🚖 Ride oversight & dispute handling
- 📈 Real‑time platform overview

---

## 🧱 Tech Stack

| Category       | Technologies                                                                 |
|----------------|------------------------------------------------------------------------------|
| **Frontend**   | Flutter (Dart) – iOS, Android, Web                                          |
| **Maps**       | `flutter_map` + OpenStreetMap, `geolocator`                                 |
| **Real‑time**  | `socket_io_client` (WebSockets)                                             |
| **Video Calls**| `jitsi_meet_flutter_sdk`                                                    |
| **HTTP**       | `dio`                                                                        |
| **State**      | `provider`                                                                   |
| **Backend**    | Go (REST API + WebSocket) – [repo link]                                     |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android Studio / Xcode (for mobile builds)
- A running **Go backend** (REST + WebSocket)

### 1. Clone the repository

git clone https://github.com/your-org/laijau-app.git
cd laijau-app

### 2. Install Flutter dependencies
flutter pub get

### 3. Configure backend URLs
Open the following files and replace `YOUR_BACKEND_URL` with your actual backend address (e.g., `http://192.168.1.100:8080` or `https://api.laijau.com`).

'lib/services/api_service.dart'
static const String baseUrl = 'YOUR_BACKEND_URL/api';

### 4. Run the app

# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d chrome

### 📁 Project Structure
lib/
├── main.dart                 # App entry point
├── models/                   # Data models (User, Ride, etc.)
├── pages/                    
│   ├── rider/               # Rider screens (home, booking, history)
│   ├── driver/              # Driver screens (requests, earnings)
│   ├── admin/               # Admin dashboard & panels
│   └── widgets/             # Reusable UI components
├── providers/                # State management (Provider)
└── services/                 # API, WebSocket, Jitsi services


### 🔌 Expected Backend API Endpoints
Your Go backend should implement these minimal REST endpoints and WebSocket events.

# Authentication

Method	Endpoint	Description
POST	/api/auth/send-otp	Send OTP via WhatsApp
POST	/api/auth/verify-otp	Verify OTP & return JWT

# Rides

Method	Endpoint	Description
POST	/api/rides/request	Create a new ride request
POST	/api/rides/:id/accept	Driver accepts ride
POST	/api/rides/:id/start	Start ride (pickup)
POST	/api/rides/:id/complete	Complete ride & calculate fare
GET	/api/rides/history	Get ride history for user

# WebSocket Events (socket.io)

Event name	Direction	Payload
new_ride_request	Server → Drivers	Ride object (location, price)
ride_update	Server → Rider	Status change (accepted, started, etc.)
driver_location	Driver → Server	Current lat/lng (live tracking)
driver_location	Server → Rider	Driver’s live position


### 🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

<p align="center"> Built with 💙 using Flutter </p>
