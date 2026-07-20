import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/class_controller.dart';
import '../../controllers/subject_controller.dart';
import '../../models/class_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController auth = AuthController.instance;
  final ClassController classController = Get.find<ClassController>();
  final SubjectController subjectController = Get.find<SubjectController>();

  final _formKey = GlobalKey<FormState>();

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: auth.nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: auth.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter phone number";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: auth.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: auth.passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Minimum 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: auth.confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_outline),
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
                      if (value != auth.passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Select Role",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  RadioListTile<String>(
                    value: "student",
                    groupValue: auth.selectedRole.value,
                    title: const Text("Student"),
                    onChanged: (value) {
                      auth.setRole(value!);
                    },
                  ),

                  RadioListTile<String>(
                    value: "teacher",
                    groupValue: auth.selectedRole.value,
                    title: const Text("Teacher"),
                    onChanged: (value) {
                      auth.setRole(value!);
                    },
                  ),

                  const SizedBox(height: 20),

                  if (auth.selectedRole.value == "student") ...[
                    DropdownButtonFormField<ClassModel>(
                      value: selectedClass,
                      decoration: const InputDecoration(
                        labelText: "Select Class",
                      ),
                      items: classController.classes
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClass = value;
                        });

                        if (value != null) {
                          auth.setStudentClass(
                            classId: value.id,
                            className: value.name,
                          );
                        }
                      },
                    ),
                  ],

                  if (auth.selectedRole.value == "teacher") ...[
                    DropdownButtonFormField<ClassModel>(
                      value: selectedClass,
                      decoration: const InputDecoration(
                        labelText: "Select Class",
                      ),
                      items: classController.classes
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClass = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<SubjectModel>(
                      value: selectedSubject,
                      decoration: const InputDecoration(
                        labelText: "Select Subject",
                      ),
                      items: subjectController.subjects
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubject = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: () {
                        if (selectedClass == null ||
                            selectedSubject == null) {
                          Get.snackbar(
                            "Error",
                            "Select both Class and Subject",
                          );
                          return;
                        }

                        auth.addTeachingAssignment(
                          classId: selectedClass!.id,
                          className: selectedClass!.name,
                          subjectId: selectedSubject!.id,
                          subjectName: selectedSubject!.name,
                        );

                        setState(() {
                          selectedSubject = null;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Assignment"),
                    ),

                    const SizedBox(height: 20),
                                        Obx(
                      () {
                        if (auth.teachingAssignments.isEmpty) {
                          return const SizedBox();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Teaching Assignments",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 10),

                            ListView.separated(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount:
                                  auth.teachingAssignments.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final assignment =
                                    auth.teachingAssignments[index];

                                return Card(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.menu_book,
                                    ),
                                    title: Text(
                                      assignment.subjectName,
                                    ),
                                    subtitle: Text(
                                      assignment.className,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        auth.removeTeachingAssignment(
                                          assignment,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: auth.isLoading.value
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!
                                  .validate()) {
                                auth.register();
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
                ]
            ),
          ),
        ),
      ),
    ));
  }
}