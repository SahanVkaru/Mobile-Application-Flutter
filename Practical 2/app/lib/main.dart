import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SahanWidget(),
    );
  }
}

class SahanWidget extends StatefulWidget {
  const SahanWidget({super.key});

  @override
  State<SahanWidget> createState() => _SahanWidgetState();
}

class _SahanWidgetState extends State<SahanWidget> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OctoImage(
            image: const NetworkImage(
              'https://gifimage.net/gifs/anime-ftboqxz.gif',
            ),
            placeholderBuilder: OctoPlaceholder.circularProgressIndicator(),
            errorBuilder: OctoError.icon(color: Colors.red),
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/coke.jpg',
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
        ],
      ),
    ),
    const Center(child: Text('Index 1: Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sahan')),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Clicked!')),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
