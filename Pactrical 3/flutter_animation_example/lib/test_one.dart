import 'package:flutter/material.dart';

class TestOne extends StatefulWidget {
  const TestOne({super.key});

  @override
  State<TestOne> createState() => _TestOneState();
}

class _TestOneState extends State<TestOne> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    //fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    //scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    //bounce animation (vertical movement)
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Move up by 30 pixels
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));

    // Don't auto-start animation - wait for button press
  }

  void _toggleAnimation() {
    setState(() {
      if (_isAnimating) {
        // Stop animation
        _controller.stop();
        _controller.reset();
        _isAnimating = false;
      } else {
        // Start looping animation
        _controller.repeat();
        _isAnimating = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test One')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "Hello flutter",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _toggleAnimation,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAnimating ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              _isAnimating ? 'Stop Animation' : 'Start Animation',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
