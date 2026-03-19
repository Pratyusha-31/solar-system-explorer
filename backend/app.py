from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

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

@app.route('/')
def index():
    return jsonify({
        "message": "Welcome to Solar System Explorer API",
        "endpoints": {
            "planet_info": "/planet/<planet_name>?grade=<grade>",
            "live_rotation": "/live/<planet_name>?grade=<grade>"
        }
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
    
    # Planet rotation periods in seconds (one full rotation)
    rotation_periods = {
        "sun": 25 * 86400,  # 25 Earth days
        "mercury": 59 * 86400,
        "venus": 243 * 86400,
        "earth": 86400,  # 24 hours
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
        facts = planet["simple_facts"][:2]  # Live: 2 facts
    else:
        facts = list(planet["scientific_data"].items())[:2]  # Live: 2 key-value pairs
    
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