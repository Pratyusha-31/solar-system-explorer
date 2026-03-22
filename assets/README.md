# Assets Folder Structure

This folder contains images and sounds for the Solar System Explorer app.

## Folder Structure

```
assets/
├── images/
│   ├── characters/
│   │   ├── bujji_robot.png      # Bujji robot character (for Telugu mode)
│   │   ├── bujji_space_bike.png # Bujji on space bike/vehicle
│   │   └── john_astronaut.png   # John astronaut (for English mode)
│   ├── planets/
│   │   ├── sun.png
│   │   ├── mercury.png
│   │   ├── venus.png
│   │   ├── earth.png
│   │   ├── mars.png
│   │   ├── jupiter.png
│   │   ├── saturn.png
│   │   ├── uranus.png
│   │   └── neptune.png
│   └── ui/
│       ├── space_background.png
│       └── star_particle.png
└── sounds/
    ├── background_space.mp3      # Ambient space music (looping)
    ├── fly_whiz.mp3             # Character flying sound effect
    ├── planet_arrival.mp3        # Arrival at planet sound
    ├── correct_answer.mp3        # Correct answer celebration
    └── wrong_answer.mp3          # Wrong answer encouragement
```

## Adding Assets

### Images (PNG format, transparent background recommended)

1. **Characters**: 512x512 PNG with transparent background
   - `bujji_robot.png`: Cute cartoon robot character for Telugu
   - `bujji_space_bike.png`: Bujji riding a small space vehicle/bike
   - `john_astronaut.png`: Friendly astronaut for English

2. **Planets**: 256x256 PNG with transparent background
   - Each planet with simple, cartoon-style design
   - Consistent art style across all planets

### Sounds (MP3 format)

1. **background_space.mp3**: 30-60 second ambient space music that loops
   - Should be subtle, not distracting
   - Duration: 30-60 seconds, seamless loop

2. **fly_whiz.mp3**: Quick whoosh sound (0.5-1 second)
   - Character moving through space

3. **planet_arrival.mp3**: Magical/chime sound (1-2 seconds)
   - When arriving at each planet

4. **correct_answer.mp3**: Celebration sound (1-2 seconds)
   - Positive feedback for correct answers

5. **wrong_answer.mp3**: Gentle encouragement (1-2 seconds)
   - Not discouraging, just "try again" tone

## Current Implementation

The app currently uses emoji-based characters and gradient-based planets.
When real assets are added, update `main.dart` to use `AssetImage` instead
of emojis for characters and planets.

## Asset Sources

You can create assets using:
- **Canva** (canva.com)
- **Figma** (figma.com)
- **DALL-E** or **Midjourney** for AI-generated art
- Or hire an artist on Fiverr/Upwork

Recommended style: Flat design, cartoon/illustrated, colorful but not overwhelming
