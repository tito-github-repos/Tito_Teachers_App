import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/student_subject_model.dart';
import 'package:tito_teachers_app/repositories/topic_prograss_repo.dart';

import '../models/topic_progress_model.dart';

class TopicProgressController extends GetxController {
  static TopicProgressController get instance => Get.find();

  final TopicProgressRepository _repository =
      TopicProgressRepository.instance;

  //==========================================================
  // Loading
  //==========================================================

  final RxBool isLoading = false.obs;

  //==========================================================
  // Progress List
  //==========================================================

  final RxList<TopicProgressModel> teacherHistory =
      <TopicProgressModel>[].obs;

  final RxList<TopicProgressModel> classHistory =
      <TopicProgressModel>[].obs;

  final Rxn<TopicProgressModel> selectedProgress =
      Rxn<TopicProgressModel>();

  StreamSubscription<List<TopicProgressModel>>?
      _teacherSubscription;
StreamSubscription<List<TopicProgressModel>>?
    _classSubscription;
  //==========================================================
  // Selection
  //==========================================================

  void selectProgress(TopicProgressModel model) {
    selectedProgress.value = model;
  }

  void clearSelection() {
    selectedProgress.value = null;
  }

  //==========================================================
  // Teacher History
  //==========================================================

  Future<void> loadTeacherHistory(
      String teacherId) async {
    try {
      isLoading.value = true;

      final data =
          await _repository.getTeacherHistory(
        teacherId,
      );

      teacherHistory.assignAll(data);
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
  // Class History
  //==========================================================

  Future<void> loadClassHistory(
      String classId) async {
    try {
      isLoading.value = true;

      final data =
          await _repository.getClassHistory(
        classId,
      );

      classHistory.assignAll(data);
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
  // Stream Teacher History
  //==========================================================

  void listenTeacherHistory(
      String teacherId) {
    _teacherSubscription?.cancel();

    _teacherSubscription = _repository
        .streamTeacherHistory(teacherId)
        .listen((event) {
      teacherHistory.assignAll(event);
    });
  }void listenClassHistory(String classId) {
  _classSubscription?.cancel();

  _classSubscription = _repository
      .streamClassHistory(classId)
      .listen((event) {
    classHistory.assignAll(event);
  });
}

  //==========================================================
  // Save Progress
  //==========================================================

  Future<void> completeTopic({
    required String teacherId,
    required String teacherName,
    required String classId,
    required String className,
    required String subjectId,
    required String subjectName,
    required String topicId,
    required String topicTitle,
    required int durationMinutes,
    String remarks = '',
  }) async {
    try {
      isLoading.value = true;

      final progress = TopicProgressModel(
        id: _repository.generateId(),
        teacherId: teacherId,
        teacherName: teacherName,
        classId: classId,
        className: className,
        subjectId: subjectId,
        subjectName: subjectName,
        topicId: topicId,
        topicTitle: topicTitle,
        durationMinutes: durationMinutes,
        remarks: remarks,
        completedAt: Timestamp.now(),
      );

      await _repository.saveProgress(progress);

      Get.snackbar(
        "Success",
        "Topic marked as completed",
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
  // Update Progress
  //==========================================================

  Future<void> updateProgress(
      TopicProgressModel model) async {
    try {
      isLoading.value = true;

      await _repository.updateProgress(model);

      Get.snackbar(
        "Success",
        "Progress Updated",
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
  // Delete Progress
  //==========================================================

  Future<void> deleteProgress(
      String progressId) async {
    try {
      isLoading.value = true;

      await _repository.deleteProgress(progressId);

      Get.snackbar(
        "Success",
        "Progress Deleted",
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

  Future<List<StudentSubjectItem>> getStudentSubjects({
  required String classId,
}) async {
  final firestore = FirebaseFirestore.instance;

  // Get all teachers
  final teacherSnapshot = await firestore
      .collection("users")
      .where("role", isEqualTo: "teacher")
      .get();

  // Get all topic progress for this class
  final progressSnapshot = await firestore
      .collection("topic_progress")
      .where("classId", isEqualTo: classId)
      .get();

  // Unique subjects from teacher assignments
  final Map<String, String> subjects = {};

  for (final teacher in teacherSnapshot.docs) {
    final data = teacher.data();

    final assignments =
        (data["teachingAssignments"] as List<dynamic>? ?? []);

    for (final item in assignments) {
      final assignment =
          Map<String, dynamic>.from(item);

      if (assignment["classId"] == classId) {
        subjects[assignment["subjectId"]] =
            assignment["subjectName"];
      }
    }
  }

  // Count completed topics
  final Map<String, int> counts = {};

  for (final doc in progressSnapshot.docs) {
    final data = doc.data();

    final subjectId = data["subjectId"];

    counts[subjectId] =
        (counts[subjectId] ?? 0) + 1;
  }

  // Build list
  return subjects.entries.map((e) {
    return StudentSubjectItem(
      subjectId: e.key,
      subjectName: e.value,
      completedTopics: counts[e.key] ?? 0,
    );
  }).toList();
}

  //==========================================================
  // Helpers
  //==========================================================

  void clearHistory() {
    teacherHistory.clear();
    classHistory.clear();
    selectedProgress.value = null;
  }

  //==========================================================
  // Dispose
  //==========================================================

  @override
void onClose() {
  _teacherSubscription?.cancel();
  _classSubscription?.cancel();
  super.onClose();
}
}