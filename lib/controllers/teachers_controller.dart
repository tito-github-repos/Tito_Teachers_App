import 'package:get/get.dart';
import 'package:tito_teachers_app/repositories/teachers_repository.dart';

import '../models/user_model.dart';

class TeacherController extends GetxController {
  final TeacherRepository _repository = TeacherRepository();

  final RxBool isLoading = false.obs;
  final RxList<UserModel> teachers = <UserModel>[].obs;

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
  
}