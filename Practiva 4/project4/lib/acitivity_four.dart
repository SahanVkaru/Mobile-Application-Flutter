import 'package:flutter/material.dart';

class ActivityFour extends StatelessWidget {
  const ActivityFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Four')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            print('Container tapped!');
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'tap me',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
