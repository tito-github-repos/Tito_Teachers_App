import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }
Future<void> _checkLogin() async {
  await Future.delayed(const Duration(seconds: 2));

  final user = await _authController.loadCurrentUser();

  if (!mounted) return;

  if (user == null) {
    Get.offAllNamed(AppRoutes.login);
    return;
  }

  switch (user.role.toLowerCase()) {
    case "teacher":
      Get.offAllNamed(AppRoutes.teacher);
      break;

    case "student":
      Get.offAllNamed(AppRoutes.student);
      break;

    case "admin":
      Get.offAllNamed(AppRoutes.admin);
      break;

    default:
      Get.offAllNamed(AppRoutes.login);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/images/logo.png',
              //   height: 120,
              // ),

              
 const Icon(
                    Icons.school_rounded,
                    size: 90,
                    color: Colors.blue,
                  ),

              const SizedBox(height: 24),
              const Text(
                'Tito Teachers',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}