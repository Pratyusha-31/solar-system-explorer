#!/bin/bash

set -e

echo "🚀 Starting Solar System Explorer..."

find_chrome() {
  if [ -n "${CHROME_EXECUTABLE:-}" ] && [ -x "${CHROME_EXECUTABLE}" ]; then
    echo "${CHROME_EXECUTABLE}"
    return 0
  fi

  for candidate in /usr/bin/google-chrome /usr/bin/google-chrome-stable; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

CHROME_BIN="$(find_chrome || true)"

if [ -z "$CHROME_BIN" ]; then
  echo ""
  echo "❌ Web voice output is blocked on this machine."
  echo "   This project is currently opening Snap Chromium, which often exposes zero speech voices."
  echo ""
  echo "Install the required packages:"
  echo "  sudo apt update"
  echo "  sudo apt install espeak-ng speech-dispatcher libspeechd2"
  echo ""
  echo "Install Google Chrome, then run:"
  echo "  CHROME_EXECUTABLE=/usr/bin/google-chrome ./run.sh"
  echo ""
  echo "Browser voice check after install:"
  echo "  speechSynthesis.getVoices()"
  exit 1
fi

export CHROME_EXECUTABLE="$CHROME_BIN"

# Kill any existing process on port 5001
echo "📦 Killing existing backend processes on port 5001..."
lsof -ti:5001 | xargs -r kill -9 2>/dev/null || true

# Wait a moment for port to be released
sleep 1

# Start backend in background
echo "⚡ Starting backend server..."
cd backend && python3 app.py &
BACKEND_PID=$!

# Wait for backend to start
sleep 2

# Start Flutter app
echo "📱 Starting Flutter app with $CHROME_EXECUTABLE..."
flutter run -d chrome &

echo ""
echo "✅ Everything is running!"
echo "   Backend: http://localhost:5001"
echo "   Backend PID: $BACKEND_PID"
echo ""
echo "Press Ctrl+C to stop everything"

# Wait for user to press Ctrl+C
wait
