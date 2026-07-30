import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/screens/admin/widgets/student_card.dart';

import '../../controllers/student_controller.dart';
import '../../models/user_model.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState
    extends State<StudentListScreen> {
  final StudentController controller =
      Get.put(StudentController());

  final TextEditingController searchController =
      TextEditingController();

  final RxList<UserModel> filteredStudents =
      <UserModel>[].obs;

  @override
  void initState() {
    super.initState();

    ever<List<UserModel>>(
      controller.students,
      (students) {
        filteredStudents.assignAll(students);
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _searchStudents(String keyword) {
    if (keyword.trim().isEmpty) {
      filteredStudents.assignAll(controller.students);
      return;
    }

    filteredStudents.assignAll(
      controller.students.where((student) {
        return student.name
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            student.email
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            student.phone
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            (student.className ?? "")
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
        "Students",
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
        onRefresh: controller.loadStudents,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
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
                        Color(0xff10B981),
                        Color(0xff34D399),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green
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
                          Icons.school,
                          color: Colors.green,
                          size: 36,
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
                              "Student Management",
                              style: TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Obx(
                              () => Text(
                                "${filteredStudents.length} Students",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Manage student accounts and class details.",
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
                        _searchStudents,
                    decoration:
                        InputDecoration(
                      hintText:
                          "Search students...",
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
                                    _searchStudents(
                                        "");
                                    FocusScope.of(
                                            context)
                                        .unfocus();
                                    setState(() {});
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
                  "Students",
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

                  if (filteredStudents
                      .isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount:
                        filteredStudents.length,
                    separatorBuilder:
                        (_, __) =>
                            const SizedBox(
                      height: 16,
                    ),
                    itemBuilder:
                        (context, index) {

                    return StudentCard(
  student: filteredStudents[index],
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
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.school_outlined,
            color: Colors.green,
            size: 50,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "No Students Found",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "There are no students available.\nAdd a new student to get started.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
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
            // Get.toNamed(AppRoutes.addStudent);
          },
          icon: const Icon(Icons.person_add),
          label: const Text("Add Student"),
        ),
      ],
    ),
  );
}}