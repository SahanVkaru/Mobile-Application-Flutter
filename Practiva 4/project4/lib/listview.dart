import 'package:flutter/material.dart';

class MyListView extends StatelessWidget {
  const MyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit List'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('apple'),
          ),
          ListTile(
            title: Text('banna'),
          ),
          ListTile(
            title: Text('orange'),
          ),
        ],
      ),
    );
  }
}
