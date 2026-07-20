import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';


class SubjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SubjectModel>> getSubjects() async {
    final snapshot = await _firestore
        .collection('subjects')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => SubjectModel.fromDocument(
              doc.id,
              doc.data(),
            ))
        .toList();
  }
}