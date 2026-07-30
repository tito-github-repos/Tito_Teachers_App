import 'package:get/get.dart';

import '../models/user_model.dart';
import '../repositories/student_repo.dart';

class StudentController extends GetxController {
  final StudentRepository _repository = StudentRepository();

  final RxBool isLoading = false.obs;
  final RxList<UserModel> students = <UserModel>[].obs;
final RxBool isSaving = false.obs;
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
  
  Future<void> saveStudentAssignment({
  required String studentId,
  required String classId,
  required String className,
  required List<String> subjectIds,
   required Map<String,String> teacherAssignments,

}) async {
  try {
    isSaving.value = true;

    await _repository
        .saveStudentAssignment(
      studentId: studentId,
      classId: classId,
      className: className,
      subjectIds: subjectIds,
      teacherAssignments: teacherAssignments
    );

    await loadStudents();

    Get.snackbar(
      "Success",
      "Student assignment updated successfully.",
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