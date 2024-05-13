import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sacred_hearts/users/authentication/login_screen.dart';
import 'package:sacred_hearts/users/userPreferences/user_preferences.dart';
import 'package:sacred_hearts/users/fragments/dashboard_fragment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scared Hearts Congregation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return FutureBuilder(
              future: RememberUserPrefs.readUserInfo(),
              builder: (context, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator or a splash screen widget
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (dataSnapshot.hasError) {
                  // Handle error
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${dataSnapshot.error}'),
                    ),
                  );
                } else {
                  if (dataSnapshot.data == null) {
                    return LoginScreen();
                  } else {
                    return DashboardFrag();
                  }
                }
              },
            );
          },
        ),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

