import 'package:flutter/material.dart';
import 'package:responsi/pages/main_page.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'providers/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi AppState n cek session yg tersimpan
  final appState = AppState();
  await appState.tryAutoLogin();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AppState>().isLoggedIn;
    
    return MaterialApp(
      title: 'Responsi Mobile',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}