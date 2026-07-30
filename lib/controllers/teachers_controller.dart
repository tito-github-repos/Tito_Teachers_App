import 'package:get/get.dart';
import 'package:tito_teachers_app/models/teacher_assisgnment_model.dart';
import 'package:tito_teachers_app/repositories/teachers_repo.dart';

import '../models/user_model.dart';

class TeacherController extends GetxController {
  final TeacherRepository _repository = TeacherRepository();

  final RxBool isLoading = false.obs;
  final RxList<UserModel> teachers = <UserModel>[].obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeachers();
  }

  Future<void> loadTeachers() async {
    try {
      isLoading.value = true;

      final data = await _repository.getTeachers();

      teachers.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

   Future<void> saveTeacherAssignments({
    required String teacherId,
    required List<TeachingAssignmentModel> assignments,
  }) async {
    try {
      isSaving.value = true;

      await _repository.saveTeacherAssignments(
        teacherId: teacherId,
        assignments: assignments,
      );

      await loadTeachers();

      Get.snackbar(
        "Success",
        "Teacher assignments updated successfully.",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isSaving.value = false;
    }
  }
  
}