import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class TeacherRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getTeachers() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .orderBy('name')
        .get();

    return snapshot.docs
        .map((e) => UserModel.fromJson(e.data()))
        .toList();
  }
  
}