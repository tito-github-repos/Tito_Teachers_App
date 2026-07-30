import 'package:flutter/material.dart';
import 'package:tito_teachers_app/models/user_model.dart';


class ViewTeacherAssignmentsDialog {
  static Future<void> show(
    BuildContext context,
    UserModel teacher,
  ) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "${teacher.name}\nAssignments",
          ),

          content: SizedBox(
            width: 450,

            child: teacher.teachingAssignments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No assignments available.",
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,

                    itemCount:
                        teacher.teachingAssignments.length,

                    separatorBuilder: (_, __) =>
                        const Divider(),

                    itemBuilder: (context, index) {
                      final assignment =
                          teacher.teachingAssignments[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.indigo.shade100,
                          child: const Icon(
                            Icons.school,
                            color: Colors.indigo,
                          ),
                        ),

                        title: Text(
                          assignment.className,
                        ),

                        subtitle: Text(
                          assignment.subjectName,
                        ),
                      );
                    },
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