import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/assignment_summary_model.dart';

import '../models/user_model.dart';

class TeacherAssignmentController extends GetxController {
  static TeacherAssignmentController get instance =>
      Get.find<TeacherAssignmentController>();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;

 final RxMap<String, List<TeacherAssignmentSummary>>
    teachersBySubject =
    <String, List<TeacherAssignmentSummary>>{}.obs;
  Future<void> loadTeachers({
    required String classId,
    required String subjectId,
  }) async {
    try {
      isLoading.value = true;
teachersBySubject.remove(subjectId);
      //--------------------------------------------------
      // 1. Get all teachers
      //--------------------------------------------------

      final teacherSnapshot = await _firestore
          .collection("users")
          .where("role", isEqualTo: "teacher")
          .get();

      //--------------------------------------------------
      // 2. Total Topics
      //--------------------------------------------------

      final totalTopicsSnapshot = await _firestore
          .collection("topics")
          .where("classId", isEqualTo: classId)
          .where("subjectId", isEqualTo: subjectId)
          .get();

      final totalTopics =
          totalTopicsSnapshot.docs.length;

      //--------------------------------------------------
      // 3. Build Summary
      //--------------------------------------------------

      List<TeacherAssignmentSummary> result = [];

      for (final teacherDoc in teacherSnapshot.docs) {
        final teacher = UserModel.fromDocument(
          teacherDoc,
        );

        //------------------------------------------------
        // Check teacher teaches this class & subject
        //------------------------------------------------

        final teachesSubject = teacher
            .teachingAssignments
            .any((e) =>
                e.classId == classId &&
                e.subjectId == subjectId);

        if (!teachesSubject) {
          continue;
        }

        //----------------------------------------------
        // Completed Topics
        //----------------------------------------------

        final completedSnapshot =
            await _firestore
                .collection("topic_progress")
                .where(
                  "teacherId",
                  isEqualTo: teacher.uid,
                )
                .where(
                  "classId",
                  isEqualTo: classId,
                )
                .where(
                  "subjectId",
                  isEqualTo: subjectId,
                )
                .get();

        //----------------------------------------------
        // Last Topic
        //----------------------------------------------

        String? lastTopic;
        Timestamp? lastCompleted;

        if (completedSnapshot.docs.isNotEmpty) {
          final last =
              completedSnapshot.docs.last.data();

          lastTopic = last["topicName"];

          lastCompleted =
              last["completedAt"];
        }

        //----------------------------------------------
        // Assigned Students
        //----------------------------------------------

        final studentSnapshot =
            await _firestore
                .collection("users")
                .where(
                  "role",
                  isEqualTo: "student",
                )
                .get();

        int assignedStudents = 0;

        for (final student
            in studentSnapshot.docs) {
          final data = student.data();

          final assignments =
              List<Map<String, dynamic>>.from(
            data["assignedTeachers"] ?? [],
          );

          final assigned = assignments.any(
            (e) =>
                e["teacherId"] ==
                    teacher.uid &&
                e["subjectId"] ==
                    subjectId,
          );

          if (assigned) {
            assignedStudents++;
          }
        }

        //----------------------------------------------
        // Add Summary
        //----------------------------------------------

        result.add(
          TeacherAssignmentSummary(
            teacherId: teacher.uid,
            teacherName: teacher.name,
            classId: classId,
            subjectId: subjectId,
            totalTopics: totalTopics,
            completedTopics:
                completedSnapshot.docs.length,
            assignedStudents:
                assignedStudents,
            lastCompletedTopic:
                lastTopic,
            lastCompletedAt:
                lastCompleted,
          ),
        );
      }

      //--------------------------------------------------
      // Sort
      //--------------------------------------------------

      result.sort((a, b) {
        final compare =
            a.completedTopics.compareTo(
          b.completedTopics,
        );

        if (compare != 0) {
          return compare;
        }

        return a.assignedStudents.compareTo(
          b.assignedStudents,
        );
      });

teachersBySubject[subjectId] = result;    } finally {
      isLoading.value = false;
    }
  }
  List<TeacherAssignmentSummary> getTeachers(
  String subjectId,
) {
  return teachersBySubject[subjectId] ?? [];


}
Future<void> loadAllTeachers({
  required String classId,
  required List<String> subjectIds,
}) async {
  teachersBySubject.clear();

  for (final subjectId in subjectIds) {
    await loadTeachers(
      classId: classId,
      subjectId: subjectId,
    );
  }
}
}