import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/services/monthly_payment_generate.dart';

import '../models/user_model.dart';

class StudentPaymentRepository {
  StudentPaymentRepository._();

  static final StudentPaymentRepository instance =
      StudentPaymentRepository._();

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  /// ---------------------------------------------------------------------------
  /// GET ALL STUDENTS
  /// ---------------------------------------------------------------------------

  Future<List<UserModel>> getAllStudents() async {
    final snapshot = await _db
        .collection("users")
        .where("role", isEqualTo: "student")
        .get();

    return snapshot.docs
    .map((e) => UserModel.fromJson(e.data()))
    .toList();
  }

  /// ---------------------------------------------------------------------------
  /// BUILD MONTHLY INPUT
  /// ---------------------------------------------------------------------------

  Future<StudentMonthlyInput> buildStudentMonthlyInput(
    UserModel student,
  ) async {
    final teacherSnapshot = await _db
        .collection("users")
        .where("role", isEqualTo: "teacher")
        .get();

    final Map<String, String> subjects = {};

    for (final teacher in teacherSnapshot.docs) {
      final data = teacher.data();

      final assignments =
          (data["teachingAssignments"]
                  as List<dynamic>? ??
              []);

      for (final item in assignments) {
        final assignment =
            Map<String, dynamic>.from(item);

        if (assignment["classId"] ==
            student.classId) {
          subjects[assignment["subjectId"]] =
              assignment["subjectName"];
        }
      }
    }

    return StudentMonthlyInput(
      studentId: student.uid,
      studentName: student.name,
      subjectIds: subjects.keys.toList(),
      subjectNames: subjects,
    );
  }
}