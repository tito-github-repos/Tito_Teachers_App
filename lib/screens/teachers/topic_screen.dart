import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/controllers/topic_controller.dart';
import 'package:tito_teachers_app/models/subjects_model.dart';

class TopicsScreen extends StatelessWidget {
  final SubjectModel subject;

  TopicsScreen({
    super.key,
    required this.subject,
  });

  final TopicController controller = Get.put(TopicController());

  @override
  Widget build(BuildContext context) {
    controller.loadTopics(subject.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.topics.isEmpty) {
          return const Center(
            child: Text(
              "No topics available",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.topics.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final topic = controller.topics[index];

            return Card(
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text("${topic.order}"),
                ),
                title: Text(
                  topic.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Topic ${topic.order}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.toNamed(
                    "/topic-detail",
                    arguments: topic,
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}