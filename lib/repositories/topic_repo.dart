import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/models/topic_model.dart';

class TopicRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all active topics for a subject
  Future<List<TopicModel>> getTopicsBySubject(String subjectId) async {
    final snapshot = await _firestore
        .collection('topics')
        .where('subjectId', isEqualTo: subjectId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map(
          (doc) => TopicModel.fromDocument(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }

  /// Add Topic (Admin)
  Future<void> addTopic({
    required String subjectId,
    required String title,
    required int order,
  }) async {
    await _firestore.collection('topics').add({
      'subjectId': subjectId,
      'title': title,
      'order': order,
      'isActive': true,
      'createdAt': Timestamp.now(),
    });
  }

  /// Update Topic
  Future<void> updateTopic({
    required String topicId,
    required String title,
    required int order,
  }) async {
    await _firestore.collection('topics').doc(topicId).update({
      'title': title,
      'order': order,
    });
  }

  /// Soft Delete Topic
  Future<void> deleteTopic(String topicId) async {
    await _firestore.collection('topics').doc(topicId).update({
      'isActive': false,
    });
  }
}