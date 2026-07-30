import 'package:flutter/material.dart';
import 'package:tito_teachers_app/models/user_model.dart';
import 'package:tito_teachers_app/repositories/subject_repo.dart';


class ViewStudentDialog {
  static Future<void> show(
    BuildContext context,
    UserModel student,
  ) async {
    final subjects =
        await SubjectRepository.instance
            .getActiveSubjects();

    final assignedSubjects = subjects.where(
      (subject) => student.subjectIds.contains(subject.id),
    ).toList();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            student.name,
          ),

          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min,
                children: [

                  ListTile(
                    leading: const Icon(
                      Icons.class_,
                      color: Colors.blue,
                    ),
                    title: const Text("Class"),
                    subtitle: Text(
                      student.className ??
                          "Not Assigned",
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Subjects",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (assignedSubjects.isEmpty)
                    const Text(
                      "No subjects assigned.",
                    )
                  else
                    ...assignedSubjects.map(
                      (subject) => Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.menu_book,
                            color: Colors.green,
                          ),
                          title: Text(
                            subject.name,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Close",
              ),
            ),
          ],
        );
      },
    );
  }
}