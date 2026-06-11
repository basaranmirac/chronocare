import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'business/app_provider.dart';
import 'ui/login_screen.dart';

void main() {
  runApp(
    // Uygulamayı ChangeNotifierProvider ile sarıyoruz ki tüm ekranlar state'e erişebilsin
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const ChronoCareApp(),
    ),
  );
}

class ChronoCareApp extends StatelessWidget {
  const ChronoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider'dan tema durumunu anlık olarak alıyoruz
    final isDarkMode = Provider.of<AppProvider>(context).isDarkMode;

    return MaterialApp(
      title: 'ChronoCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema durumuna göre Brightness ve Arka Plan renkleri değişiyor
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkMode ? Colors.black : Colors.amber,
          foregroundColor: isDarkMode ? Colors.amber : Colors.black, 
        ),
      ),
      home: const LoginScreen(),
    );
  }
}