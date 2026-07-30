import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/teachers_controller.dart';
import 'package:tito_teachers_app/models/class_model.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';
import 'package:tito_teachers_app/models/teacher_assisgnment_model.dart';
import 'package:tito_teachers_app/models/user_model.dart';
import 'package:tito_teachers_app/repositories/class_repo.dart';
import 'package:tito_teachers_app/repositories/subject_repo.dart';


class AssignTeacherDialog {

  static Future<void> show(
    BuildContext context,
    UserModel teacher,
  ) async {

    final controller = Get.find<TeacherController>();

    final classRepo = ClassRepository.instance;

    final subjectRepo = SubjectRepository.instance;

    final classes =
        await classRepo.getActiveClasses();

    final subjects =
        await subjectRepo.getActiveSubjects();

    final assignments =
        List<TeachingAssignmentModel>.from(
      teacher.teachingAssignments,
    );

    ClassModel? selectedClass;

    SubjectModel? selectedSubject;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
List<SubjectModel> filteredSubjects = [];

if (selectedClass != null) {
  filteredSubjects = subjects;
}
            return AlertDialog(

  title: Text(
    "Assign Subjects\n${teacher.name}",
  ),

  content: SizedBox(
    width: 450,

    child: SingleChildScrollView(

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          DropdownButtonFormField<ClassModel>(
  value: selectedClass,
  decoration: const InputDecoration(
    labelText: "Select Class",
    border: OutlineInputBorder(),
  ),
  items: classes.map((classModel) {
    return DropdownMenuItem(
      value: classModel,
      child: Text(classModel.name),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedClass = value;
      selectedSubject = null;
    });
  },
),

const SizedBox(height: 16),

DropdownButtonFormField<SubjectModel>(
  value: selectedSubject,
  decoration: const InputDecoration(
    labelText: "Select Subject",
    border: OutlineInputBorder(),
  ),
  items: filteredSubjects.map((subject) {
    return DropdownMenuItem(
      value: subject,
      child: Text(subject.name),
    );
  }).toList(),
  onChanged: selectedClass == null
      ? null
      : (value) {
          setState(() {
            selectedSubject = value;
          });
        },
),

const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.add),
    label: const Text("Add Assignment"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    onPressed: () {
      if (selectedClass == null ||
          selectedSubject == null) {
        Get.snackbar(
          "Required",
          "Please select class and subject.",
        );
        return;
      }

      final alreadyExists = assignments.any(
        (e) =>
            e.classId == selectedClass!.id &&
            e.subjectId == selectedSubject!.id,
      );

      if (alreadyExists) {
        Get.snackbar(
          "Duplicate",
          "Assignment already added.",
        );
        return;
      }

      setState(() {
        assignments.add(
          TeachingAssignmentModel(
            classId: selectedClass!.id,
            className: selectedClass!.name,
            subjectId: selectedSubject!.id,
            subjectName: selectedSubject!.name,
          ),
        );

        selectedClass = null;
        selectedSubject = null;
      });
    },
  ),
),

const SizedBox(height: 20),
if (assignments.isEmpty)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      "No assignments added.",
      textAlign: TextAlign.center,
    ),
  )
else
  ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: assignments.length,
    separatorBuilder: (_, __) =>
        const Divider(height: 12),
    itemBuilder: (context, index) {
      final assignment = assignments[index];

      return ListTile(
        dense: true,
        leading: const CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Icon(
            Icons.school,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(assignment.className),
        subtitle: Text(assignment.subjectName),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              assignments.removeAt(index);
            });
          },
        ),
      );
    },
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
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          onPressed: controller.isSaving.value
              ? null
              : () async {
                  await controller
                      .saveTeacherAssignments(
                    teacherId: teacher.uid,
                    assignments: assignments,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
          child: controller.isSaving.value
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Save"),
        ),
      ),
    ),
  ],
),
      ],
    ),
  ),
));
          },
        );
      },
    );
  }
}