import 'package:flutter/material.dart';
import 'router.dart' as app_scaffold;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinilify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF272727),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF272727),
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
          headlineLarge: TextStyle(
            color: Color(0xFF272727),
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFF272727),
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        useMaterial3: true,
      ),
      home: const app_scaffold.Router(),
    );
  }
}
