import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/student_controller.dart';
import 'package:tito_teachers_app/models/class_model.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';
import 'package:tito_teachers_app/models/user_model.dart';
import 'package:tito_teachers_app/repositories/class_repo.dart';
import 'package:tito_teachers_app/repositories/subject_repo.dart';
import 'package:tito_teachers_app/screens/admin/widgets/teacher_selection_dialog.dart';


class AssignStudentDialog {
  static Future<void> show(
    BuildContext context,
    UserModel student,
  ) async {
    final controller = Get.find<StudentController>();

    final classRepo = ClassRepository.instance;
    final subjectRepo = SubjectRepository.instance;

    final classes = await classRepo.getActiveClasses();
    final subjects = await subjectRepo.getActiveSubjects();

    ClassModel? selectedClass;

    if (student.classId != null &&
        student.classId!.isNotEmpty) {
      try {
        selectedClass = classes.firstWhere(
          (e) => e.id == student.classId,
        );
      } catch (_) {}
    }

    final selectedSubjectIds =
        student.subjectIds.toSet();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {

            List<SubjectModel> filteredSubjects =
                [];

          filteredSubjects = subjects;

            return AlertDialog(
              title: Text(
                "Assign Class\n${student.name}",
              ),

              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [

                      DropdownButtonFormField<
                          ClassModel>(
                        value: selectedClass,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Select Class",
                          border:
                              OutlineInputBorder(),
                        ),
                        items: classes
                            .map((classModel) {
                          return DropdownMenuItem(
                            value: classModel,
                            child:
                                Text(classModel.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value;
                            selectedSubjectIds
                                .clear();
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                      if (selectedClass == null)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      "Please select a class first.",
      textAlign: TextAlign.center,
    ),
  )
else
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey.shade300,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        const Text(
          "Select Subjects",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 12),

        ...filteredSubjects.map(
          (subject) {
            final isSelected =
                selectedSubjectIds
                    .contains(subject.id);

            return CheckboxListTile(
              dense: true,
              value: isSelected,
              contentPadding:
                  EdgeInsets.zero,
              title: Text(subject.name),
              controlAffinity:
                  ListTileControlAffinity
                      .leading,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    selectedSubjectIds
                        .add(subject.id);
                  } else {
                    selectedSubjectIds
                        .remove(subject.id);
                  }
                });
              },
            );
          },
        ),
      ],
    ),
  ),

const SizedBox(height: 24),

Row(
  children: [

    Expanded(
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Cancel"),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.indigo,
            foregroundColor:
                Colors.white,
          ),
          onPressed:
              controller.isSaving.value
                  ? null
                  : () async {

                      if (selectedClass ==
                          null) {
                        Get.snackbar(
                          "Required",
                          "Please select a class.",
                        );
                        return;
                      }

                 final teacherAssignments =
    await TeacherSelectionDialog.show(
  context: context,
  classId: selectedClass!.id,
  subjectIds: selectedSubjectIds.toList(),
);

if (teacherAssignments == null) {
  return;
}

await controller.saveStudentAssignment(
  studentId: student.uid,
  classId: selectedClass!.id,
  className: selectedClass!.name,
  subjectIds: selectedSubjectIds.toList(),
  teacherAssignments: teacherAssignments,
);

if (context.mounted) {
  Navigator.pop(context);
}

                      if (context.mounted) {
                        Navigator.pop(
                            context);
                      }
                    },
          child:
              controller.isSaving.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                            Colors.white,
                      ),
                    )
                  : const Text("Next"),
        ),
      ),
    ),
  ],
),
      ],
    ),
  ),
),
            );
          },
        );
      },
    );
  }
}