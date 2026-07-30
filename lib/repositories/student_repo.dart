import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getStudents() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }
  Future<void> saveStudentAssignment({
  required String studentId,
  required String classId,
  required String className,
  required List<String> subjectIds,
   required Map<String,String> teacherAssignments,

}) async {
  await _firestore
      .collection("users")
      .doc(studentId)
      .update({
    "classId": classId,
    "className": className,
    "subjectIds": subjectIds,
    "assignedTeachers": teacherAssignments.entries
    .map(
      (e) => {
        "subjectId": e.key,
        "teacherId": e.value,
      },
    )
    .toList(),
  });
}
}