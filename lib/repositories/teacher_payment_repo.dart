import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/services/monthly_payment_generate.dart';


class TeacherPaymentRepository {
  TeacherPaymentRepository._();

  static final TeacherPaymentRepository instance =
      TeacherPaymentRepository._();

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  Future<List<TeacherMonthlyInput>> getTeacherMonthlyInputs({
    required int month,
    required int year,
  }) async {

    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final snapshot = await _db
        .collection("topic_progress")
        .where(
          "completedAt",
          isGreaterThanOrEqualTo: Timestamp.fromDate(start),
        )
        .where(
          "completedAt",
          isLessThan: Timestamp.fromDate(end),
        )
        .get();

    final Map<String, TeacherMonthlyInput> teachers = {};

    for (final doc in snapshot.docs) {

      final data = doc.data();

      final teacherId = data["teacherId"] as String;
      final teacherName = data["teacherName"] as String;

      final subjectId = data["subjectId"] as String;
      final subjectName = data["subjectName"] as String;

      final minutes =
          (data["durationMinutes"] ?? 0) as int;

      if (!teachers.containsKey(teacherId)) {

        teachers[teacherId] = TeacherMonthlyInput(
          teacherId: teacherId,
          teacherName: teacherName,
          subjectMinutes: {},
          subjectNames: {},
        );
      }

      final teacher = teachers[teacherId]!;

      teacher.subjectMinutes[subjectId] =
          (teacher.subjectMinutes[subjectId] ?? 0) +
              minutes;

      teacher.subjectNames[subjectId] =
          subjectName;
    }

    return teachers.values.toList();
  }
}