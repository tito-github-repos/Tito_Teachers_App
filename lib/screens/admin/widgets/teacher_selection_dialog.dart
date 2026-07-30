import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/teacher_assignment_controller.dart';
import 'package:tito_teachers_app/models/assignment_summary_model.dart';


class TeacherSelectionDialog {
  static Future<Map<String, String>?> show({
    required BuildContext context,
    required String classId,
    required List<String> subjectIds,
  }) async {
    final controller = Get.put(
      TeacherAssignmentController(),
    );

    await controller.loadAllTeachers(
      classId: classId,
      subjectIds: subjectIds,
    );

    final Map<String, String> selectedTeachers = {};

    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Assign Teachers",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 700,
                height: 550,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: subjectIds.length,
                    itemBuilder: (context, index) {
                      final subjectId = subjectIds[index];

                      final teachers =
                          controller.getTeachers(subjectId);

                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            subjectId.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          if (teachers.isEmpty)
                            Container(
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "No teachers found for this subject.",
                              ),
                            )
                          else
                            ...teachers.map(
                              (teacher) {
                                return TeacherCardSelection(
                                  teacher: teacher,
                                  selected:
                                      selectedTeachers[
                                              subjectId] ==
                                          teacher.teacherId,
                                  onTap: () {
                                    setState(() {
                                      selectedTeachers[
                                              subjectId] =
                                          teacher.teacherId;
                                    });
                                  },
                                );
                              },
                            ),

                          const Divider(height: 40),
                        ],
                      );
                    },
                  );
                }),
              ),
                            actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed:
                      selectedTeachers.length !=
                              subjectIds.length
                          ? null
                          : () {
                              Navigator.pop(
                                context,
                                selectedTeachers,
                              );
                            },
                  child: const Text("Assign"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
class TeacherCardSelection extends StatelessWidget {
  final TeacherAssignmentSummary teacher;
  final bool selected;
  final VoidCallback onTap;

  const TeacherCardSelection({
    super.key,
    required this.teacher,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: selected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: teacher.teacherId,
        groupValue: selected
            ? teacher.teacherId
            : null,
        onChanged: (_) => onTap(),
        activeColor: Theme.of(context).primaryColor,

        title: Text(
          teacher.teacherName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [

              const Icon(
                Icons.menu_book,
                size: 16,
                color: Colors.blue,
              ),

              const SizedBox(width: 4),

              Text(
                "${teacher.completedTopics}/${teacher.totalTopics}",
              ),

              const SizedBox(width: 20),

              const Icon(
                Icons.people,
                size: 16,
                color: Colors.green,
              ),

              const SizedBox(width: 4),

              Text(
                "${teacher.assignedStudents}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}