import 'package:flutter/material.dart';
import 'package:linked_in/providers/auth_provider.dart';
import 'package:linked_in/providers/comment_provider.dart';
import 'package:linked_in/providers/home_screen_post_provider.dart';
import 'package:linked_in/providers/job_provider.dart';
import 'package:linked_in/providers/post_provider.dart';
import 'package:linked_in/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';

void main() {
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => HomescreenPostProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0077B5), // LinkedIn blue
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B5),
          primary: const Color(0xFF0077B5),
          secondary: const Color(0xFF00A0DC),
          // ignore: deprecated_member_use
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0077B5)),
          titleTextStyle: TextStyle(
            color: Color(0xFF0077B5),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0077B5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF0077B5)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
