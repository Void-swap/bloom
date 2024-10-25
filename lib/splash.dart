import 'package:bloom/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnUser();
  }

  Future<void> _navigateBasedOnUser() async {
    await Future.delayed(const Duration(seconds: 3));
    final user = box.read('userData');

    if (user != null) {
      // Email exists in storage, navigate to Home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Email does not exist, navigate to Sign-In screen
      Navigator.pushReplacementNamed(context, '/registerLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/logo.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            const Text(
              'HIVE',
              style: TextStyle(
                  color: orange,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              'Harnessing Inclusivity, Vision, Empowerment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
