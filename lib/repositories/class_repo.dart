import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/constants/firebase_collections.dart';

import '../models/class_model.dart';

class ClassRepository {
  ClassRepository._();

  static final ClassRepository instance = ClassRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _classRef =>
      _firestore.collection(FirestoreCollections.classes);

  /// Create Class
  Future<void> createClass(ClassModel classModel) async {
    try {
      await _classRef.doc(classModel.id).set(classModel.toJson());
    } catch (e) {
      throw Exception("Failed to create class: $e");
    }
  }

  /// Update Class
  Future<void> updateClass(ClassModel classModel) async {
    try {
      await _classRef.doc(classModel.id).update(classModel.toJson());
    } catch (e) {
      throw Exception("Failed to update class: $e");
    }
  }

  /// Delete Class
  Future<void> deleteClass(String classId) async {
    try {
      await _classRef.doc(classId).delete();
    } catch (e) {
      throw Exception("Failed to delete class: $e");
    }
  }

  /// Get Single Class
  Future<ClassModel?> getClassById(String classId) async {
    try {
      final doc = await _classRef.doc(classId).get();

      if (!doc.exists) return null;

      return ClassModel.fromDocument(
        doc.id,
        doc.data()!,
      );
    } catch (e) {
      throw Exception("Failed to get class: $e");
    }
  }

  /// Get All Classes
  Future<List<ClassModel>> getAllClasses() async {
    try {
      final snapshot = await _classRef
          .orderBy('order')
          .get();

      return snapshot.docs
          .map(
            (doc) => ClassModel.fromDocument(
              doc.id,
              doc.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load classes: $e");
    }
  }

  /// Get Active Classes
  Future<List<ClassModel>> getActiveClasses() async {
    try {
      final snapshot = await _classRef
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map(
            (doc) => ClassModel.fromDocument(
              doc.id,
              doc.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load active classes: $e");
    }
  }

  /// Stream All Classes
  Stream<List<ClassModel>> streamClasses() {
    return _classRef
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ClassModel.fromDocument(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  /// Stream Active Classes
  Stream<List<ClassModel>> streamActiveClasses() {
    return _classRef
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ClassModel.fromDocument(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  /// Change Active Status
  Future<void> updateClassStatus({
    required String classId,
    required bool isActive,
  }) async {
    try {
      await _classRef.doc(classId).update({
        'isActive': isActive,
      });
    } catch (e) {
      throw Exception("Failed to update class status: $e");
    }
  }

  /// Check Class Exists
  Future<bool> classExists(String classId) async {
    try {
      final doc = await _classRef.doc(classId).get();
      return doc.exists;
    } catch (e) {
      throw Exception("Failed to check class: $e");
    }
  }

  /// Generate Document ID
  String generateId() {
    return _classRef.doc().id;
  }
}