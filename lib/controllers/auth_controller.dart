import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var role = "student".obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> register(List<String> subjects) async {
    try {
      isLoading.value = true;

      await _repository.register(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: role.value,
        subjects: subjects,
      );

      final user = await _repository.getUser();

      if (user == null) {
        Get.snackbar(
          "Error",
          "Unable to load user details.",
        );
        return;
      }

      Get.snackbar(
        "Success",
        "Registration Successful",
        snackPosition: SnackPosition.BOTTOM,
      );

      switch (user.role) {
        case "teacher":
          Get.offAllNamed("/teacher");
          break;

        case "student":
          Get.offAllNamed("/student");
          break;

        case "admin":
          Get.offAllNamed("/admin");
          break;

        default:
          Get.offAllNamed("/login");
      }
    } catch (e) {
      Get.snackbar(
        "Registration Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    try {
      isLoading.value = true;

      await _repository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = await _repository.getUser();

      if (user == null) {
        Get.snackbar(
          "Error",
          "Unable to load user details.",
        );
        return;
      }

      switch (user.role) {
        case "teacher":
          Get.offAllNamed("/teacher");
          break;

        case "student":
          Get.offAllNamed("/student");
          break;

        case "admin":
          Get.offAllNamed("/admin");
          break;

        default:
          Get.offAllNamed("/login");
      }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    Get.offAllNamed("/login");
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!_repository.isLoggedIn()) {
      Get.offAllNamed("/login");
      return;
    }

    final role = await _repository.getUserRole();

    switch (role) {
      case "teacher":
        Get.offAllNamed("/teacher");
        break;

      case "student":
        Get.offAllNamed("/student");
        break;

      case "admin":
        Get.offAllNamed("/admin");
        break;

      default:
        Get.offAllNamed("/login");
    }
  }
}