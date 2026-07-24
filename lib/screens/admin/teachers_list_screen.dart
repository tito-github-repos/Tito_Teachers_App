import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/teachers_controller.dart';

import '../../models/user_model.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() =>
      _TeacherListScreenState();
}

class _TeacherListScreenState
    extends State<TeacherListScreen> {
 final TeacherController controller =
    Get.find<TeacherController>();

  final TextEditingController searchController =
      TextEditingController();

  final RxList<UserModel> filteredTeachers =
      <UserModel>[].obs;

@override
void initState() {
  super.initState();

  controller.loadTeachers();

  ever<List<UserModel>>(
    controller.teachers,
    (teachers) {
      filteredTeachers.assignAll(teachers);
    },
  );
}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _searchTeachers(String keyword) {
    if (keyword.trim().isEmpty) {
      filteredTeachers.assignAll(controller.teachers);
      return;
    }

    filteredTeachers.assignAll(
      controller.teachers.where((teacher) {
        return teacher.name
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            teacher.email
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            teacher.phone
                .toLowerCase()
                .contains(keyword.toLowerCase());
      }).toList(),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xffF5F7FA),

    appBar: AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      title: const Text(
        "Teachers",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadTeachers,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                /// Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
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
                        color: Colors.indigo
                            .withOpacity(.25),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      const CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            Colors.white,
                        child: Icon(
                          Icons.people,
                          size: 36,
                          color: Colors.indigo,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            const Text(
                              "Teacher Management",
                              style: TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Obx(
                              () => Text(
                                "${filteredTeachers.length} Teachers",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Manage teachers and their teaching assignments.",
                              style: TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Search Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.shade300,
                        blurRadius: 8,
                        offset:
                            const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller:
                        searchController,
                    onChanged:
                        _searchTeachers,
                    decoration:
                        InputDecoration(
                      hintText:
                          "Search teachers...",
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon:
                          searchController
                                  .text
                                  .isNotEmpty
                              ? IconButton(
                                  icon:
                                      const Icon(
                                    Icons.clear,
                                  ),
                                  onPressed: () {
                                    searchController
                                        .clear();
                                    _searchTeachers(
                                        "");
                                    setState(
                                        () {});
                                  },
                                )
                              : null,
                      border:
                          InputBorder.none,
                      contentPadding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "Teachers",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 16),

                Obx(() {

                  if (filteredTeachers
                      .isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount:
                        filteredTeachers.length,
                    separatorBuilder:
                        (_, __) =>
                            const SizedBox(
                      height: 16,
                    ),
                    itemBuilder:
                        (context, index) {
                      return _buildTeacherCard(
                        filteredTeachers[
                            index],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }),
  );
}

Widget _buildTeacherCard(UserModel teacher) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [

        /// Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff4F46E5),
                Color(0xff6366F1),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Text(
                  teacher.name.isNotEmpty
                      ? teacher.name[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      teacher.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      teacher.email,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Text(
                  "Active",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Row(
                children: [

                  const Icon(
                    Icons.phone,
                    color: Colors.indigo,
                    size: 20,
                  ),

                  const SizedBox(width: 10),

                  Text(
                    teacher.phone,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Teaching Assignments",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (teacher.teachingAssignments.isEmpty)

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "No Assignments Available",
                    textAlign: TextAlign.center,
                  ),
                )

              else

                Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: teacher
                        .teachingAssignments
                        .map(
                          (assignment) => Chip(
                            avatar: const Icon(
                              Icons.school,
                              size: 18,
                              color: Colors.white,
                            ),
                            backgroundColor:
                                Colors.indigo,
                            label: Text(
                              "${assignment.className} • ${assignment.subjectName}",
                              style:
                                  const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

              const SizedBox(height: 18),

              // Row(
              //   children: [

              //     Expanded(
              //       child: OutlinedButton.icon(
              //         onPressed: () {
              //           // View Details
              //         },
              //         icon: const Icon(
              //           Icons.visibility,
              //         ),
              //         label: const Text("View"),
              //       ),
              //     ),

              //     const SizedBox(width: 10),

              //     Expanded(
              //       child: ElevatedButton.icon(
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor:
              //               Colors.indigo,
              //           foregroundColor:
              //               Colors.white,
              //         ),
              //         onPressed: () {
              //           // Edit Teacher
              //         },
              //         icon: const Icon(
              //           Icons.edit,
              //         ),
              //         label: const Text("Edit"),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget _buildEmptyState() {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 30),
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [

        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.people_outline,
            size: 50,
            color: Colors.indigo,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "No Teachers Found",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "There are no teachers available.\nAdd a new teacher to get started.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Get.toNamed(AppRoutes.addTeacher);
          },
          icon: const Icon(Icons.person_add),
          label: const Text("Add Teacher"),
        ),
      ],
    ),
  );
}
    }