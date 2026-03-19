import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SolarSystemApp());
}

class SolarSystemApp extends StatelessWidget {
  const SolarSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar System Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedGrade = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C0C1D), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    size: 120,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Solar System Explorer',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.amber, blurRadius: 20)],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Explore the wonders of our solar system!',
                    style: TextStyle(fontSize: 22, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Select Your Grade:',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildGradeButton('Class 6-8', 6),
                            const SizedBox(width: 20),
                            _buildGradeButton('Class 9-12', 9),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 280,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SolarSystemScreen(grade: _selectedGrade),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, size: 28),
                      label: const Text(
                        'Start Exploring',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradeButton(String label, int grade) {
    final isSelected = _selectedGrade == grade;
    return GestureDetector(
      onTap: () => setState(() => _selectedGrade = grade),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.transparent,
          border: Border.all(color: Colors.amber, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class Planet {
  final String name;
  final String apiName;
  final Color color;
  final double orbitRadius;
  final double size;
  final double speed;

  const Planet({
    required this.name,
    required this.apiName,
    required this.color,
    required this.orbitRadius,
    required this.size,
    required this.speed,
  });
}

class SolarSystemScreen extends StatefulWidget {
  final int grade;
  final http.Client? httpClient;

  const SolarSystemScreen({super.key, required this.grade, this.httpClient});

  @override
  State<SolarSystemScreen> createState() => _SolarSystemScreenState();
}

class _SolarSystemScreenState extends State<SolarSystemScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _orbitController;
  late AnimationController _starController;
  double _rotationAngle = 0;
  bool _showCompareMode = false;
  bool _isPaused = false;
  double _userRotationAngle = 0;
  final List<Star> _stars = [];
  final math.Random _random = math.Random();
  Map<String, dynamic>? _planetInfo;
  late final http.Client _client;

  String _selectedPlanetName = '';
  Color _selectedPlanetColor = Colors.orange;
  bool _isSunSelected = false;

  static const List<Planet> _planets = [
    Planet(
      name: 'Mercury',
      apiName: 'mercury',
      color: Color(0xFFB5B5B5),
      orbitRadius: 65,
      size: 12,
      speed: 4.0,
    ),
    Planet(
      name: 'Venus',
      apiName: 'venus',
      color: Color(0xFFE6B800),
      orbitRadius: 90,
      size: 16,
      speed: 3.0,
    ),
    Planet(
      name: 'Earth',
      apiName: 'earth',
      color: Color(0xFF4169E1),
      orbitRadius: 120,
      size: 18,
      speed: 2.5,
    ),
    Planet(
      name: 'Mars',
      apiName: 'mars',
      color: Color(0xFFCD5C5C),
      orbitRadius: 150,
      size: 14,
      speed: 2.0,
    ),
    Planet(
      name: 'Jupiter',
      apiName: 'jupiter',
      color: Color(0xFFD2691E),
      orbitRadius: 200,
      size: 40,
      speed: 1.0,
    ),
    Planet(
      name: 'Saturn',
      apiName: 'saturn',
      color: Color(0xFFF4A460),
      orbitRadius: 250,
      size: 35,
      speed: 0.7,
    ),
    Planet(
      name: 'Uranus',
      apiName: 'uranus',
      color: Color(0xFF87CEEB),
      orbitRadius: 295,
      size: 25,
      speed: 0.5,
    ),
    Planet(
      name: 'Neptune',
      apiName: 'neptune',
      color: Color(0xFF4169E1),
      orbitRadius: 335,
      size: 24,
      speed: 0.3,
    ),
  ];

  static const String _backendUrl = 'http://localhost:5001';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _client = widget.httpClient ?? http.Client();
    final speedFactor = widget.grade <= 8 ? 2.0 : 1.0;
    _orbitController = AnimationController(
      duration: Duration(seconds: (30 * speedFactor).toInt()),
      vsync: this,
    )..repeat();

    _starController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 150; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 0.5,
          brightness: _random.nextDouble(),
        ),
      );
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _orbitController.stop();
        _starController.stop();
      } else {
        _orbitController.repeat();
        _starController.repeat();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _orbitController.dispose();
    _starController.dispose();
    if (widget.httpClient == null) {
      _client.close();
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  Future<void> _fetchPlanetData(String planetName) async {
    String selectedName = planetName;
    Color selectedColor = Colors.orange;
    bool isSunCase = (planetName == 'sun');

    if (!isSunCase) {
      final planet = _planets.firstWhere(
        (p) => p.apiName == planetName,
        orElse: () => _planets.first,
      );
      selectedName = planet.name;
      selectedColor = planet.color;
    }

    try {
      final response = await _client
          .get(
            Uri.parse('$_backendUrl/planet/$planetName?grade=${widget.grade}'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _selectedPlanetName = selectedName;
            _selectedPlanetColor = selectedColor;
            _isSunSelected = isSunCase;
            _planetInfo = data;
          });
        }
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedPlanetName = selectedName;
          _selectedPlanetColor = selectedColor;
          _isSunSelected = isSunCase;
          _planetInfo = _getFallbackData(planetName);
        });
      }
    }
  }

  Map<String, dynamic> _getFallbackData(String apiName) {
    final data = {
      'sun': {
        'name': 'Sun',
        'position': 'Center of the Solar System',
        'facts': [
          'The Sun is a STAR at the center!',
          'It is about 4.6 BILLION years old!',
          '1.3 MILLION Earths could fit inside!',
          'It gives us LIGHT and WARMTH every day!',
        ],
        'mass': '1.989 × 10^30 kg',
        'gravity': '274 m/s²',
        'diameter': '1,392,700 km',
        'orbital_period': '25 Earth days (equator)',
        'rotation_period': '25 Earth days',
        'distance_from_sun': '0 km (center)',
      },
      'mercury': {
        'name': 'Mercury',
        'position': '1st planet from the Sun',
        'facts': [
          'Mercury is the SMALLEST planet!',
          'It is CLOSEST to the Sun!',
          'A day on Mercury is LONGER than its year!',
          'You could fit 18 Mercurys inside Earth!',
        ],
        'mass': '3.285 × 10^23 kg',
        'gravity': '3.7 m/s²',
        'diameter': '4,879 km',
        'orbital_period': '88 Earth days',
        'rotation_period': '59 Earth days',
        'distance_from_sun': '57.9 million km',
      },
      'venus': {
        'name': 'Venus',
        'position': '2nd planet from the Sun',
        'facts': [
          'Venus is the HOTTEST planet!',
          'It spins BACKWARDS compared to Earth!',
          'Venus is called Earth\'s TWIN!',
          'A day on Venus is LONGER than its year!',
        ],
        'mass': '4.867 × 10^24 kg',
        'gravity': '8.87 m/s²',
        'diameter': '12,104 km',
        'orbital_period': '225 Earth days',
        'rotation_period': '243 Earth days',
        'distance_from_sun': '108.2 million km',
      },
      'earth': {
        'name': 'Earth',
        'position': '3rd planet from the Sun',
        'facts': [
          'Earth is OUR HOME planet!',
          'It is the ONLY planet with LIFE!',
          '71% of Earth is covered with WATER!',
          'Earth has one MOON!',
        ],
        'mass': '5.972 × 10^24 kg',
        'gravity': '9.8 m/s²',
        'diameter': '12,742 km',
        'orbital_period': '365.25 days',
        'rotation_period': '24 hours',
        'distance_from_sun': '149.6 million km',
      },
      'mars': {
        'name': 'Mars',
        'position': '4th planet from the Sun',
        'facts': [
          'Mars is called the RED Planet!',
          'It has the BIGGEST volcano in the Solar System!',
          'There might have been WATER on Mars!',
          'Mars has 2 small moons!',
        ],
        'mass': '6.39 × 10^23 kg',
        'gravity': '3.71 m/s²',
        'diameter': '6,779 km',
        'orbital_period': '687 Earth days',
        'rotation_period': '24.6 hours',
        'distance_from_sun': '227.9 million km',
      },
      'jupiter': {
        'name': 'Jupiter',
        'position': '5th planet from the Sun',
        'facts': [
          'Jupiter is the BIGGEST planet!',
          'It has at least 95 MOONS!',
          'Jupiter is a GAS GIANT!',
          'The Great Red Spot is a giant STORM!',
        ],
        'mass': '1.898 × 10^27 kg',
        'gravity': '24.79 m/s²',
        'diameter': '139,820 km',
        'orbital_period': '11.86 Earth years',
        'rotation_period': '9.9 hours',
        'distance_from_sun': '778.5 million km',
      },
      'saturn': {
        'name': 'Saturn',
        'position': '6th planet from the Sun',
        'facts': [
          'Saturn has BEAUTIFUL rings!',
          'Saturn could FLOAT in water!',
          'It has at least 146 MOONS!',
          'Saturn\'s rings are made of ICE and rock!',
        ],
        'mass': '5.683 × 10^26 kg',
        'gravity': '10.44 m/s²',
        'diameter': '116,460 km',
        'orbital_period': '29.46 Earth years',
        'rotation_period': '10.7 hours',
        'distance_from_sun': '1.4 billion km',
      },
      'uranus': {
        'name': 'Uranus',
        'position': '7th planet from the Sun',
        'facts': [
          'Uranus SPINS on its SIDE!',
          'It was the FIRST planet discovered with a telescope!',
          'Uranus has 27 MOONS!',
          'It is called an ICE GIANT!',
        ],
        'mass': '8.681 × 10^25 kg',
        'gravity': '8.87 m/s²',
        'diameter': '50,724 km',
        'orbital_period': '84 Earth years',
        'rotation_period': '17.2 hours',
        'distance_from_sun': '2.9 billion km',
      },
      'neptune': {
        'name': 'Neptune',
        'position': '8th planet from the Sun',
        'facts': [
          'Neptune is the FARTHEST planet!',
          'It has the STRONGEST winds in the Solar System!',
          'It takes 165 YEARS to orbit the Sun!',
          'It was discovered using MATH!',
        ],
        'mass': '1.024 × 10^26 kg',
        'gravity': '11.15 m/s²',
        'diameter': '49,244 km',
        'orbital_period': '164.8 Earth years',
        'rotation_period': '16.1 hours',
        'distance_from_sun': '4.5 billion km',
      },
    };

    return data[apiName] ?? data['earth']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C0C1D), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _starController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: StarFieldPainter(_stars, _starController.value),
                    size: Size.infinite,
                  );
                },
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Grade: ${widget.grade <= 8 ? 'Class 6-8' : 'Class 9-12'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => setState(
                            () => _showCompareMode = !_showCompareMode,
                          ),
                          icon: Icon(
                            _showCompareMode
                                ? Icons.rotate_left
                                : Icons.compare_arrows,
                          ),
                          label: Text(_showCompareMode ? 'Orbit' : 'Compare'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.withOpacity(0.8),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _togglePause,
                          icon: Icon(
                            _isPaused ? Icons.play_arrow : Icons.pause,
                          ),
                          label: Text(_isPaused ? 'Play' : 'Pause'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isPaused
                                ? Colors.green
                                : Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _showCompareMode
                        ? _buildCompareView()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final orientation = MediaQuery.of(
                                context,
                              ).orientation;
                              if (orientation == Orientation.portrait) {
                                return Column(
                                  children: [
                                    Expanded(flex: 6, child: _buildOrbitView()),
                                    Expanded(flex: 4, child: _buildInfoBox()),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(flex: 2, child: _buildOrbitView()),
                                  Expanded(child: _buildInfoBox()),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: AnimatedBuilder(
        animation: _orbitController,
        builder: (context, child) {
          final userRotDeg = (_userRotationAngle * 180 / math.pi)
              .toStringAsFixed(1);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📋 INFO BOX',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _isPaused ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isPaused ? '⏸️ PAUSED' : '▶️ ORBITING',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Rotation: ${userRotDeg}°',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Divider(color: Colors.amber, height: 20),
                if (_planetInfo != null) ...[
                  _buildPlanetInfo(),
                ] else ...[
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.touch_app, color: Colors.orange, size: 48),
                        SizedBox(height: 10),
                        Text(
                          'TAP A PLANET!',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Touch any planet to learn about it',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Planets:',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildPlanetButton(
                        'sun',
                        'Sun',
                        Colors.orange,
                        Icons.wb_sunny,
                      ),
                      ..._planets.map(
                        (p) => _buildPlanetButton(
                          p.apiName,
                          p.name,
                          p.color,
                          null,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanetButton(
    String apiName,
    String name,
    Color color,
    IconData? icon,
  ) {
    return GestureDetector(
      onTap: () => _fetchPlanetData(apiName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: color, size: 16)
            else
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
            const SizedBox(width: 6),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanetInfo() {
    final info = _planetInfo!;
    final isSun = _isSunSelected;
    final planetColor = _selectedPlanetColor;
    final planetName = _selectedPlanetName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: planetColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: planetColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSun
                      ? const RadialGradient(
                          colors: [Colors.yellow, Colors.orange],
                        )
                      : RadialGradient(
                          colors: [planetColor.withOpacity(0.8), planetColor],
                        ),
                  boxShadow: [BoxShadow(color: planetColor, blurRadius: 10)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info['name'] ?? planetName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      info['position'] ??
                          (isSun ? 'Center of Solar System' : ''),
                      style: const TextStyle(color: Colors.amber, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (widget.grade <= 8 && info['facts'] != null) ...[
          const Text(
            '✨ Fun Facts:',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...(info['facts'] as List).map<Widget>(
            (fact) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🪐 ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      '$fact',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (widget.grade > 8) ...[
          const Text(
            '📊 Scientific Data:',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (info['mass'] != null) _buildInfoRow('Mass', info['mass']),
          if (info['gravity'] != null)
            _buildInfoRow('Gravity', info['gravity']),
          if (info['diameter'] != null)
            _buildInfoRow('Diameter', info['diameter']),
          if (info['orbital_period'] != null)
            _buildInfoRow('Orbit Time', info['orbital_period']),
          if (info['rotation_period'] != null)
            _buildInfoRow('Day Length', info['rotation_period']),
          if (info['distance_from_sun'] != null)
            _buildInfoRow('Distance', info['distance_from_sun']),
        ],
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() {
              _selectedPlanetName = '';
              _selectedPlanetColor = Colors.orange;
              _isSunSelected = false;
              _planetInfo = null;
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.8),
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear Selection'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final paintSize = math.min(
          math.min(constraints.maxWidth * 0.95, constraints.maxHeight * 0.95),
          760.0,
        );
        final scale = paintSize / 760.0;
        final center = paintSize / 2;

        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _rotationAngle += details.delta.dx / paintSize * 5;
              _userRotationAngle += details.delta.dx / paintSize * 5;
            });
          },
          child: AnimatedBuilder(
            animation: _orbitController,
            builder: (context, child) {
              return Center(
                child: Transform.rotate(
                  angle: _rotationAngle,
                  child: SizedBox(
                    width: paintSize,
                    height: paintSize,
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: OrbitPainter(
                            _planets,
                            _orbitController.value,
                            paintSize,
                            scale,
                          ),
                          size: Size(paintSize, paintSize),
                        ),
                        Positioned(
                          left: center - 50,
                          top: center - 50,
                          child: GestureDetector(
                            onTap: () => _fetchPlanetData('sun'),
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange.withOpacity(0.2),
                              ),
                              child: const SunWidget(),
                            ),
                          ),
                        ),
                        ..._planets.map((planet) {
                          final angle =
                              _orbitController.value *
                              2 *
                              math.pi *
                              planet.speed;
                          final scaledRadius = planet.orbitRadius * scale;
                          final x = scaledRadius * math.cos(angle);
                          final y = scaledRadius * math.sin(angle);
                          return Positioned(
                            left: center + x - 35,
                            top: center + y - 35,
                            child: GestureDetector(
                              onTap: () => _fetchPlanetData(planet.apiName),
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                child: Container(
                                  width: planet.size * scale * 2.5,
                                  height: planet.size * scale * 2.5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      center: const Alignment(-0.3, -0.3),
                                      radius: 0.8,
                                      colors: [
                                        planet.color.withOpacity(0.9),
                                        planet.color,
                                        planet.color.withOpacity(0.7),
                                        planet.color.withOpacity(0.4),
                                      ],
                                      stops: const [0.0, 0.4, 0.7, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: planet.color.withOpacity(0.8),
                                        blurRadius: 25,
                                        spreadRadius: 8,
                                      ),
                                      BoxShadow(
                                        color: planet.color.withOpacity(0.4),
                                        blurRadius: 50,
                                        spreadRadius: 15,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ui.ImageFilter.blur(
                                        sigmaX: 1.5,
                                        sigmaY: 1.5,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            center: const Alignment(-0.3, -0.3),
                                            radius: 0.7,
                                            colors: [
                                              Colors.white.withOpacity(0.3),
                                              planet.color.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompareView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '🪐 Planet Size Comparison',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ..._planets.map(
            (planet) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: planet.size * 2,
                    height: planet.size * 2,
                    decoration: BoxDecoration(
                      color: planet.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: planet.color, blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planet.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Orbit: ${planet.orbitRadius.toInt()} units',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _fetchPlanetData(planet.apiName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double brightness;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.brightness,
  });
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final double animation;

  StarFieldPainter(this.stars, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle =
          0.5 +
          0.5 * math.sin((animation * 2 * math.pi) + star.brightness * 10);
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.brightness * twinkle)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * twinkle,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) => true;
}

class OrbitPainter extends CustomPainter {
  final List<Planet> planets;
  final double animation;
  final double paintSize;
  final double scale;

  OrbitPainter(this.planets, this.animation, this.paintSize, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(paintSize / 2, paintSize / 2);
    for (final planet in planets) {
      final scaledRadius = planet.orbitRadius * scale;
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(center, scaledRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) => true;
}

class SunWidget extends StatelessWidget {
  const SunWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Colors.yellow, Colors.orange, Colors.red],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.9),
            blurRadius: 40,
            spreadRadius: 15,
          ),
          BoxShadow(
            color: Colors.orange.withOpacity(0.6),
            blurRadius: 60,
            spreadRadius: 25,
          ),
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 80,
            spreadRadius: 35,
          ),
        ],
      ),
    );
  }
}
