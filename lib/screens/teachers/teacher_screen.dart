import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/teacher_assisgnment_model.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final auth = AuthController.instance;

    final bool? logout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.logout,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text("Logout"),
          ],
        ),
        content: const Text(
          "Are you sure you want to logout?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
    );

    if (logout == true) {
      await auth.logout();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.instance;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(
    color: Colors.white,
  ),
        title: const Text(
          "Teacher Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Obx(() {
        final user = auth.currentUser.value;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final assignments = user.teachingAssignments;

        return Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff4F46E5),
                    Color(0xff6366F1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.indigo,
                      size: 38,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "${assignments.length} Assigned Subject(s)",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Subjects",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Continue in Part 2
                        Expanded(
              child: assignments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 90,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "No Teaching Assignments",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Please contact the administrator.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        16,
                      ),
                      itemCount: assignments.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 14),
                      itemBuilder: (_, index) {
                        final TeachingAssignmentModel assignment =
                            assignments[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.teacherTopics,
                              arguments: {
                                "classId": assignment.classId,
                                "className": assignment.className,
                                "subjectId": assignment.subjectId,
                                "subjectName":
                                    assignment.subjectName,
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo
                                          .shade50,
                                      borderRadius:
                                          BorderRadius.circular(
                                              15),
                                    ),
                                    child: Icon(
                                      Icons.menu_book_rounded,
                                      color:
                                          Colors.indigo.shade700,
                                      size: 30,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          assignment.subjectName,
                                          style:
                                              const TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(
                                            height: 6),

                                        Row(
                                          children: [
                                            Icon(
                                              Icons.school,
                                              size: 18,
                                              color: Colors
                                                  .grey
                                                  .shade600,
                                            ),
                                            const SizedBox(
                                                width: 5),
                                            Text(
                                              assignment
                                                  .className,
                                              style:
                                                  TextStyle(
                                                color: Colors
                                                    .grey
                                                    .shade700,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration:
                                            BoxDecoration(
                                          color: Colors.green
                                              .shade100,
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      30),
                                        ),
                                        child: Text(
                                          "Open",
                                          style: TextStyle(
                                            color: Colors
                                                .green
                                                .shade700,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 10),
                                      const Icon(
                                        Icons
                                            .arrow_forward_ios_rounded,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );}),

      drawer: Drawer(

        child: Obx(() {
          final user = auth.currentUser.value;
        
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                ),
                currentAccountPicture: const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.indigo,
                    size: 45,
                  ),
                ),
                accountName: Text(
                  user?.name ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  user?.email ?? "",
                ),
              ),
        
              ListTile(
                leading: const Icon(
                  Icons.history,
                  color: Colors.indigo,
                ),
                title: const Text(
                  "History",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.teacherHistory);
                },
              ),
        
              const Divider(height: 1),
        
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.indigo,
                ),
                title: const Text(
                  "Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.teacherProfile);
                },
              ),

               ListTile(
                leading: const Icon(
                  Icons.payments,
                  color: Colors.indigo,
                ),
                title: const Text(
                  "Payment",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.paymentTeacher);
                },
              ),
        
              const Divider(height: 1),
        
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _showLogoutDialog(context);
                },
              ),
        
              const SizedBox(height: 30),
        
              const Center(
                child: Text(
                  "Tito Teachers App",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        
              const SizedBox(height: 6),
        
              const Center(
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}