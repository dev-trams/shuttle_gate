import 'package:flutter/material.dart';
import 'package:shuttle_gate/screens/screen_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoreScreen());
}

class CoreScreen extends StatelessWidget {
  const CoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SBMSystem',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
      },
    );
  }
}
