import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'screens/login_screen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/dashboard_screen.dart';
import 'navigation/bottom_nav.dart';

void main() {
  runApp(const GymMasterApp());
}

class GymMasterApp extends StatelessWidget {
  const GymMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      primaryColor: AppColors.red700,
      scaffoldBackgroundColor: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GymMaster',
      theme: base.copyWith(
        textTheme: GoogleFonts.interTextTheme(base.textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.red700),
      ),
      initialRoute: '/',
      routes: {
        '/': (c) => const LoginScreen(),
        '/dashboard': (c) => const DashboardScreen(),
        '/app': (c) => const BottomNav(),
         '/register': (c) => const RegisterScreen(), 
      },
    );
  }
}
