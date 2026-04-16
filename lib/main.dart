import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'audio_service.dart';
import 'welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AteneaApp());
}

class AteneaApp extends StatefulWidget {
  const AteneaApp({super.key});

  @override
  State<AteneaApp> createState() => _AteneaAppState();
}

class _AteneaAppState extends State<AteneaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        AudioService.I.pauseMusic();
      case AppLifecycleState.resumed:
        AudioService.I.startMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Atenea's Field",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        useMaterial3: true,
        fontFamily: 'Cinzel',
      ),
      home: const WelcomeScreen(),
    );
  }
}
