import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/repositories/topic_repo.dart';

import '../models/topic_model.dart';

class TopicController extends GetxController {
  static TopicController get instance => Get.find();

  final TopicRepository _repository = TopicRepository.instance;

  //==========================================================
  // Loading
  //==========================================================

  final RxBool isLoading = false.obs;

  //==========================================================
  // Topic Lists
  //==========================================================

  final RxList<TopicModel> topics = <TopicModel>[].obs;

  final RxList<TopicModel> activeTopics = <TopicModel>[].obs;

  final Rxn<TopicModel> selectedTopic = Rxn<TopicModel>();

  //==========================================================
  // Selected Filters
  //==========================================================

  final RxString selectedClassId = ''.obs;
  final RxString selectedSubjectId = ''.obs;

  StreamSubscription<List<TopicModel>>? _subscription;

  //==========================================================
  // Init
  //==========================================================

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  //==========================================================
  // Selection
  //==========================================================

  void setClass(String classId) {
    selectedClassId.value = classId;
  }

  void setSubject(String subjectId) {
    selectedSubjectId.value = subjectId;
  }

  void selectTopic(TopicModel topic) {
    selectedTopic.value = topic;
  }

  void clearSelectedTopic() {
    selectedTopic.value = null;
  }

  //==========================================================
  // Listen Topics
  //==========================================================

  void listenTopics({
    required String classId,
    required String subjectId,
  }) {
    _subscription?.cancel();

    selectedClassId.value = classId;
    selectedSubjectId.value = subjectId;

    _subscription = _repository
        .streamTopicsByClassAndSubject(
          classId: classId,
          subjectId: subjectId,
        )
        .listen((data) {
      activeTopics.assignAll(data);
      topics.assignAll(data);
    });
  }

  //==========================================================
  // Load Topics
  //==========================================================

  Future<void> loadTopics({
    required String classId,
    required String subjectId,
  }) async {
    try {
      isLoading.value = true;

      final data = await _repository.getTopics(
        classId: classId,
        subjectId: subjectId,
      );

      topics.assignAll(data);

      activeTopics.assignAll(
        data.where((e) => e.isActive).toList(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //==========================================================
  // Create Topic
  //==========================================================

  Future<void> createTopic({
    required String classId,
    required String className,
    required String subjectId,
    required String subjectName,
    required String title,
    required String description,
    required int order,
    required int estimatedDuration,
  }) async {
    try {
      isLoading.value = true;

      final topic = TopicModel(
        id: _repository.generateId(),
        classId: classId,
        className: className,
        subjectId: subjectId,
        subjectName: subjectName,
        title: title,
        description: description,
        order: order,
        estimatedDuration: estimatedDuration,
        isActive: true,
        createdAt: Timestamp.now(),
      );

      await _repository.createTopic(topic);

      Get.snackbar(
        "Success",
        "Topic Created",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //==========================================================
  // Update
  //==========================================================

  Future<void> updateTopic(
    TopicModel topic,
  ) async {
    try {
      isLoading.value = true;

      await _repository.updateTopic(topic);

      Get.snackbar(
        "Success",
        "Topic Updated",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //==========================================================
  // Delete
  //==========================================================

  Future<void> deleteTopic(
    String topicId,
  ) async {
    try {
      isLoading.value = true;

      await _repository.deleteTopic(topicId);

      Get.snackbar(
        "Success",
        "Topic Deleted",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //==========================================================
  // Enable / Disable
  //==========================================================

  Future<void> changeStatus({
    required String topicId,
    required bool isActive,
  }) async {
    await _repository.updateTopicStatus(
      topicId: topicId,
      isActive: isActive,
    );
  }

  //==========================================================
  // Change Order
  //==========================================================

  Future<void> changeOrder({
    required String topicId,
    required int order,
  }) async {
    await _repository.updateTopicOrder(
      topicId: topicId,
      order: order,
    );
  }

  //==========================================================
  // Helpers
  //==========================================================

  TopicModel? getById(String id) {
    try {
      return topics.firstWhere(
        (e) => e.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  bool exists(String id) {
    return topics.any(
      (e) => e.id == id,
    );
  }

  void clear() {
    topics.clear();
    activeTopics.clear();
    selectedTopic.value = null;
  }
}