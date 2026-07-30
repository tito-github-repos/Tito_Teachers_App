import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/auth_controller.dart';
import 'package:tito_teachers_app/controllers/class_controller.dart';
import 'package:tito_teachers_app/controllers/subject_controller.dart';
import 'package:tito_teachers_app/models/class_model.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController auth = AuthController.instance;

  final ClassController classController =
      Get.find<ClassController>();

  final SubjectController subjectController =
      Get.find<SubjectController>();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  ClassModel? selectedClass;
  SubjectModel? selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Obx(
              () => Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  // Image.asset(
                  //   "assets/images/logo.png",
                  //   height: 100,
                  // ),


 const Icon(
                    Icons.school_rounded,
                    size: 90,
                    color: Colors.blue,
                  ),


                  const SizedBox(height: 25),

                  TextFormField(
                    controller: auth.nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: auth.phoneController,
                    keyboardType:
                        TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Enter phone number";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: auth.emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Enter email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller:
                        auth.passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon:
                          const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.length < 6) {
                        return "Minimum 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: auth
                        .confirmPasswordController,
                    obscureText:
                        obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText:
                          "Confirm Password",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword =
                                !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value !=
                          auth.passwordController
                              .text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Select Role",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  RadioListTile<String>(
                    value: "student",
                    groupValue:
                        auth.selectedRole.value,
                    title: const Text("Student"),
                    onChanged: (value) {
                      auth.setRole(value!);

                      setState(() {
                        selectedClass = null;
                        selectedSubject = null;
                      });
                    },
                  ),

                  RadioListTile<String>(
                    value: "teacher",
                    groupValue:
                        auth.selectedRole.value,
                    title: const Text("Teacher"),
                    onChanged: (value) {
                      auth.setRole(value!);

                      setState(() {
                        selectedClass = null;
                        selectedSubject = null;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                                  
                 
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: auth.isLoading.value
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!
                                  .validate()) {
                                await auth.register();
                              }
                            },
                      child: auth.isLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                      ),
                      TextButton(
                        onPressed: () {
                          auth.clearControllers();
                          Get.back();
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}