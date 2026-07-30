import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tito_teachers_app/models/teacher_assisgnment_model.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';

import '../models/user_model.dart';
import '../repositories/auth_repo.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthRepository _repository = AuthRepository.instance;

  //==========================================================
  // Loading
  //==========================================================

  final RxBool isLoading = false.obs;

  //==========================================================
  // Current User
  //==========================================================

  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  UserModel? get user => currentUser.value;

  bool get isLoggedIn =>
      FirebaseAuth.instance.currentUser != null;

  bool get isTeacher =>
      currentUser.value?.role == "teacher";

  bool get isStudent =>
      currentUser.value?.role == "student";

  bool get isAdmin =>
      currentUser.value?.role == "admin";

  //==========================================================
  // Controllers
  //==========================================================

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  //==========================================================
  // Registration
  //==========================================================

  final RxString selectedRole = "student".obs;

  final RxString selectedClassId = "".obs;

  final RxString selectedClassName = "".obs;

  final RxList<TeachingAssignmentModel>
      teachingAssignments =
      <TeachingAssignmentModel>[].obs;

  //==========================================================
  // Init
  //==========================================================

  @override
  void onInit() {
    super.onInit();

    _repository.authStateChanges().listen((user) {
      if (user != null) {
        loadCurrentUser();
      } else {
        currentUser.value = null;
      }
    });
  }

  //==========================================================
  // Login
  //==========================================================
Future<void> login() async {
  try {
    isLoading.value = true;

    final credential = await _repository.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (credential.user != null) {
      final user = await loadCurrentUser();

      Get.snackbar(
        "Success",
        "Login Successful",
        snackPosition: SnackPosition.BOTTOM,
      );

      switch (user?.role.toLowerCase()) {
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

  //==========================================================
  // Logout
  //==========================================================

  Future<void> logout() async {
    await _repository.logout();

    clearControllers();

    currentUser.value = null;
  }

  //==========================================================
  // Load User
  //==========================================================
Future<UserModel?> loadCurrentUser() async {
  try {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      currentUser.value = null;
      return null;
    }

    final user = await _repository.getUser(firebaseUser.uid);

    currentUser.value = user;

    return user;
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
    );

    return null;
  }
}

  //==========================================================
  // Helpers
  //==========================================================

  void clearControllers() {
    nameController.clear();

    phoneController.clear();

    emailController.clear();

    passwordController.clear();

    confirmPasswordController.clear();

    selectedRole.value = "student";

    selectedClassId.value = "";

    selectedClassName.value = "";

    teachingAssignments.clear();
  }

  bool validateLogin() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Email is required",
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Password is required",
      );
      return false;
    }

    return true;
  }

  bool validateRegister() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Enter name",
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Enter phone number",
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Enter email",
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters",
      );
      return false;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
      );
      return false;
    }

    return true;
  }
    //==========================================================
  // Register
  //==========================================================

//   Future<void> register() async {
//     if (!validateRegister()) return;

//     try {
//       isLoading.value = true;

//       // Student must select class
//       if (selectedRole.value == "student") {
//         if (selectedClassId.value.isEmpty) {
//           Get.snackbar(
//             "Error",
//             "Please select class",
//           );
//           return;
//         }
//       }

//       // Teacher must have at least one assignment
//       if (selectedRole.value == "teacher") {
//         if (teachingAssignments.isEmpty) {
//           Get.snackbar(
//             "Error",
//             "Assign at least one Class & Subject",
//           );
//           return;
//         }
//       }

//       final credential = await _repository.register(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       final uid = credential.user!.uid;

//       final user = UserModel(
//         uid: uid,
//         name: nameController.text.trim(),
//         phone: phoneController.text.trim(),
//         email: emailController.text.trim(),
//         role: selectedRole.value,
//         classId: selectedRole.value == "student"
//             ? selectedClassId.value
//             : null,
//         className: selectedRole.value == "student"
//             ? selectedClassName.value
//             : null,
//         teachingAssignments:
//             List<TeachingAssignmentModel>.from(
//           teachingAssignments,
//         ),
//         createdAt: Timestamp.now(),
//       );

//       await _repository.saveUser(user);

//       currentUser.value = user;

//       Get.snackbar(
//         "Success",
//         "Registration Successful",
//         snackPosition: SnackPosition.BOTTOM,
//       );


// switch (user.role.toLowerCase()) {
//   case "teacher":
//     Get.offAllNamed(AppRoutes.teacher);
//     break;

//   case "student":
//     Get.offAllNamed(AppRoutes.student);
//     break;

//   case "admin":
//     Get.offAllNamed(AppRoutes.admin);
//     break;

//   default:
//     Get.offAllNamed(AppRoutes.login);
// }
//       clearControllers();
//     } catch (e) {
//       Get.snackbar(
//         "Registration Failed",
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

Future<void> register() async {
  if (!validateRegister()) return;

  try {
    isLoading.value = true;

    final credential = await _repository.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final uid = credential.user!.uid;

    final user = UserModel(
      uid: uid,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      role: selectedRole.value,
        teachingAssignments: [],

      createdAt: Timestamp.now(),
    );

    await _repository.saveUser(user);

    currentUser.value = user;

    Get.snackbar(
      "Success",
      "Registration Successful",
      snackPosition: SnackPosition.BOTTOM,
    );

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

    clearControllers();
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

  //==========================================================
  // Teaching Assignments
  //==========================================================

  void addTeachingAssignment({
    required String classId,
    required String className,
    required String subjectId,
    required String subjectName,
  }) {
    final alreadyExists = teachingAssignments.any(
      (item) =>
          item.classId == classId &&
          item.subjectId == subjectId,
    );

    if (alreadyExists) {
      Get.snackbar(
        "Duplicate",
        "Assignment already added",
      );
      return;
    }

    teachingAssignments.add(
      TeachingAssignmentModel(
        classId: classId,
        className: className,
        subjectId: subjectId,
        subjectName: subjectName,
      ),
    );
  }

  void removeTeachingAssignment(
      TeachingAssignmentModel assignment) {
    teachingAssignments.remove(assignment);
  }

  void clearTeachingAssignments() {
    teachingAssignments.clear();
  }

  //==========================================================
  // Student Class
  //==========================================================

  void setStudentClass({
    required String classId,
    required String className,
  }) {
    selectedClassId.value = classId;
    selectedClassName.value = className;
  }

  //==========================================================
  // Role
  //==========================================================

  void setRole(String role) {
    selectedRole.value = role;

    if (role == "teacher") {
      selectedClassId.value = "";
      selectedClassName.value = "";
    } else {
      teachingAssignments.clear();
    }
  }

  //==========================================================
  // Reset Password
  //==========================================================

  Future<void> resetPassword() async {
    try {
      if (emailController.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Enter your email",
        );
        return;
      }

      await _repository.resetPassword(
        emailController.text.trim(),
      );

      Get.snackbar(
        "Success",
        "Password reset email sent",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  //==========================================================
  // Dispose
  //==========================================================

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}