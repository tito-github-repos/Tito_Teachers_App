import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/constants/firebase_collections.dart';

import '../models/topic_model.dart';

class TopicRepository {
  TopicRepository._();

  static final TopicRepository instance = TopicRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _topicRef =>
      _firestore.collection(FirestoreCollections.topics);

  /// Create Topic
  Future<void> createTopic(TopicModel topic) async {
    try {
      await _topicRef.doc(topic.id).set(topic.toJson());
    } catch (e) {
      throw Exception("Failed to create topic: $e");
    }
  }

  /// Update Topic
  Future<void> updateTopic(TopicModel topic) async {
    try {
      await _topicRef.doc(topic.id).update(topic.toJson());
    } catch (e) {
      throw Exception("Failed to update topic: $e");
    }
  }

  /// Delete Topic
  Future<void> deleteTopic(String topicId) async {
    try {
      await _topicRef.doc(topicId).delete();
    } catch (e) {
      throw Exception("Failed to delete topic: $e");
    }
  }

  /// Get Topic
  Future<TopicModel?> getTopic(String topicId) async {
    try {
      final doc = await _topicRef.doc(topicId).get();

      if (!doc.exists) return null;

      return TopicModel.fromDocument(
        doc.id,
        doc.data()!,
      );
    } catch (e) {
      throw Exception("Failed to load topic: $e");
    }
  }

  /// Get All Topics
  Future<List<TopicModel>> getAllTopics() async {
    try {
      final snapshot = await _topicRef
          .orderBy('order')
          .get();

      return snapshot.docs
          .map(
            (e) => TopicModel.fromDocument(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load topics: $e");
    }
  }

  /// Topics by Class
  Future<List<TopicModel>> getTopicsByClass(
      String classId) async {
    try {
      final snapshot = await _topicRef
          .where('classId', isEqualTo: classId)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map(
            (e) => TopicModel.fromDocument(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load class topics: $e");
    }
  }

  /// Topics by Subject
  Future<List<TopicModel>> getTopicsBySubject(
      String subjectId) async {
    try {
      final snapshot = await _topicRef
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map(
            (e) => TopicModel.fromDocument(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load subject topics: $e");
    }
  }

  /// Topics by Class + Subject
  Future<List<TopicModel>> getTopics({
    required String classId,
    required String subjectId,
  }) async {
    try {
      final snapshot = await _topicRef
          .where('classId', isEqualTo: classId)
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map(
            (e) => TopicModel.fromDocument(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load topics: $e");
    }
  }

  /// Stream Topics
  Stream<List<TopicModel>> streamTopics({
    required String classId,
    required String subjectId,
  }) {
    return _topicRef
        .where('classId', isEqualTo: classId)
        .where('subjectId', isEqualTo: subjectId)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) => TopicModel.fromDocument(
                  e.id,
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  /// Enable / Disable Topic
  Future<void> updateTopicStatus({
    required String topicId,
    required bool isActive,
  }) async {
    try {
      await _topicRef.doc(topicId).update({
        'isActive': isActive,
      });
    } catch (e) {
      throw Exception("Failed to update topic status: $e");
    }
  }

  /// Generate Id
  String generateId() {
    return _topicRef.doc().id;
  }


  /// Stream All Topics
Stream<List<TopicModel>> streamAllTopics() {
  return _topicRef
      .orderBy('order')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => TopicModel.fromDocument(
                doc.id,
                doc.data(),
              ),
            )
            .toList(),
      );
}/// Stream Active Topics
Stream<List<TopicModel>> streamActiveTopics() {
  return _topicRef
      .where('isActive', isEqualTo: true)
      .orderBy('order')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => TopicModel.fromDocument(
                doc.id,
                doc.data(),
              ),
            )
            .toList(),
      );
}Stream<List<TopicModel>> streamTopicsByClassAndSubject({
  required String classId,
  required String subjectId,
}) {
  return _topicRef
      .where('classId', isEqualTo: classId)
      .where('subjectId', isEqualTo: subjectId)
      .where('isActive', isEqualTo: true)
      .orderBy('order')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => TopicModel.fromDocument(
                doc.id,
                doc.data(),
              ),
            )
            .toList(),
      );
}Future<List<TopicModel>> getActiveTopics({
  required String classId,
  required String subjectId,
}) async {
  try {
    final snapshot = await _topicRef
        .where('classId', isEqualTo: classId)
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
  } catch (e) {
    throw Exception("Failed to load active topics: $e");
  }
}Future<void> updateTopicOrder({
  required String topicId,
  required int order,
}) async {
  try {
    await _topicRef.doc(topicId).update({
      'order': order,
    });
  } catch (e) {
    throw Exception("Failed to update topic order: $e");
  }
}
}