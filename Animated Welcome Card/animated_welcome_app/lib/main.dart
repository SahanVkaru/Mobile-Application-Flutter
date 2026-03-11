import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Welcome App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// WelcomeScreen — contains all three animations
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Controller for fade + scale animations (3 seconds)
  late AnimationController _fadeScaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Controller for continuous rotation
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // --- Fade & Scale controller (duration: 3 seconds) ---
    _fadeScaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Fade: opacity 0 → 1
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeScaleController, curve: Curves.easeInOut),
    );

    // Scale: 0.5 → 1.0
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _fadeScaleController, curve: Curves.easeInOut),
    );

    // Start the fade + scale animation
    _fadeScaleController.forward();

    // --- Rotation controller (continuous) ---
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _rotationController.repeat(); // rotate continuously
  }

  @override
  void dispose() {
    _fadeScaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  /// Restart the fade + scale animation from the beginning
  void _restartAnimation() {
    _fadeScaleController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Welcome App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        // FadeTransition wraps the entire card
        child: FadeTransition(
          opacity: _fadeAnimation,
          // ScaleTransition makes the card grow from 0.5 → 1.0
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Rotating Flutter logo
                    RotationTransition(
                      turns: _rotationController,
                      child: const FlutterLogo(size: 80),
                    ),
                    const SizedBox(height: 16),

                    // Asset image
                    Image.asset('asset/1.png', height: 200),
                    const SizedBox(height: 16),

                    // Welcome text
                    const Text(
                      'Welcome to Flutter Animations',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Restart Animation button
                    ElevatedButton.icon(
                      onPressed: _restartAnimation,
                      icon: const Icon(Icons.replay),
                      label: const Text('Restart Animation'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
