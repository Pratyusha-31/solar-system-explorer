# Solar System Explorer

An interactive Flutter app for learning about our Solar System! Explore planets, learn fun facts, and discover scientific data about each celestial body.

## Features

- 🌌 **Interactive Solar System** - Watch planets orbit the Sun in real-time
- ⏸️ **Pause & Learn** - Pause the animation and tap on any planet to learn more
- 👶 **Kid-Friendly** (Class 6-8) - Fun facts with engaging visuals
- 🔬 **Scientific Data** (Class 9-12) - Detailed information including mass, gravity, diameter
- 📱 **Responsive Design** - Works on mobile and desktop

## How to Use

1. **Select your grade level** (Class 6-8 or Class 9-12)
2. **Click "Start Exploring"** to enter the Solar System view
3. **Click Pause** to stop the animation
4. **Click on any planet or the Sun** to see information in the info box
5. **Use Compare mode** to see planet sizes side by side

## Setup

### Flutter App
```bash
flutter pub get
flutter run
```

### Backend Server
```bash
cd backend
pip install flask flask-cors
python app.py
```

The backend runs on `http://localhost:5001`

> **Note:** If running on Android emulator, change `localhost` to `10.0.2.2` in `lib/main.dart`

## Project Structure

```
solar_system_explorer/
├── lib/
│   └── main.dart          # Main Flutter application
├── backend/
│   └── app.py             # Flask backend API
├── test/
│   └── solar_system_test.dart
├── android/               # Android platform files
├── ios/                   # iOS platform files
└── pubspec.yaml          # Flutter dependencies
```

## Tech Stack

- **Frontend:** Flutter, Dart
- **Backend:** Python, Flask, Flask-CORS
- **State Management:** Flutter StatefulWidget with AnimationController

## Screenshots

The app features:
- Animated star field background
- Orbiting planets with real-time position tracking
- Info box showing live status and planet information
- Compare mode for planet size comparison

## License

This project is for educational purposes.
