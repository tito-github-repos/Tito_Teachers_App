import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/constants/firebase_collections.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';

class SubjectRepository {
  SubjectRepository._();

  static final SubjectRepository instance = SubjectRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _subjectRef =>
      _firestore.collection(FirestoreCollections.subjects);

  /// Create Subject
  Future<void> createSubject(SubjectModel subject) async {
    try {
      await _subjectRef.doc(subject.id).set(subject.toJson());
    } catch (e) {
      throw Exception("Failed to create subject: $e");
    }
  }

  /// Update Subject
  Future<void> updateSubject(SubjectModel subject) async {
    try {
      await _subjectRef.doc(subject.id).update(subject.toJson());
    } catch (e) {
      throw Exception("Failed to update subject: $e");
    }
  }

  /// Delete Subject
  Future<void> deleteSubject(String subjectId) async {
    try {
      await _subjectRef.doc(subjectId).delete();
    } catch (e) {
      throw Exception("Failed to delete subject: $e");
    }
  }

  /// Get Subject By Id
  Future<SubjectModel?> getSubjectById(String subjectId) async {
    try {
      final doc = await _subjectRef.doc(subjectId).get();

      if (!doc.exists) return null;

      return SubjectModel.fromDocument(
        doc.id,
        doc.data()!,
      );
    } catch (e) {
      throw Exception("Failed to load subject: $e");
    }
  }

  /// Get All Subjects
  Future<List<SubjectModel>> getAllSubjects() async {
    try {
      final snapshot = await _subjectRef
          .orderBy('name')
          .get();

      return snapshot.docs
          .map(
            (doc) => SubjectModel.fromDocument(
              doc.id,
              doc.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load subjects: $e");
    }
  }

  /// Get Active Subjects
  Future<List<SubjectModel>> getActiveSubjects() async {
    try {
      final snapshot = await _subjectRef
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map(
            (doc) => SubjectModel.fromDocument(
              doc.id,
              doc.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load active subjects: $e");
    }
  }

  /// Stream All Subjects
  Stream<List<SubjectModel>> streamSubjects() {
    return _subjectRef
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SubjectModel.fromDocument(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  /// Stream Active Subjects
  Stream<List<SubjectModel>> streamActiveSubjects() {
    return _subjectRef
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SubjectModel.fromDocument(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  /// Search Subjects
  Future<List<SubjectModel>> searchSubjects(String keyword) async {
    try {
      final subjects = await getAllSubjects();

      return subjects.where((subject) {
        return subject.name
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            subject.code
                .toLowerCase()
                .contains(keyword.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception("Failed to search subjects: $e");
    }
  }

  /// Enable / Disable Subject
  Future<void> updateSubjectStatus({
    required String subjectId,
    required bool isActive,
  }) async {
    try {
      await _subjectRef.doc(subjectId).update({
        'isActive': isActive,
      });
    } catch (e) {
      throw Exception("Failed to update subject status: $e");
    }
  }

  /// Check Subject Exists
  Future<bool> subjectExists(String subjectId) async {
    try {
      final doc = await _subjectRef.doc(subjectId).get();
      return doc.exists;
    } catch (e) {
      throw Exception("Failed to check subject: $e");
    }
  }

  /// Generate Document Id
  String generateId() {
    return _subjectRef.doc().id;
  }
}