from flask import Flask, jsonify, request
from flask_cors import CORS
from openai import OpenAI
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

PLANET_DATA = {
    "sun": {
        "name": "Sun",
        "simple_facts": [
            "The Sun is a star at the center of our Solar System!",
            "It is about 4.6 billion years old.",
            "The Sun is so big that 1.3 million Earths could fit inside it!",
            "It gives us light and warmth every day."
        ],
        "scientific_data": {
            "mass": "1.989 × 10^30 kg",
            "gravity": "274 m/s²",
            "diameter": "1,392,700 km",
            "temperature": "5,500°C (surface), 15 million °C (core)",
            "composition": "Hydrogen (73%), Helium (25%)",
            "rotation_period": "25 Earth days (equator)"
        }
    },
    "mercury": {
        "name": "Mercury",
        "simple_facts": [
            "Mercury is the smallest planet and closest to the Sun!",
            "A day on Mercury is longer than its year!",
            "Mercury has no atmosphere, so it's very hot and very cold.",
            "You could fit about 18 Mercurys inside Earth!"
        ],
        "scientific_data": {
            "mass": "3.285 × 10^23 kg",
            "gravity": "3.7 m/s²",
            "diameter": "4,879 km",
            "orbital_period": "88 Earth days",
            "rotation_period": "59 Earth days",
            "distance_from_sun": "57.9 million km"
        }
    },
    "venus": {
        "name": "Venus",
        "simple_facts": [
            "Venus is the hottest planet in our Solar System!",
            "It spins backwards compared to other planets!",
            "Venus is called Earth's twin because they're similar in size.",
            "A day on Venus is longer than its year!"
        ],
        "scientific_data": {
            "mass": "4.867 × 10^24 kg",
            "gravity": "8.87 m/s²",
            "diameter": "12,104 km",
            "orbital_period": "225 Earth days",
            "rotation_period": "243 Earth days",
            "distance_from_sun": "108.2 million km"
        }
    },
    "earth": {
        "name": "Earth",
        "simple_facts": [
            "Earth is our home planet!",
            "It's the only planet known to have life.",
            "About 71% of Earth is covered with water!",
            "Earth is the third planet from the Sun."
        ],
        "scientific_data": {
            "mass": "5.972 × 10^24 kg",
            "gravity": "9.8 m/s²",
            "diameter": "12,742 km",
            "orbital_period": "365.25 days",
            "rotation_period": "24 hours",
            "distance_from_sun": "149.6 million km"
        }
    },
    "mars": {
        "name": "Mars",
        "simple_facts": [
            "Mars is called the Red Planet because of its rusty color!",
            "Mars has the biggest volcano in the Solar System!",
            "There might have been water on Mars long ago.",
            "A day on Mars is almost the same length as a day on Earth!"
        ],
        "scientific_data": {
            "mass": "6.39 × 10^23 kg",
            "gravity": "3.71 m/s²",
            "diameter": "6,779 km",
            "orbital_period": "687 Earth days",
            "rotation_period": "24.6 hours",
            "distance_from_sun": "227.9 million km"
        }
    },
    "jupiter": {
        "name": "Jupiter",
        "simple_facts": [
            "Jupiter is the biggest planet in our Solar System!",
            "It has at least 95 moons!",
            "Jupiter is a gas giant - it has no solid surface.",
            "The Great Red Spot is a storm that has lasted for hundreds of years!"
        ],
        "scientific_data": {
            "mass": "1.898 × 10^27 kg",
            "gravity": "24.79 m/s²",
            "diameter": "139,820 km",
            "orbital_period": "11.86 Earth years",
            "rotation_period": "9.9 hours",
            "distance_from_sun": "778.5 million km",
            "moons": "95 known moons"
        }
    },
    "saturn": {
        "name": "Saturn",
        "simple_facts": [
            "Saturn is famous for its beautiful rings!",
            "Saturn is so light it could float in water!",
            "It has at least 146 moons.",
            "Saturn's rings are made of ice and rock."
        ],
        "scientific_data": {
            "mass": "5.683 × 10^26 kg",
            "gravity": "10.44 m/s²",
            "diameter": "116,460 km",
            "orbital_period": "29.46 Earth years",
            "rotation_period": "10.7 hours",
            "distance_from_sun": "1.4 billion km",
            "rings": "7 main rings, 100,000 km wide but only 10 m thick"
        }
    },
    "uranus": {
        "name": "Uranus",
        "simple_facts": [
            "Uranus spins on its side - it looks like it's rolling!",
            "It was the first planet discovered with a telescope.",
            "Uranus has 27 moons named after characters from Shakespeare.",
            "It's called an ice giant because it has icy materials inside."
        ],
        "scientific_data": {
            "mass": "8.681 × 10^25 kg",
            "gravity": "8.87 m/s²",
            "diameter": "50,724 km",
            "orbital_period": "84 Earth years",
            "rotation_period": "17.2 hours",
            "distance_from_sun": "2.9 billion km",
            "rotation_axis": "97.77° (sideways)"
        }
    },
    "neptune": {
        "name": "Neptune",
        "simple_facts": [
            "Neptune is the farthest planet from the Sun!",
            "It has the strongest winds in the Solar System!",
            "Neptune is so far away it takes 165 Earth years to orbit the Sun.",
            "It was discovered using math before it was seen with a telescope!"
        ],
        "scientific_data": {
            "mass": "1.024 × 10^26 kg",
            "gravity": "11.15 m/s²",
            "diameter": "49,244 km",
            "orbital_period": "164.8 Earth years",
            "rotation_period": "16.1 hours",
            "distance_from_sun": "4.5 billion km",
            "wind_speeds": "2,100 km/h"
        }
    }
}

QUIZ_FALLBACK_DATA = {
    6: [
        {"question": "Which planet is known as the Red Planet?", "options": ["Venus", "Mars", "Jupiter", "Saturn"], "correct_answer": "Mars"},
        {"question": "What is the largest planet in our Solar System?", "options": ["Saturn", "Earth", "Jupiter", "Neptune"], "correct_answer": "Jupiter"},
        {"question": "Which planet has beautiful rings around it?", "options": ["Mars", "Venus", "Saturn", "Mercury"], "correct_answer": "Saturn"},
        {"question": "What is the name of our home planet?", "options": ["Mars", "Venus", "Earth", "Neptune"], "correct_answer": "Earth"},
        {"question": "Which planet is closest to the Sun?", "options": ["Venus", "Mercury", "Mars", "Earth"], "correct_answer": "Mercury"},
        {"question": "How many planets are in our Solar System?", "options": ["6", "7", "8", "9"], "correct_answer": "8"},
        {"question": "Which planet is the hottest in our Solar System?", "options": ["Mercury", "Venus", "Mars", "Earth"], "correct_answer": "Venus"},
        {"question": "Which planet is called Earth's twin?", "options": ["Mars", "Venus", "Mercury", "Neptune"], "correct_answer": "Venus"},
        {"question": "Which planet has the most moons?", "options": ["Earth", "Mars", "Jupiter", "Saturn"], "correct_answer": "Saturn"},
        {"question": "What is the Sun?", "options": ["A planet", "A star", "A moon", "A galaxy"], "correct_answer": "A star"},
        {"question": "Which planet spins on its side?", "options": ["Neptune", "Uranus", "Saturn", "Jupiter"], "correct_answer": "Uranus"},
        {"question": "Which planet is farthest from the Sun?", "options": ["Uranus", "Saturn", "Neptune", "Pluto"], "correct_answer": "Neptune"},
        {"question": "What are Saturn's rings made of?", "options": ["Gas", "Rock and ice", "Dust only", "Fire"], "correct_answer": "Rock and ice"},
        {"question": "Which planet has a big red spot?", "options": ["Mars", "Saturn", "Jupiter", "Neptune"], "correct_answer": "Jupiter"},
        {"question": "How long does it take light from the Sun to reach Earth?", "options": ["8 seconds", "8 minutes", "8 hours", "8 days"], "correct_answer": "8 minutes"},
        {"question": "Which planet is known for having water and life?", "options": ["Mars", "Earth", "Venus", "Mercury"], "correct_answer": "Earth"},
        {"question": "What is the smallest planet?", "options": ["Mars", "Mercury", "Venus", "Earth"], "correct_answer": "Mercury"},
        {"question": "Which planet is called the Red Planet?", "options": ["Venus", "Earth", "Mars", "Jupiter"], "correct_answer": "Mars"},
        {"question": "What shape is the Earth?", "options": ["Flat", "Square", "Round (sphere)", "Triangle"], "correct_answer": "Round (sphere)"},
        {"question": "Which planet has the Great Red Spot?", "options": ["Mars", "Earth", "Jupiter", "Saturn"], "correct_answer": "Jupiter"},
    ],
    9: [
        {"question": "What is the approximate orbital period of Jupiter around the Sun?", "options": ["12 Earth years", "6 months", "29 Earth years", "165 Earth years"], "correct_answer": "12 Earth years"},
        {"question": "Which planet has the fastest rotation period (shortest day)?", "options": ["Earth", "Mars", "Jupiter", "Mercury"], "correct_answer": "Jupiter"},
        {"question": "What is the mass of the Sun compared to Earth?", "options": ["100 times", "10,000 times", "333,000 times", "1 million times"], "correct_answer": "333,000 times"},
        {"question": "Which planet is classified as an ice giant?", "options": ["Jupiter", "Saturn", "Uranus", "Mars"], "correct_answer": "Uranus"},
        {"question": "What is the approximate diameter of Earth?", "options": ["6,779 km", "12,742 km", "50,724 km", "139,820 km"], "correct_answer": "12,742 km"},
        {"question": "What percentage of the Solar System's mass is in the Sun?", "options": ["50%", "75%", "99%", "100%"], "correct_answer": "99%"},
        {"question": "What is the temperature at the Sun's core?", "options": ["5,500°C", "15 million °C", "100,000°C", "1 million °C"], "correct_answer": "15 million °C"},
        {"question": "How long does it take Mercury to orbit the Sun?", "options": ["29 Earth years", "88 Earth days", "365 Earth days", "687 Earth days"], "correct_answer": "88 Earth days"},
        {"question": "What is Saturn's density compared to water?", "options": ["2x denser", "Same density - would float", "10x denser", "Half as dense"], "correct_answer": "Same density - would float"},
        {"question": "What causes seasons on Earth?", "options": ["Distance from Sun", "Earth's tilted axis", "Moon's gravity", "Solar flares"], "correct_answer": "Earth's tilted axis"},
        {"question": "What is the approximate escape velocity from Earth?", "options": ["1 km/s", "11 km/s", "50 km/s", "100 km/s"], "correct_answer": "11 km/s"},
        {"question": "Which planet has the tallest volcano in the Solar System?", "options": ["Earth", "Venus", "Mars", "Jupiter"], "correct_answer": "Mars"},
        {"question": "What is the main component of Jupiter's atmosphere?", "options": ["Oxygen", "Carbon dioxide", "Hydrogen and Helium", "Nitrogen"], "correct_answer": "Hydrogen and Helium"},
        {"question": "How many Earth days is one rotation of Venus?", "options": ["24 hours", "59 days", "243 days", "365 days"], "correct_answer": "243 days"},
        {"question": "What causes Mars to appear red?", "options": ["Copper", "Iron oxide (rust)", "Sulfur", "Methane"], "correct_answer": "Iron oxide (rust)"},
        {"question": "What is the Kuiper Belt?", "options": ["A moon of Saturn", "A ring of asteroids between Mars and Jupiter", "A region beyond Neptune with icy bodies", "The Sun's outer atmosphere"], "correct_answer": "A region beyond Neptune with icy bodies"},
        {"question": "What is the approximate surface temperature of Mercury?", "options": ["-50°C to 0°C", "0°C to 50°C", "-180°C to 430°C", "100°C to 500°C"], "correct_answer": "-180°C to 430°C"},
        {"question": "Which moon in our Solar System has a thick atmosphere?", "options": ["Phobos", "Titan", "Europa", "Ganymede"], "correct_answer": "Titan"},
        {"question": "What is the approximate speed of solar wind?", "options": ["100 km/s", "450 km/s", "1000 km/s", "10,000 km/s"], "correct_answer": "450 km/s"},
        {"question": "How was Neptune discovered?", "options": ["By telescope", "By spacecraft", "Using mathematical predictions", "By accident"], "correct_answer": "Using mathematical predictions"},
    ]
}


def get_random_quiz(grade_int, count=5):
    import random
    questions = QUIZ_FALLBACK_DATA.get(grade_int, QUIZ_FALLBACK_DATA[6])
    shuffled = questions.copy()
    random.shuffle(shuffled)
    return shuffled[:count]


@app.route('/')
def index():
    return jsonify({
        "message": "Welcome to Solar System Explorer API",
        "endpoints": {
            "planet_info": "/planet/<planet_name>?grade=<grade>",
            "live_rotation": "/live/<planet_name>?grade=<grade>",
            "quiz": "/quiz?grade=<grade>"
        }
    })


@app.route('/quiz', methods=['GET'])
def get_quiz():
    grade = request.args.get('grade', '6')
    grade_int = int(grade)
    
    planet_list = list(PLANET_DATA.keys())
    grade_level = "Class 6-8" if grade_int <= 8 else "Class 9-12"
    
    if grade_int <= 8:
        difficulty = "simple and fun for young learners (Class 6-8)"
        question_type = "basic facts about planets"
    else:
        difficulty = "slightly more detailed for older students (Class 9-12)"
        question_type = "scientific data and facts about planets"
    
    system_prompt = """You are an educational quiz generator for a Solar System Explorer app. 
Generate exactly 5 multiple-choice quiz questions about our Solar System that are educational and age-appropriate.
Each question must have exactly 4 options with one correct answer.

Format your response as a valid JSON array with this exact structure:
[
    {
        "question": "The question text here?",
        "options": ["Option A", "Option B", "Option C", "Option D"],
        "correct_answer": "The correct option"
    },
    ... (4 more questions)
]

Make sure:
- Questions are clear and easy to understand
- Options are plausible but only one is correct
- Questions cover different planets and solar system concepts
- JSON is valid and parseable
"""
    
    user_prompt = f"""Generate 5 multiple-choice quiz questions about our Solar System that are {difficulty}.
Include questions about: Sun, Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune.

Focus on: {question_type}

Generate the questions now in valid JSON format."""

    try:
        api_key = os.getenv('OPENAI_API_KEY')
        if not api_key:
            raise ValueError("Missing OpenAI API key")
        
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=0.7,
            max_tokens=2000
        )
        
        content = response.choices[0].message.content.strip()
        
        if content.startswith('```json'):
            content = content[7:]
        if content.startswith('```'):
            content = content[3:]
        if content.endswith('```'):
            content = content[:-3]
        
        import json
        quiz_data = json.loads(content.strip())
        
        return jsonify({
            "success": True,
            "grade_level": grade_level,
            "quiz": quiz_data
        })
        
    except Exception as e:
        import logging
        logging.error(f"OpenAI API error: {str(e)}")
        fallback_quiz = get_random_quiz(grade_int, 5)
        return jsonify({
            "success": False,
            "grade_level": grade_level,
            "quiz": fallback_quiz,
            "message": "Using offline quiz questions",
            "error": str(e)
        })


@app.route('/planet/<planet_name>', methods=['GET'])
def get_planet_info(planet_name):
    grade = request.args.get('grade', '6')
    planet_lower = planet_name.lower()
    
    if planet_lower not in PLANET_DATA:
        return jsonify({
            "error": f"Planet '{planet_name}' not found. Available planets: {', '.join(PLANET_DATA.keys())}"
        }), 404
    
    planet = PLANET_DATA[planet_lower]
    grade_int = int(grade)
    
    if grade_int <= 8:
        return jsonify({
            "name": planet["name"],
            "position": get_planet_position(planet_lower),
            "facts": planet["simple_facts"],
            "grade_level": f"Class {grade}"
        })
    else:
        return jsonify({
            "name": planet["name"],
            "position": get_planet_position(planet_lower),
            "facts": planet["simple_facts"],
            "mass": planet["scientific_data"]["mass"],
            "gravity": planet["scientific_data"]["gravity"],
            "diameter": planet["scientific_data"]["diameter"],
            "orbital_period": planet["scientific_data"].get("orbital_period", "N/A"),
            "rotation_period": planet["scientific_data"].get("rotation_period", "N/A"),
            "distance_from_sun": planet["scientific_data"].get("distance_from_sun", "N/A"),
            "grade_level": f"Class {grade}"
        })


@app.route('/live/<planet_name>', methods=['GET'])
def get_live_planet_info(planet_name):
    grade = request.args.get('grade', '6')
    planet_lower = planet_name.lower()
    
    if planet_lower not in PLANET_DATA:
        return jsonify({
            "error": f"Planet '{planet_name}' not found."
        }), 404
    
    rotation_data = get_live_planet_rotation(planet_lower, int(grade))
    return jsonify(rotation_data)


@app.route('/user_rotation', methods=['POST'])
def post_user_rotation():
    import time
    data = request.get_json()
    angle = data.get('angle', 0)
    planet_name = data.get('planet', 'none')
    is_paused = data.get('is_paused', False)
    
    current_time = time.time()
    
    return jsonify({
        "user_angle": angle,
        "user_angle_degrees": round(angle * 180 / 3.14159, 1),
        "planet": planet_name,
        "is_paused": is_paused,
        "status": "PAUSED - User rotating" if is_paused else "ORBITING",
        "timestamp": current_time,
        "live_update": f"View rotated {round(angle * 180 / 3.14159, 1)}° from original position"
    })


def get_planet_position(planet_name):
    positions = {
        "sun": "Center of the Solar System",
        "mercury": "1st planet from the Sun",
        "venus": "2nd planet from the Sun",
        "earth": "3rd planet from the Sun",
        "mars": "4th planet from the Sun",
        "jupiter": "5th planet from the Sun",
        "saturn": "6th planet from the Sun",
        "uranus": "7th planet from the Sun",
        "neptune": "8th planet from the Sun"
    }
    return positions.get(planet_name, "Unknown")


def get_live_planet_rotation(planet_name, grade):
    import time
    
    planet = PLANET_DATA[planet_name]
    
    rotation_periods = {
        "sun": 25 * 86400,
        "mercury": 59 * 86400,
        "venus": 243 * 86400,
        "earth": 86400,
        "mars": 24.6 * 3600,
        "jupiter": 9.9 * 3600,
        "saturn": 10.7 * 3600,
        "uranus": 17.2 * 3600,
        "neptune": 16.1 * 3600
    }
    
    period_seconds = rotation_periods.get(planet_name, 86400)
    current_time = time.time()
    rotation_fraction = (current_time % period_seconds) / period_seconds
    angle = rotation_fraction * 360
    
    static_position = get_planet_position(planet_name)
    dynamic_position = f"{static_position} (rotated {angle:.1f}°)"
    
    if grade <= 8:
        facts = planet["simple_facts"][:2]
    else:
        facts = list(planet["scientific_data"].items())[:2]
    
    live_box_text = f"🪐 {planet['name']} Live Update: Rotated {angle:.1f}° | Position: {static_position} | Time: {current_time:.0f}"

    return {
        "planet": planet["name"],
        "static_position": static_position,
        "live_rotation_angle": round(angle, 1),
        "live_position": dynamic_position,
        "live_facts": facts,
        "timestamp": current_time,
        "grade_level": f"Class {grade}",
        "live_box_text": live_box_text
    }


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
