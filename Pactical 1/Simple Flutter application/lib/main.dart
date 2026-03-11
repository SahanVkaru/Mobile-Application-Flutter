import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laundry_app/features/auth/providers/auth_provider.dart';
import 'package:laundry_app/features/auth/screens/login_screen.dart';
import 'package:laundry_app/features/home/screens/home_screen.dart';
import 'package:laundry_app/features/cart/providers/cart_provider.dart';
import 'package:laundry_app/features/cart/screens/cart_screen.dart';
import 'package:laundry_app/features/profile/screens/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const LaundryApp(),
    ),
  );
}

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Laundry App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      home: const LoginScreen(),
    );
  }
}
