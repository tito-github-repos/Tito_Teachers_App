import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';
import 'package:tito_teachers_app/repositories/subject_repo.dart';


class SubjectController extends GetxController {
  static SubjectController get instance => Get.find();

  final SubjectRepository _repository = SubjectRepository.instance;

  //==========================================================
  // Loading
  //==========================================================

  final RxBool isLoading = false.obs;

  //==========================================================
  // Subjects
  //==========================================================

  final RxList<SubjectModel> subjects =
      <SubjectModel>[].obs;

  final RxList<SubjectModel> activeSubjects =
      <SubjectModel>[].obs;

  final RxList<SubjectModel> filteredSubjects =
      <SubjectModel>[].obs;

  final RxList<SubjectModel> selectedSubjects =
      <SubjectModel>[].obs;

  final Rxn<SubjectModel> selectedSubject =
      Rxn<SubjectModel>();

  StreamSubscription<List<SubjectModel>>? _subscription;

  //==========================================================
  // Init
  //==========================================================

  @override
  void onInit() {
    super.onInit();

    listenSubjects();
  }

  //==========================================================
  // Listen
  //==========================================================

  void listenSubjects() {
    _subscription?.cancel();

    _subscription =
        _repository.streamSubjects().listen((data) {
      subjects.assignAll(data);

      activeSubjects.assignAll(
        data.where((e) => e.isActive).toList(),
      );

      filteredSubjects.assignAll(activeSubjects);
    });
  }

  //==========================================================
  // Load
  //==========================================================

  Future<void> loadSubjects() async {
    try {
      isLoading.value = true;

      final data =
          await _repository.getAllSubjects();

      subjects.assignAll(data);

      activeSubjects.assignAll(
        data.where((e) => e.isActive).toList(),
      );

      filteredSubjects.assignAll(activeSubjects);
    } finally {
      isLoading.value = false;
    }
  }

  //==========================================================
  // CRUD
  //==========================================================

  Future<void> createSubject({
    required String name,
    required String code,
  }) async {
    try {
      isLoading.value = true;

      final model = SubjectModel(
        id: _repository.generateId(),
        name: name,
        code: code,
        isActive: true,
        createdAt: Timestamp.now(),
      );

      await _repository.createSubject(model);

      Get.snackbar(
        "Success",
        "Subject Created",
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

  Future<void> updateSubject(
      SubjectModel model) async {
    try {
      isLoading.value = true;

      await _repository.updateSubject(model);

      Get.snackbar(
        "Success",
        "Subject Updated",
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

  Future<void> deleteSubject(
      String subjectId) async {
    try {
      isLoading.value = true;

      await _repository.deleteSubject(subjectId);

      Get.snackbar(
        "Success",
        "Subject Deleted",
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

  Future<void> changeStatus({
    required String subjectId,
    required bool isActive,
  }) async {
    await _repository.updateSubjectStatus(
      subjectId: subjectId,
      isActive: isActive,
    );
  }

  //==========================================================
  // Selection
  //==========================================================

  void selectSubject(SubjectModel model) {
    selectedSubject.value = model;
  }

  void clearSelectedSubject() {
    selectedSubject.value = null;
  }

  //==========================================================
  // Multi Selection
  //==========================================================

  void toggleSubject(SubjectModel model) {
    if (selectedSubjects.any((e) => e.id == model.id)) {
      selectedSubjects.removeWhere(
        (e) => e.id == model.id,
      );
    } else {
      selectedSubjects.add(model);
    }
  }

  bool isSelected(String id) {
    return selectedSubjects.any(
      (e) => e.id == id,
    );
  }

  void clearSelections() {
    selectedSubjects.clear();
  }

  //==========================================================
  // Search
  //==========================================================

  void search(String keyword) {
    if (keyword.trim().isEmpty) {
      filteredSubjects.assignAll(activeSubjects);
      return;
    }

    filteredSubjects.assignAll(
      activeSubjects.where((e) {
        return e.name
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            e.code
                .toLowerCase()
                .contains(keyword.toLowerCase());
      }).toList(),
    );
  }

  //==========================================================
  // Helpers
  //==========================================================

  SubjectModel? getById(String id) {
    try {
      return subjects.firstWhere(
        (e) => e.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  bool exists(String id) {
    return subjects.any(
      (e) => e.id == id,
    );
  }

  //==========================================================
  // Dispose
  //==========================================================

  @override
  void onClose() {
    _subscription?.cancel();

    super.onClose();
  }
}