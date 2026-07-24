import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/constants/firebase_collections.dart';

import '../models/topic_progress_model.dart';

class TopicProgressRepository {
  TopicProgressRepository._();

  static final TopicProgressRepository instance =
      TopicProgressRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _progressRef =>
          _firestore.collection(
            FirestoreCollections.topicProgress,
          );

  /// Save Progress
  Future<void> saveProgress(
      TopicProgressModel progress) async {
    try {
      await _progressRef
          .doc(progress.id)
          .set(progress.toJson());
    } catch (e) {
      throw Exception("Failed to save progress: $e");
    }
  }

  /// Update Progress
  Future<void> updateProgress(
      TopicProgressModel progress) async {
    try {
      await _progressRef
          .doc(progress.id)
          .update(progress.toJson());
    } catch (e) {
      throw Exception("Failed to update progress: $e");
    }
  }

  /// Delete Progress
  Future<void> deleteProgress(String id) async {
    try {
      await _progressRef.doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete progress: $e");
    }
  }

  /// Teacher History
  Future<List<TopicProgressModel>>
      getTeacherHistory(String teacherId) async {
    try {
      final snapshot = await _progressRef
          .where('teacherId', isEqualTo: teacherId)
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (e) => TopicProgressModel.fromDocument(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load history: $e");
    }
  }

  /// Class History
  Future<List<TopicProgressModel>>
      getClassHistory(String classId) async {
    try {
      final snapshot = await _progressRef
          .where('classId', isEqualTo: classId)
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (e) => TopicProgressModel.fromDocument(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load class history: $e");
    }
  }

  /// Stream Teacher History
  Stream<List<TopicProgressModel>>
      streamTeacherHistory(String teacherId) {
    return _progressRef
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) => TopicProgressModel.fromDocument(
                  e.id,
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  String generateId() {
    return _progressRef.doc().id;
  }
  /// Stream Class History
Stream<List<TopicProgressModel>> streamClassHistory(
    String classId) {
  return _progressRef
      .where('classId', isEqualTo: classId)
      .orderBy('completedAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (e) => TopicProgressModel.fromDocument(
                e.id,
                e.data(),
              ),
            )
            .toList(),
      );
}
}