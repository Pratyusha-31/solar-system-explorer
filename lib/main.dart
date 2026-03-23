import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SolarSystemApp());
}

class SolarSystemApp extends StatelessWidget {
  const SolarSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    return MaterialApp(
      title: 'Solar System Explorer',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF050816),
        textTheme: baseTheme.textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4DE2C5),
          secondary: Color(0xFFFFB84D),
          surface: Color(0xFF11182D),
        ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF02040C), Color(0xFF081126), Color(0xFF111C3B)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _NebulaBackground()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked = constraints.maxWidth < 900;
                        return Flex(
                          direction: stacked ? Axis.vertical : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: stacked ? 0 : 11,
                              child: _buildEntranceCopy(stacked, isSmallScreen),
                            ),
                            SizedBox(
                              width: stacked ? 0 : 28,
                              height: stacked ? 28 : 0,
                            ),
                            Expanded(
                              flex: stacked ? 0 : 9,
                              child: _buildEntrancePanel(isSmallScreen),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntranceCopy(bool stacked, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(right: stacked ? 0 : 20),
      child: Column(
        crossAxisAlignment: stacked
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: const Text(
              'SPACE ACADEMY // LIVE SIMULATION',
              style: TextStyle(
                color: Color(0xFF9EE7D8),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 28),
          Text(
            'Mission-ready solar system exploration for the classroom.',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: isSmallScreen ? 32 : 54,
              height: 1.02,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 18),
          Text(
            'Launch a premium mission control dashboard with orbit tracking, planet briefings, and touch-first discovery built for Class 6-8 learners.',
            style: TextStyle(
              fontSize: isSmallScreen ? 15 : 18,
              height: 1.6,
              color: const Color(0xFFB7C2DE),
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _EntryBadge(
                icon: Icons.radar_rounded,
                label: 'Live Orbit View',
                color: Color(0xFF4DE2C5),
              ),
              _EntryBadge(
                icon: Icons.auto_awesome,
                label: 'Mission Briefings',
                color: Color(0xFFFFB84D),
              ),
              _EntryBadge(
                icon: Icons.view_in_ar_rounded,
                label: '3D Space Feel',
                color: Color(0xFF8E8CFF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntrancePanel(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4DE2C5).withValues(alpha: 0.08),
            blurRadius: 60,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isSmallScreen ? 160 : 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const RadialGradient(
                center: Alignment(-0.1, -0.2),
                radius: 1.1,
                colors: [
                  Color(0xFF193464),
                  Color(0xFF0A1022),
                  Color(0xFF060913),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Center(child: _EntranceSolarArtwork()),
          ),
          SizedBox(height: isSmallScreen ? 18 : 26),
          const Text(
            'Select Explorer Mode',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          const Text(
            'Mission Control is tuned for middle-school learners. Choose a level and enter the dashboard.',
            style: TextStyle(color: Color(0xFFB7C2DE), height: 1.5),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          Row(
            children: [
              Expanded(child: _buildGradeButton('Class 6-8', 6)),
              const SizedBox(width: 12),
              Expanded(child: _buildGradeButton('Class 9-12', 9)),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SolarSystemScreen(grade: _selectedGrade),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4DE2C5),
                foregroundColor: const Color(0xFF04111A),
                elevation: 18,
                shadowColor: const Color(0xFF4DE2C5).withValues(alpha: 0.45),
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 16 : 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Enter Mission Control',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeButton(String label, int grade) {
    final selected = _selectedGrade == grade;
    final borderColor = selected
        ? const Color(0xFF4DE2C5)
        : Colors.white.withValues(alpha: 0.16);

    return InkWell(
      onTap: () => setState(() => _selectedGrade = grade),
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: selected
              ? const Color(0xFF4DE2C5).withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.04),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4DE2C5).withValues(alpha: 0.18),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : const Color(0xFFE7ECFF),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              grade == 6 ? 'Recommended' : 'Advanced detail',
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA8C7)),
            ),
          ],
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

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as String,
    );
  }
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
  static const String _backendUrl = 'http://localhost:5000';

  static const List<Planet> _planets = [
    Planet(
      name: 'Mercury',
      apiName: 'mercury',
      color: Color(0xFFB5B5B5),
      orbitRadius: 55,
      size: 18,
      speed: 4.0,
    ),
    Planet(
      name: 'Venus',
      apiName: 'venus',
      color: Color(0xFFE6B800),
      orbitRadius: 85,
      size: 26,
      speed: 3.0,
    ),
    Planet(
      name: 'Earth',
      apiName: 'earth',
      color: Color(0xFF4169E1),
      orbitRadius: 115,
      size: 28,
      speed: 2.5,
    ),
    Planet(
      name: 'Mars',
      apiName: 'mars',
      color: Color(0xFFCD5C5C),
      orbitRadius: 145,
      size: 22,
      speed: 2.0,
    ),
    Planet(
      name: 'Jupiter',
      apiName: 'jupiter',
      color: Color(0xFFD2691E),
      orbitRadius: 195,
      size: 60,
      speed: 1.0,
    ),
    Planet(
      name: 'Saturn',
      apiName: 'saturn',
      color: Color(0xFFF4A460),
      orbitRadius: 245,
      size: 52,
      speed: 0.7,
    ),
    Planet(
      name: 'Uranus',
      apiName: 'uranus',
      color: Color(0xFF87CEEB),
      orbitRadius: 285,
      size: 38,
      speed: 0.5,
    ),
    Planet(
      name: 'Neptune',
      apiName: 'neptune',
      color: Color(0xFF4169E1),
      orbitRadius: 320,
      size: 36,
      speed: 0.3,
    ),
  ];

  late final AnimationController _orbitController;
  late final AnimationController _starController;
  late final http.Client _client;

  final List<Star> _stars = [];
  final math.Random _random = math.Random();

  double _rotationAngle = 0;
  double _userRotationAngle = 0;
  bool _isPaused = false;
  Map<String, dynamic>? _planetInfo;
  String _selectedPlanetName = '';
  Color _selectedPlanetColor = Colors.orange;
  bool _isSunSelected = false;

  bool _showQuiz = false;
  List<QuizQuestion> _quizQuestions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _answerSubmitted = false;
  bool _quizLoading = false;
  String? _quizError;

  static List<QuizQuestion>? _cachedQuizQuestions;
  static int? _cachedGrade;
  static DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 30);

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

    for (var i = 0; i < 160; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2.2 + 0.4,
          brightness: _random.nextDouble(),
        ),
      );
    }
  }

  void _togglePause() {
    _setPaused(!_isPaused);
  }

  void _setPaused(bool paused) {
    if (_isPaused == paused) return;
    setState(() {
      _isPaused = paused;
      if (_isPaused) {
        _orbitController.stop();
        _starController.stop();
      } else {
        _orbitController.repeat();
        _starController.repeat();
      }
    });
  }

  Future<void> _fetchPlanetData(String planetName) async {
    String selectedName = planetName;
    Color selectedColor = Colors.orange;
    final isSunCase = planetName == 'sun';

    if (!isSunCase) {
      final planet = _planets.firstWhere(
        (item) => item.apiName == planetName,
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

      if (response.statusCode != 200) {
        throw Exception('Failed to load planet data');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _selectedPlanetName = selectedName;
        _selectedPlanetColor = selectedColor;
        _isSunSelected = isSunCase;
        _planetInfo = data;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _selectedPlanetName = selectedName;
        _selectedPlanetColor = selectedColor;
        _isSunSelected = isSunCase;
        _planetInfo = _getFallbackData(planetName);
      });
    }
  }

  Future<void> _fetchQuiz() async {
    setState(() {
      _quizLoading = true;
      _quizError = null;
      _quizQuestions = [];
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _answerSubmitted = false;
    });

    if (_cachedQuizQuestions != null &&
        _cachedGrade == widget.grade &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      setState(() {
        _quizQuestions = List.from(_cachedQuizQuestions!);
        _quizQuestions.shuffle();
        _quizLoading = false;
      });
      debugPrint('Using cached quiz questions');
      return;
    }

    try {
      final response = await _client
          .get(Uri.parse('$_backendUrl/quiz?grade=${widget.grade}'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final quizList = data['quiz'] as List;
        final questions = quizList
            .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
            .toList();

        _cachedQuizQuestions = questions;
        _cachedGrade = widget.grade;
        _cacheTime = DateTime.now();

        setState(() {
          _quizQuestions = questions;
          _quizLoading = false;
        });
        debugPrint('Quiz loaded and cached from API');
      } else {
        throw Exception('Failed to load quiz');
      }
    } catch (e) {
      if (_cachedQuizQuestions != null && _cachedGrade == widget.grade) {
        setState(() {
          _quizQuestions = List.from(_cachedQuizQuestions!);
          _quizQuestions.shuffle();
          _quizLoading = false;
        });
        debugPrint('Using cached quiz on error');
      } else {
        setState(() {
          _quizLoading = false;
          _quizError = 'Could not load quiz. Please try again.';
        });
      }
    }
  }

  void _toggleQuiz() {
    setState(() {
      _showQuiz = !_showQuiz;
      if (_showQuiz && _quizQuestions.isEmpty && !_quizLoading) {
        _fetchQuiz();
      }
    });
  }

  void _selectAnswer(String answer) {
    if (_answerSubmitted) return;
    setState(() {
      _selectedAnswer = answer;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;
    setState(() {
      _answerSubmitted = true;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answerSubmitted = false;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _answerSubmitted = false;
    });
    if (_cachedQuizQuestions != null) {
      setState(() {
        _quizQuestions = List.from(_cachedQuizQuestions!);
        _quizQuestions.shuffle();
      });
    } else {
      _fetchQuiz();
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedPlanetName = '';
      _selectedPlanetColor = Colors.orange;
      _isSunSelected = false;
      _planetInfo = null;
    });
  }

  Future<void> _openWikipedia(String title) async {
    final safeTitle = title.replaceAll(' ', '_');
    final uri = Uri.parse('https://en.wikipedia.org/wiki/$safeTitle');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _showSizeLab() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 760),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10172B), Color(0xFF0B1020)],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8E8CFF).withValues(alpha: 0.18),
                  blurRadius: 50,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF8E8CFF,
                          ).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.stacked_bar_chart_rounded,
                          color: Color(0xFFB8B6FF),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Size Lab',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Relative planet size comparison',
                              style: TextStyle(color: Color(0xFF9DA9C8)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ..._planets.map(
                    (planet) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: math.max(planet.size * 1.2, 20),
                              height: math.max(planet.size * 1.2, 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: planet.color,
                                boxShadow: [
                                  BoxShadow(
                                    color: planet.color.withValues(alpha: 0.55),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    planet.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Orbit radius ${planet.orbitRadius.toInt()} units',
                                    style: const TextStyle(
                                      color: Color(0xFF98A4C4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _fetchPlanetData(planet.apiName);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: planet.color.withValues(alpha: 0.7),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('Inspect'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF03050D), Color(0xFF08101F), Color(0xFF111C36)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _NebulaBackground()),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _starController,
                builder: (context, child) => CustomPaint(
                  painter: StarFieldPainter(_stars, _starController.value),
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 1100;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      isSmallScreen ? 12 : 18,
                      isSmallScreen ? 8 : 16,
                      isSmallScreen ? 12 : 18,
                      isSmallScreen ? 12 : 18,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 860),
                            child: _buildMissionControlBar(isSmallScreen),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 18),
                        Expanded(
                          child: stacked
                              ? Column(
                                  children: [
                                    Expanded(
                                      flex: isSmallScreen ? 5 : 6,
                                      child: _buildOrbitStage(isSmallScreen),
                                    ),
                                    SizedBox(height: isSmallScreen ? 12 : 18),
                                    Expanded(
                                      flex: isSmallScreen ? 6 : 5,
                                      child: _showQuiz
                                          ? _buildQuizPanel(isSmallScreen)
                                          : _buildInfoPanel(isSmallScreen),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: _buildOrbitStage(isSmallScreen),
                                    ),
                                    SizedBox(width: isSmallScreen ? 12 : 20),
                                    Expanded(
                                      flex: 5,
                                      child: _showQuiz
                                          ? _buildQuizPanel(isSmallScreen)
                                          : _buildInfoPanel(isSmallScreen),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionControlBar(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16 : 24,
        isSmallScreen ? 14 : 18,
        isSmallScreen ? 16 : 24,
        isSmallScreen ? 16 : 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4DE2C5).withValues(alpha: 0.1),
            blurRadius: 36,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Mission Control',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 22 : 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Explorer Mode for Class ${widget.grade}-${widget.grade + 2}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF9DACCC),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isSmallScreen ? 10 : 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: const [
              _HintPill(label: 'Drag to rotate', icon: Icons.touch_app_rounded),
              _HintPill(label: 'Tap a planet', icon: Icons.ads_click_rounded),
              _HintPill(label: '3D Space View', icon: Icons.view_in_ar_rounded),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _ActionPillButton(
                label: 'Size Lab',
                icon: Icons.stacked_bar_chart_rounded,
                colorA: const Color(0xFF8E8CFF),
                colorB: const Color(0xFF5B5AE0),
                onPressed: _showSizeLab,
              ),
              _ActionPillButton(
                label: _isPaused ? 'Resume Orbit' : 'Pause Orbit',
                icon: _isPaused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                colorA: const Color(0xFFFFB84D),
                colorB: const Color(0xFFFF7A59),
                onPressed: _togglePause,
              ),
              _ActionPillButton(
                label: _showQuiz ? 'Close Quiz' : 'Take Quiz',
                icon: Icons.quiz_rounded,
                colorA: const Color(0xFFFF6B8A),
                colorB: const Color(0xFFFF4488),
                onPressed: _toggleQuiz,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitStage(bool isSmallScreen) {
    final stagePadding = isSmallScreen ? 8.0 : 18.0;

    return Container(
      padding: EdgeInsets.all(stagePadding),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A7BFF).withValues(alpha: 0.08),
            blurRadius: 42,
            spreadRadius: 4,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxOrbitRadius = 320.0;
          final sunSizeBase = 50.0;
          final orbitPadding = isSmallScreen ? 20.0 : 30.0;

          final availableWidth = constraints.maxWidth - orbitPadding;
          final availableHeight = constraints.maxHeight - orbitPadding;

          final totalWidth = maxOrbitRadius * 2 + sunSizeBase;
          final totalHeight = maxOrbitRadius * 2 + sunSizeBase;

          final scaleX = availableWidth / totalWidth;
          final scaleY = availableHeight / totalHeight;
          final scale = math.min(scaleX, scaleY);

          final paintWidth = totalWidth * scale;
          final paintHeight = totalHeight * scale;
          final centerX = paintWidth / 2;
          final centerY = paintHeight / 2;
          final sunSize = sunSizeBase * scale;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    '${(_userRotationAngle * 180 / math.pi).toStringAsFixed(0)}°',
                    style: const TextStyle(
                      color: Color(0xFFD2DBF2),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final delta = details.delta.dx / paintWidth * 5;
                      _rotationAngle += delta;
                      _userRotationAngle += delta;
                    });
                  },
                  child: AnimatedBuilder(
                    animation: _orbitController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAngle,
                        child: SizedBox(
                          width: paintWidth,
                          height: paintHeight,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CustomPaint(
                                size: Size(paintWidth, paintHeight),
                                painter: OrbitPainter(
                                  _planets,
                                  _orbitController.value,
                                  scale,
                                ),
                              ),
                              Positioned(
                                left: centerX - sunSize / 2,
                                top: centerY - sunSize / 2,
                                child: GestureDetector(
                                  onTap: () => _fetchPlanetData('sun'),
                                  child: SunWidget(size: sunSize),
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
                                final planetSize = planet.size * scale;

                                return Positioned(
                                  left: centerX + x - planetSize / 2,
                                  top: centerY + y - planetSize / 2,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _fetchPlanetData(planet.apiName),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      width: planetSize,
                                      height: planetSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          center: const Alignment(-0.3, -0.35),
                                          radius: 0.92,
                                          colors: [
                                            Colors.white.withValues(
                                              alpha: 0.28,
                                            ),
                                            planet.color.withValues(
                                              alpha: 0.94,
                                            ),
                                            planet.color.withValues(
                                              alpha: 0.75,
                                            ),
                                            planet.color.withValues(
                                              alpha: 0.45,
                                            ),
                                          ],
                                          stops: const [0.0, 0.18, 0.7, 1.0],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: planet.color.withValues(
                                              alpha: 0.85,
                                            ),
                                            blurRadius: planetSize * 0.8,
                                            spreadRadius: planetSize * 0.2,
                                          ),
                                          BoxShadow(
                                            color: planet.color.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: planetSize * 1.5,
                                            spreadRadius: planetSize * 0.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoPanel(bool isSmallScreen) {
    final hasSelection = _planetInfo != null;
    final accent = hasSelection
        ? _selectedPlanetColor
        : const Color(0xFF4DE2C5);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.09),
        border: Border.all(color: accent.withValues(alpha: 0.55), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.16),
            blurRadius: 36,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoHeader(hasSelection, accent, isSmallScreen),
                SizedBox(height: isSmallScreen ? 14 : 20),
                if (hasSelection) ...[
                  _buildPlanetInfo(isSmallScreen),
                ] else ...[
                  _buildEmptyState(isSmallScreen),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoHeader(bool hasSelection, Color accent, bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            hasSelection
                ? (_isSunSelected
                      ? Icons.wb_sunny_rounded
                      : Icons.public_rounded)
                : Icons.hub_rounded,
            color: accent,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasSelection ? 'Mission Briefing' : 'Info Panel',
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                hasSelection
                    ? 'Planet intelligence and quick actions'
                    : 'Select a target to inspect planet data',
                style: const TextStyle(color: Color(0xFF9DA9C8), fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isPaused
                ? const Color(0xFFFF7A59).withValues(alpha: 0.18)
                : const Color(0xFF4DE2C5).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _isPaused
                  ? const Color(0xFFFF7A59)
                  : const Color(0xFF4DE2C5),
            ),
          ),
          child: Text(
            _isPaused ? 'Paused' : 'Live',
            style: TextStyle(
              color: _isPaused
                  ? const Color(0xFFFFB199)
                  : const Color(0xFF99FFF0),
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.black.withValues(alpha: 0.18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Awaiting planet selection',
                style: TextStyle(
                  fontSize: isSmallScreen ? 17 : 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap any planet in the solar system to load a modern mission briefing with quick stats and exploration links.',
                style: TextStyle(color: Color(0xFFB0BCDA), height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPlanetChip(
              'sun',
              'Sun',
              Colors.orange,
              Icons.wb_sunny_rounded,
            ),
            ..._planets.map(
              (planet) => _buildPlanetChip(
                planet.apiName,
                planet.name,
                planet.color,
                Icons.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanetChip(
    String apiName,
    String label,
    Color color,
    IconData icon,
  ) {
    return InkWell(
      onTap: () => _fetchPlanetData(apiName),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: color.withValues(alpha: 0.14),
          border: Border.all(color: color.withValues(alpha: 0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanetInfo(bool isSmallScreen) {
    final info = _planetInfo!;
    final isSun = _isSunSelected;
    final accent = _selectedPlanetColor;
    final facts = (info['facts'] as List?)?.cast<dynamic>() ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: 0.22),
                accent.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(color: accent.withValues(alpha: 0.45)),
          ),
          child: Row(
            children: [
              Container(
                width: isSmallScreen ? 44 : 58,
                height: isSmallScreen ? 44 : 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSun
                      ? const RadialGradient(
                          colors: [
                            Colors.yellow,
                            Colors.orange,
                            Colors.deepOrange,
                          ],
                        )
                      : RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.4),
                            accent.withValues(alpha: 0.92),
                            accent.withValues(alpha: 0.7),
                          ],
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.55),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info['name'] ?? _selectedPlanetName,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info['position'] ?? '',
                      style: TextStyle(
                        color: accent.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w600,
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isSmallScreen ? 14 : 18),
        Text(
          'Planet Details',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: isSmallScreen ? 10 : 12),
        if (facts.isNotEmpty)
          ...facts
              .take(4)
              .map(
                (fact) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.flash_on_rounded, color: accent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$fact',
                            style: const TextStyle(
                              color: Color(0xFFE6ECFF),
                              height: 1.4,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (info['diameter'] != null)
              _StatTile(label: 'Diameter', value: info['diameter'] as String),
            if (info['gravity'] != null)
              _StatTile(label: 'Gravity', value: info['gravity'] as String),
            if (info['orbital_period'] != null)
              _StatTile(
                label: 'Orbit Time',
                value: info['orbital_period'] as String,
              ),
            if (info['distance_from_sun'] != null)
              _StatTile(
                label: 'Distance',
                value: info['distance_from_sun'] as String,
              ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 14 : 18),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  final wikiTitle = isSun
                      ? 'Sun'
                      : (info['name'] ?? _selectedPlanetName);
                  _openWikipedia(wikiTitle.toString());
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Explore More'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearSelection,
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text('Clear'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuizPanel(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.09),
        border: Border.all(
          color: const Color(0xFFFF6B8A).withValues(alpha: 0.55),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B8A).withValues(alpha: 0.16),
            blurRadius: 36,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: _quizLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFFFF6B8A)),
                      SizedBox(height: 16),
                      Text(
                        'Loading quiz...',
                        style: TextStyle(color: Color(0xFF9DA9C8)),
                      ),
                    ],
                  ),
                )
              : _quizError != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFFF6B8A),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _quizError!,
                        style: const TextStyle(color: Color(0xFF9DA9C8)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B8A),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _quizQuestions.isEmpty
              ? const Center(
                  child: Text(
                    'No quiz available',
                    style: TextStyle(color: Color(0xFF9DA9C8)),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuizHeader(isSmallScreen),
                      SizedBox(height: isSmallScreen ? 14 : 20),
                      _buildQuestionCard(isSmallScreen),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildQuizHeader(bool isSmallScreen) {
    final question = _quizQuestions[_currentQuestionIndex];
    final isCorrect =
        _answerSubmitted && _selectedAnswer == question.correctAnswer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B8A).withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.quiz_rounded,
            color: Color(0xFFFF6B8A),
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solar Quiz',
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_quizQuestions.length}',
                style: const TextStyle(color: Color(0xFF9DA9C8), fontSize: 13),
              ),
            ],
          ),
        ),
        if (_answerSubmitted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF4DE2C5).withValues(alpha: 0.18)
                  : const Color(0xFFFF7A59).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isCorrect
                    ? const Color(0xFF4DE2C5)
                    : const Color(0xFFFF7A59),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: isCorrect
                      ? const Color(0xFF99FFF0)
                      : const Color(0xFFFFB199),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  isCorrect ? 'Correct!' : 'Wrong',
                  style: TextStyle(
                    color: isCorrect
                        ? const Color(0xFF99FFF0)
                        : const Color(0xFFFFB199),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionCard(bool isSmallScreen) {
    final question = _quizQuestions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF6B8A).withValues(alpha: 0.22),
                const Color(0xFFFF6B8A).withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(
              color: const Color(0xFFFF6B8A).withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            question.question,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 14 : 18),
        ...question.options.map((option) {
          final isSelected = _selectedAnswer == option;
          final isCorrectOption = option == question.correctAnswer;
          final showResult = _answerSubmitted;

          Color borderColor = Colors.white.withValues(alpha: 0.15);
          Color bgColor = Colors.white.withValues(alpha: 0.05);

          if (showResult) {
            if (isCorrectOption) {
              borderColor = const Color(0xFF4DE2C5);
              bgColor = const Color(0xFF4DE2C5).withValues(alpha: 0.15);
            } else if (isSelected && !isCorrectOption) {
              borderColor = const Color(0xFFFF7A59);
              bgColor = const Color(0xFFFF7A59).withValues(alpha: 0.15);
            }
          } else if (isSelected) {
            borderColor = const Color(0xFFFF6B8A);
            bgColor = const Color(0xFFFF6B8A).withValues(alpha: 0.15);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: _answerSubmitted ? null : () => _selectAnswer(option),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: bgColor,
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? (showResult
                                  ? (isCorrectOption
                                        ? const Color(0xFF4DE2C5)
                                        : const Color(0xFFFF7A59))
                                  : const Color(0xFFFF6B8A))
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: showResult && isCorrectOption
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : showResult && isSelected && !isCorrectOption
                          ? const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        SizedBox(height: isSmallScreen ? 12 : 16),
        if (!_answerSubmitted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAnswer != null ? _submitAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B8A),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Submit Answer'),
            ),
          )
        else
          Column(
            children: [
              if (_answerSubmitted &&
                  _currentQuestionIndex < _quizQuestions.length - 1)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Next Question'),
                  ),
                )
              else if (_answerSubmitted &&
                  _currentQuestionIndex == _quizQuestions.length - 1)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _resetQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DE2C5),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Play Again'),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Map<String, dynamic> _getFallbackData(String apiName) {
    const data = {
      'sun': {
        'name': 'Sun',
        'position': 'Center of the Solar System',
        'facts': [
          'The Sun is a star at the center of our Solar System.',
          'It provides the heat and light that make life on Earth possible.',
          'About 1.3 million Earths could fit inside the Sun.',
          'Its gravity holds every planet in orbit.',
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
          'Mercury is the smallest planet in the Solar System.',
          'It is the closest planet to the Sun.',
          'A day on Mercury is longer than its year.',
          'Mercury has almost no atmosphere to trap heat.',
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
          'Venus is the hottest planet because of its thick atmosphere.',
          'It spins in the opposite direction to most planets.',
          "Venus is often called Earth's twin because of its size.",
          'Its clouds are made of sulfuric acid.',
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
          'Earth is the only known planet with life.',
          'Liquid water covers most of the planet.',
          'Earth has one natural moon.',
          'Its atmosphere protects life and keeps temperatures stable.',
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
          'Mars is called the Red Planet because of iron-rich dust.',
          'It has the tallest volcano in the Solar System.',
          'Evidence suggests Mars once had flowing water.',
          'Mars has two small moons named Phobos and Deimos.',
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
          'Jupiter is the largest planet in the Solar System.',
          'It is a gas giant made mostly of hydrogen and helium.',
          'The Great Red Spot is a giant storm larger than Earth.',
          'Jupiter has many moons, including Ganymede.',
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
          'Saturn is famous for its bright rings.',
          'Its rings are made of ice, dust, and rocky pieces.',
          'Saturn is so light it could float in water.',
          'It has a large moon called Titan.',
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
          'Uranus rotates on its side compared with most planets.',
          'It is an ice giant with a cold atmosphere.',
          'The planet looks blue-green because of methane gas.',
          'Uranus has faint rings and many moons.',
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
          'Neptune is the farthest major planet from the Sun.',
          'It has some of the strongest winds in the Solar System.',
          'Neptune is an ice giant with a deep blue color.',
          'It was discovered using mathematics before telescopes confirmed it.',
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
}

class _EntryBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _EntryBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _HintPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _HintPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF9EE7D8)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFD7E0F8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPillButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color colorA;
  final Color colorB;
  final VoidCallback onPressed;

  const _ActionPillButton({
    required this.label,
    required this.icon,
    required this.colorA,
    required this.colorB,
    required this.onPressed,
  });

  @override
  State<_ActionPillButton> createState() => _ActionPillButtonState();
}

class _ActionPillButtonState extends State<_ActionPillButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1,
        duration: const Duration(milliseconds: 160),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: widget.colorA.withValues(alpha: _hovered ? 0.32 : 0.18),
                blurRadius: _hovered ? 30 : 20,
                spreadRadius: _hovered ? 2 : 0,
              ),
            ],
            gradient: LinearGradient(colors: [widget.colorA, widget.colorB]),
          ),
          child: ElevatedButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon, size: 18),
            label: Text(widget.label, style: const TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 130),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF91A0C4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.35,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _NebulaBackground extends StatelessWidget {
  const _NebulaBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: -80,
            top: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4DE2C5).withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: -120,
            top: 80,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8E8CFF).withValues(alpha: 0.09),
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            left: 80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB84D).withValues(alpha: 0.07),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntranceSolarArtwork extends StatelessWidget {
  const _EntranceSolarArtwork();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SizedBox(
      width: isSmallScreen ? 200 : 300,
      height: isSmallScreen ? 120 : 180,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned.fill(child: _OrbitRings()),
          SunWidget(size: 84),
          Positioned(
            left: 54,
            top: 66,
            child: _MiniPlanet(color: Color(0xFFB5B5B5), size: 12),
          ),
          Positioned(
            left: 86,
            top: 118,
            child: _MiniPlanet(color: Color(0xFFE6B800), size: 16),
          ),
          Positioned(
            right: 64,
            top: 54,
            child: _MiniPlanet(color: Color(0xFF4169E1), size: 18),
          ),
          Positioned(
            right: 94,
            bottom: 20,
            child: _MiniPlanet(color: Color(0xFFCD5C5C), size: 14),
          ),
        ],
      ),
    );
  }
}

class _OrbitRings extends StatelessWidget {
  const _OrbitRings();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _OrbitRingPainter());
  }
}

class _OrbitRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.12);

    canvas.drawCircle(center, 40, paint);
    canvas.drawCircle(center, 70, paint);
    canvas.drawCircle(center, 98, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MiniPlanet extends StatelessWidget {
  final Color color;
  final double size;

  const _MiniPlanet({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 18),
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
        ..color = Colors.white.withValues(alpha: star.brightness * twinkle)
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
  final double scale;

  OrbitPainter(this.planets, this.animation, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final planet in planets) {
      final scaledRadius = planet.orbitRadius * scale;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(center, scaledRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) => true;
}

class SunWidget extends StatelessWidget {
  final double size;

  const SunWidget({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Colors.yellow, Colors.orange, Colors.red],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withValues(alpha: 0.9),
            blurRadius: size * 0.5,
            spreadRadius: size * 0.15,
          ),
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.6),
            blurRadius: size * 0.75,
            spreadRadius: size * 0.25,
          ),
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: size,
            spreadRadius: size * 0.35,
          ),
        ],
      ),
    );
  }
}
