import 'package:flutter/material.dart';
import 'package:tito_teachers_app/models/user_model.dart';
import 'package:tito_teachers_app/screens/admin/widgets/assign_student_dailog.dart';
import 'package:tito_teachers_app/screens/admin/widgets/view_student_dialog.dart';

class StudentCard extends StatelessWidget {
  final UserModel student;

  const StudentCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      Colors.green.shade100,
                  child: Text(
                    student.name.isNotEmpty
                        ? student.name[0]
                            .toUpperCase()
                        : "?",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        student.name,
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        student.email,
                        style: TextStyle(
                          color:
                              Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        student.phone,
                        style: TextStyle(
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {

                      case "assign":
                        AssignStudentDialog.show(
                          context,
                          student,
                        );
                        break;

                      case "view":
                        ViewStudentDialog.show(
                          context,
                          student,
                        );
                        break;
                    }
                  },
                  itemBuilder: (_) => const [

                    PopupMenuItem(
                      value: "assign",
                      child: ListTile(
                        leading: Icon(
                          Icons.assignment,
                        ),
                        title: Text(
                          "Assign Class",
                        ),
                      ),
                    ),

                    PopupMenuItem(
                      value: "view",
                      child: ListTile(
                        leading: Icon(
                          Icons.visibility,
                        ),
                        title: Text("View"),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            const Divider(),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [

                Chip(
                  avatar: const Icon(
                    Icons.class_,
                    size: 18,
                    color: Colors.blue,
                  ),
                  backgroundColor:
                      Colors.blue.shade50,
                  label: Text(
                    student.className ??
                        "Not Assigned",
                  ),
                ),

                Chip(
                  avatar: const Icon(
                    Icons.menu_book,
                    size: 18,
                    color: Colors.deepPurple,
                  ),
                  backgroundColor:
                      Colors.deepPurple.shade50,
                  label: Text(
                    "${student.subjectIds.length} Subjects",
                  ),
                ),

                Chip(
                  avatar: const Icon(
                    Icons.school,
                    size: 18,
                    color: Colors.green,
                  ),
                  backgroundColor:
                      Colors.green.shade50,
                  label: const Text(
                    "Student",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,
                ),
                onPressed: () {
                  AssignStudentDialog.show(
                    context,
                    student,
                  );
                },
                icon: const Icon(
                  Icons.assignment,
                ),
                label: const Text(
                  "Assign Class & Subjects",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}