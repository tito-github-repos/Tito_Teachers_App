import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/auth_controller.dart';
import 'package:tito_teachers_app/controllers/topic_progress_controller.dart';
import 'package:tito_teachers_app/models/student_subject_model.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() =>
      _StudentHomeScreenState();
}

class _StudentHomeScreenState
    extends State<StudentHomeScreen> {

  final AuthController auth = AuthController.instance;

  final TopicProgressController progressController =
      TopicProgressController.instance;

  late Future<List<StudentSubjectItem>>
      _subjectsFuture;
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

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4F46E5),
                    Color(0xff6366F1),
                  ],
                ),
              ),
              child: Obx(() {
                final user = auth.user;

                if (user == null) {
                  return const SizedBox();
                }

                return Column(
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.school,
                        size: 42,
                        color: Colors.indigo,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
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
                );
              }),
            ),

            const SizedBox(height: 10),

            _drawerItem(
              Icons.history,
              "Learning History",
              () {
                Navigator.pop(context);

                Get.toNamed(
                  AppRoutes.studentHistory,
                );
              },
            ),

            _drawerItem(
              Icons.person,
              "My Profile",
              () {
                Navigator.pop(context);

                Get.toNamed(
                  AppRoutes.studentProfile,
                );
              },
            ),

              _drawerItem(
              Icons.payment,
              "Payment",
              () {
                Navigator.pop(context);

                Get.toNamed(
                  AppRoutes.paymentStudent,
                );
              },
            ),

            const Spacer(),

            const Divider(height: 1),

            _drawerItem(
              Icons.logout,
              "Logout",
              () async {
                Navigator.pop(context);

                final logout =
                    await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text(
                      "Are you sure you want to logout?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(
                                context, false),
                        child:
                            const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                          foregroundColor:
                              Colors.white,
                        ),
                        onPressed: () =>
                            Navigator.pop(
                                context, true),
                        child:
                            const Text("Logout"),
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
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Student Dashboard",
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
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "Your account is waiting for approval.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Your class and subjects have not been assigned yet.\nPlease contact the administrator.",
            textAlign: TextAlign.center,
             style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}

  final history = progressController.classHistory;

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
      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(
            snapshot.error.toString(),
          ),
        );
      }

      final subjects = snapshot.data ?? [];

      return Column(
        children: [

          ///==========================
          /// Welcome Card
          ///==========================
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
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
                    Icons.school,
                    color: Colors.indigo,
                    size: 38,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Class : ${user.className}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///==========================
          /// Dashboard Cards
          ///==========================
          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [

                Expanded(
                  child: _statCard(
                    "Subjects",
                    subjects.length.toString(),
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
          ),

          const SizedBox(height: 20),

          const Padding(
            padding:
                EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "My Subjects",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          
          Expanded(
  child: subjects.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      Colors.indigo.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  size: 70,
                  color:
                      Colors.indigo.shade400,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "No Subjects Assigned",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "No subjects have been assigned\nfor your class.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        )
      : ListView.separated(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            20,
          ),
          itemCount: subjects.length,
          separatorBuilder:
              (_, __) =>
                  const SizedBox(
            height: 14,
          ),
          itemBuilder:
              (context, index) {

            final item =
                subjects[index];

            return InkWell(
              borderRadius:
                  BorderRadius.circular(
                      20),
              onTap: () {
                Get.toNamed(
                  AppRoutes.studentSubjects,
                  arguments: {
                    "subjectId":
                        item.subjectId,
                    "subjectName":
                        item.subjectName,
                  },
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.all(
                        18),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius
                          .circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors
                          .grey
                          .shade300,
                      blurRadius: 10,
                      offset:
                          const Offset(
                              0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [

                    Container(
                      width: 60,
                      height: 60,
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .indigo
                            .shade50,
                        borderRadius:
                            BorderRadius
                                .circular(
                                    18),
                      ),
                      child: Icon(
                        Icons.menu_book,
                        color: Colors
                            .indigo
                            .shade700,
                        size: 30,
                      ),
                    ),

                    const SizedBox(
                        width: 16),

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
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            "${item.completedTopics} Topics Completed",
                            style:
                                TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          Row(
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      12,
                                  vertical:
                                      5,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .green
                                      .shade100,
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Text(
                                  "Available",
                                  style:
                                      TextStyle(
                                    color: Colors
                                        .green
                                        .shade700,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize:
                                        12,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 8),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      12,
                                  vertical:
                                      5,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: item.completedTopics >
                                          0
                                      ? Colors
                                          .blue
                                          .shade100
                                      : Colors
                                          .grey
                                          .shade200,
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Text(
                                  "${item.completedTopics} Lessons",
                                  style:
                                      TextStyle(
                                    color: item.completedTopics >
                                            0
                                        ? Colors
                                            .blue
                                            .shade700
                                        : Colors
                                            .grey
                                            .shade700,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize:
                                        12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 44,
                      height: 44,
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .indigo
                            .shade50,
                        shape: BoxShape
                            .circle,
                      ),
                      child: const Icon(
                        Icons
                            .arrow_forward_ios,
                        size: 18,
                        color: Colors
                            .indigo,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
)
        ],
      );
    },
  );
}),
    );
  }
}

Widget _drawerItem(IconData icon,String title,VoidCallback onTap,) {return ListTile(leading: Icon(icon,color: Colors.indigo,),title: Text(title,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,),),trailing: const Icon(Icons.arrow_forward_ios,size: 16,color: Colors.grey,),onTap: onTap,);}

Widget _statCard(String title,String value,IconData icon,Color color,) {return Container(padding: const EdgeInsets.symmetric(vertical: 18,),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(18),boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 8,offset: const Offset(0, 3),),],),child: Column(children: [

    CircleAvatar(
      radius: 22,
      backgroundColor: color.withOpacity(.12),
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
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(height: 5),

    Text(
      title,
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 13,
      ),
    ),
  ],
),

);}