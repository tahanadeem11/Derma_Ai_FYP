import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heal_wiz_application/Screens/homePage.dart';
import 'home.dart';
import 'onboarding_screen.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //TODO: Add a method to check if the user is logged in you can move this method to a auth
  bool checkIfUserIsLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  void initState() {
    super.initState();

    // Wait for 5 seconds and then navigate to the next screen
    Timer(
      const Duration(seconds: 6),
      () {
        // Check if the user is logged in
        bool isLoggedIn = checkIfUserIsLoggedIn();

        if (isLoggedIn) {
          // If the user is logged in, navigate to the home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // If the user is not logged in, navigate to the sign in screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => IntroductionPageView()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash logo.jpg'),
               fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
