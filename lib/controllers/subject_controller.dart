import 'package:get/get.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';

import '../repositories/subject_repository.dart';

class SubjectController extends GetxController {
  final SubjectRepository repository = SubjectRepository();

  final subjects = <SubjectModel>[].obs;

  final selectedSubjectIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    subjects.value = await repository.getSubjects();
  }

  void toggleSubject(String id) {
    if (selectedSubjectIds.contains(id)) {
      selectedSubjectIds.remove(id);
    } else {
      selectedSubjectIds.add(id);
    }
  }
}