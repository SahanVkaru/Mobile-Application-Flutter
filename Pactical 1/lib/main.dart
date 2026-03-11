import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'features/weighing/presentation/pages/weighing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(AppStrings.hiveBoxName);

  runApp(const ProviderScope(child: TeaSmartApp()));
}

class TeaSmartApp extends ConsumerWidget {
  const TeaSmartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      home: const WeighingScreen(),
    );
  }
}
