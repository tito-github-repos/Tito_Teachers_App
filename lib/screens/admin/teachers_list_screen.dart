import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/teachers_controller.dart';
import 'package:tito_teachers_app/models/class_model.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';
import 'package:tito_teachers_app/repositories/class_repo.dart';
import 'package:tito_teachers_app/repositories/subject_repo.dart';
import 'package:tito_teachers_app/screens/admin/widgets/teacher_card.dart';

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
final ClassRepository _classRepository =
    ClassRepository.instance;

final SubjectRepository _subjectRepository =
    SubjectRepository.instance;

List<ClassModel> _classes = [];

List<SubjectModel> _subjects = [];

bool _isLoadingAssignments = false;
@override
void initState() {
  super.initState();

  controller.loadTeachers();
  _loadAssignmentData();

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

  Future<void> _loadAssignmentData() async {
  try {
    setState(() {
      _isLoadingAssignments = true;
    });

    _classes =
        await _classRepository.getActiveClasses();

    _subjects =
        await _subjectRepository.getActiveSubjects();
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoadingAssignments = false;
      });
    }
  }
}

List<SubjectModel> _getSubjectsForClass(
    String classId) {
  final classModel = _classes.firstWhere(
    (e) => e.id == classId,
    orElse: () => ClassModel(
      id: '',
      name: '',
      order: 0,
      isActive: true,
      createdAt: Timestamp.now(),
      subjectIds: [],
    ),
  );

  return _subjects
      .where(
        (subject) => classModel.subjectIds
            .contains(subject.id),
      )
      .toList();
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
                     return TeacherCard(
  teacher: filteredTeachers[index],
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