import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/student_subject_model.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/topic_progress_controller.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {

  final auth = AuthController.instance;
  final progressController =
      TopicProgressController.instance;

      late Future<List<StudentSubjectItem>> _subjectsFuture;
@override
void initState() {
  super.initState();

  final user = auth.user;

  if (user == null || user.classId == null) {
    _subjectsFuture = Future.value([]);
    return;
  }

  progressController.listenClassHistory(
    user.classId!,
      user.assignedTeachers,

  );

  _subjectsFuture =
      progressController.getStudentSubjects(
    classId: user.classId!,
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

        final user = auth.user;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (user.classId == null) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "Your account is waiting for class assignment.",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Please contact your administrator.\nYour class and subjects have not been assigned yet.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

        final history =
            progressController.classHistory;

        final today = DateTime.now();

        final todayCount = history.where((e) {
          final d = e.completedAt.toDate();

          return d.year == today.year &&
              d.month == today.month &&
              d.day == today.day;
        }).length;

       return FutureBuilder<List<StudentSubjectItem>>(
  future: _subjectsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final subjectList = snapshot.data ?? [];
    final subjects = subjectList.length;

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
                    color:
                        Colors.indigo.withOpacity(.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.school,
                      color: Colors.indigo,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(25),
                    ),
                    child: Text(
                      user.className ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: _statCard(
                    "Subjects",
                    subjects.toString(),
                    Icons.menu_book,
                    Colors.indigo,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    "Topics",
                    history.length.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    "Today",
                    todayCount.toString(),
                    Icons.today,
                    Colors.orange,
                  ),
                ),
              ],
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
                    (user.phone?.isNotEmpty ?? false)
                        ? user.phone!
                        : "-",
                  ),

                  const Divider(),

                  _infoTile(
                    Icons.school,
                    "Class",
                    user.className ?? "-",
                  ),

                  const Divider(),

                  _infoTile(
                    Icons.badge,
                    "Role",
                    "Student",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Learning Summary",
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

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.green.shade100,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade700,
                      ),
                    ),
                    title: const Text(
                      "Completed Topics",
                    ),
                    trailing: Text(
                      history.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.blue.shade100,
                      child: Icon(
                        Icons.menu_book,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    title: const Text(
                      "Subjects Learned",
                    ),
                    trailing: Text(
                      subjects.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.orange.shade100,
                      child: Icon(
                        Icons.today,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    title: const Text(
                      "Topics Completed Today",
                    ),
                    trailing: Text(
                      todayCount.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
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
      });
      }));


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
          CircleAvatar(
            radius: 22,
            backgroundColor:
                color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          const SizedBox(height: 12),

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
              color: Colors.grey.shade600,
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