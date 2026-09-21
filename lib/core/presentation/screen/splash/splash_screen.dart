import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/core/presentation/screen/onboarding/on_boarding.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _navigate();
    });
  }

  void _navigate() {
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;

    if (user != null) {
      // Already logged in — go directly to home
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Not logged in — show onboarding first, then login
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OnBoarding()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SvgPicture.asset(
            'assets/images/svgs/splash.svg',
            fit: BoxFit.fill,
            width: size.width,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'STORY TELLER',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Carlito Bold'),
          ),
          SizedBox(height: size.height * 0.018),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Text(
              'Fairy Tells" Is A Marvelous Collection Of Story Books For Kids That Includes Such Bedtime Stories For Kids',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Carlito Regular', fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 87, left: 87),
            child: Lottie.asset('assets/animation/loader2.json'),
          )
        ],
      ),
    );
  }
}
