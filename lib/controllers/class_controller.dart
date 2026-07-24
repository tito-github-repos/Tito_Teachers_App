import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/repositories/class_repo.dart';

import '../models/class_model.dart';

class ClassController extends GetxController {
  static ClassController get instance => Get.find();

  final ClassRepository _repository = ClassRepository.instance;

  //==========================================================
  // Loading
  //==========================================================

  final RxBool isLoading = false.obs;

  //==========================================================
  // Class List
  //==========================================================

  final RxList<ClassModel> classes = <ClassModel>[].obs;

  final RxList<ClassModel> activeClasses =
      <ClassModel>[].obs;

  final Rxn<ClassModel> selectedClass =
      Rxn<ClassModel>();

  StreamSubscription<List<ClassModel>>? _classSubscription;

  //==========================================================
  // Init
  //==========================================================

  @override
  void onInit() {
    super.onInit();

    listenClasses();
  }

  //==========================================================
  // Listen
  //==========================================================

  void listenClasses() {
    _classSubscription?.cancel();

    _classSubscription =
        _repository.streamClasses().listen((data) {
      classes.assignAll(data);

      activeClasses.assignAll(
        data.where((e) => e.isActive).toList(),
      );
    });
  }

  //==========================================================
  // Load Once
  //==========================================================

  Future<void> loadClasses() async {
    try {
      isLoading.value = true;

      final data =
          await _repository.getAllClasses();

      classes.assignAll(data);

      activeClasses.assignAll(
        data.where((e) => e.isActive).toList(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //==========================================================
  // Selection
  //==========================================================

  void selectClass(ClassModel model) {
    selectedClass.value = model;
  }

  void clearSelection() {
    selectedClass.value = null;
  }

  //==========================================================
  // CRUD
  //==========================================================
Future<void> createClass({
  required String name,
  required int order,
  required List<String> subjectIds,
}) async {
  try {
    isLoading.value = true;

    final model = ClassModel(
      id: _repository.generateId(),
      name: name,
      order: order,
      subjectIds: subjectIds,
      isActive: true,
      createdAt: Timestamp.now(),
    );

    await _repository.createClass(model);

    Get.snackbar(
      "Success",
      "Class created successfully",
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
  Future<void> updateClass(
      ClassModel model) async {
    try {
      isLoading.value = true;

      await _repository.updateClass(model);

      Get.snackbar(
        "Success",
        "Class updated",
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

  Future<void> deleteClass(
      String classId) async {
    try {
      isLoading.value = true;

      await _repository.deleteClass(classId);

      Get.snackbar(
        "Success",
        "Class deleted",
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
    required String classId,
    required bool isActive,
  }) async {
    try {
      await _repository.updateClassStatus(
        classId: classId,
        isActive: isActive,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  //==========================================================
  // Helpers
  //==========================================================

  ClassModel? getById(String id) {
    try {
      return classes.firstWhere(
        (e) => e.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  bool exists(String id) {
    return classes.any(
      (e) => e.id == id,
    );
  }

  //==========================================================
  // Dispose
  //==========================================================

  @override
  void onClose() {
    _classSubscription?.cancel();

    super.onClose();
  }
}