import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/teachers_controller.dart';


class TeacherListScreen extends StatelessWidget {
  TeacherListScreen({super.key});

  final TeacherController controller = Get.put(TeacherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teachers"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.teachers.isEmpty) {
          return const Center(
            child: Text("No teachers found"),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadTeachers,
          child: ListView.builder(
            itemCount: controller.teachers.length,
            itemBuilder: (context, index) {
              final teacher = controller.teachers[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(teacher.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teacher.email),
                      Text(teacher.phone),
                      Text(
                        teacher.subjects.isEmpty
                            ? "No subjects assigned"
                            : teacher.subjects.join(", "),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}