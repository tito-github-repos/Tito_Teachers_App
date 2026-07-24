import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/teacher_assisgnment_model.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/topic_progress_controller.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() =>
      _TeacherProfileScreenState();
}

class _TeacherProfileScreenState
    extends State<TeacherProfileScreen> {

  final auth = AuthController.instance;
  final progressController =
      TopicProgressController.instance;

  @override
  void initState() {
    super.initState();

    progressController.listenTeacherHistory(
      auth.user!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {

        final user = auth.currentUser.value;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final assignments =
            user.teachingAssignments;

        final completed =
            progressController.teacherHistory.length;

        final classCount = assignments
            .map((e) => e.classId)
            .toSet()
            .length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff4F46E5),
                    Color(0xff6366F1),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(.25),
                    blurRadius: 12,
                    offset: const Offset(0,5),
                  ),
                ],
              ),

              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(height:16),

                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height:6),

                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height:18),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal:16,
                      vertical:8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Teacher",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height:20),

            Row(
              children: [

                Expanded(
                  child: _statCard(
                    "Completed",
                    completed.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),

                const SizedBox(width:12),

                Expanded(
                  child: _statCard(
                    "Subjects",
                    assignments.length.toString(),
                    Icons.menu_book,
                    Colors.indigo,
                  ),
                ),

                const SizedBox(width:12),

                Expanded(
                  child: _statCard(
                    "Classes",
                    classCount.toString(),
                    Icons.school,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height:24),

            const Text(
              "Assigned Subjects",
              style: TextStyle(
                fontSize:20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:12),

            assignments.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        "No Assigned Subjects",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: assignments.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final TeachingAssignmentModel item =
                          assignments[index];

                      return Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Row(
                          children: [

                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color:
                                    Colors.indigo.shade50,
                                borderRadius:
                                    BorderRadius.circular(
                                        15),
                              ),
                              child: Icon(
                                Icons.menu_book,
                                color:
                                    Colors.indigo.shade700,
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
                                    item.subjectName,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    item.className,
                                    style: TextStyle(
                                      color: Colors
                                          .grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.green.shade100,
                                borderRadius:
                                    BorderRadius.circular(
                                        30),
                              ),
                              child: Text(
                                "Active",
                                style: TextStyle(
                                  color:
                                      Colors.green.shade700,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 24),

            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(18),
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
              child: Column(
                children: [

                  _infoTile(
                    Icons.person,
                    "Name",
                    user.name,
                  ),

                  const Divider(),

                  _infoTile(
                    Icons.email,
                    "Email",
                    user.email,
                  ),

                  const Divider(),

                  _infoTile(
                    Icons.phone,
                    "Phone",
                    user.phone.isEmpty
                        ? "-"
                        : user.phone,
                  ),

                  const Divider(),

                  _infoTile(
                    Icons.badge,
                    "Role",
                    "Teacher",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final logout = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      title: const Text("Logout"),
                      content: const Text(
                        "Are you sure you want to logout?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor:
                                Colors.white,
                          ),
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );

                  if (logout == true) {
                    await auth.logout();
                    Get.offAllNamed(
                      AppRoutes.login,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        );
      }),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
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
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.indigo.shade50,
        child: Icon(
          icon,
          color: Colors.indigo,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}