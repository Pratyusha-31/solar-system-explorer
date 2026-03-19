#!/bin/bash

echo "🚀 Starting Solar System Explorer..."

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
echo "📱 Starting Flutter app..."
flutter run -d chrome &

echo ""
echo "✅ Everything is running!"
echo "   Backend: http://localhost:5001"
echo "   Backend PID: $BACKEND_PID"
echo ""
echo "Press Ctrl+C to stop everything"

# Wait for user to press Ctrl+C
wait
