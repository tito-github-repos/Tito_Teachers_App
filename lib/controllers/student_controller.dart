import 'package:get/get.dart';

import '../models/user_model.dart';
import '../repositories/student_repo.dart';

class StudentController extends GetxController {
  final StudentRepository _repository = StudentRepository();

  final RxBool isLoading = false.obs;
  final RxList<UserModel> students = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      isLoading.value = true;
      final data = await _repository.getStudents();
      students.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}