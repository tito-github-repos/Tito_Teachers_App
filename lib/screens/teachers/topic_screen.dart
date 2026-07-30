import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/models/topic_progress_model.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/topic_controller.dart';
import '../../models/topic_model.dart';
import '../../routes/app_routes.dart';

class TeacherTopicsScreen extends StatefulWidget {
  const TeacherTopicsScreen({super.key});

  @override
  State<TeacherTopicsScreen> createState() =>
      _TeacherTopicsScreenState();
}

class _TeacherTopicsScreenState
    extends State<TeacherTopicsScreen> {
  final TopicController topicController =
      TopicController.instance;

  late final String classId;
  late final String className;
  late final String subjectId;
  late final String subjectName;

  late final String teacherId;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>;

    classId = args["classId"];
    className = args["className"];
    subjectId = args["subjectId"];
    subjectName = args["subjectName"];

    teacherId =
        AuthController.instance.currentUser.value!.uid;

    topicController.listenTopics(
      classId: classId,
      subjectId: subjectId,
    );

    topicController.loadCompletedTopics(
      teacherId: teacherId,
      classId: classId,
      subjectId: subjectId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Column(
          children: [
            Text(
              subjectName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              className,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: Obx(() {

        if (topicController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final totalTopics =
            topicController.topics.length;

        final completedTopics =
            topicController.completedTopicIds.length;

        final progress = totalTopics == 0
            ? 0.0
            : completedTopics / totalTopics;

        return Column(
          children: [

            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff4F46E5),
                    Color(0xff6366F1),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo
                        .withOpacity(.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      const CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Colors.white,
                        child: Icon(
                          Icons.menu_book,
                          color: Colors.indigo,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Text(
                              subjectName,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 4),

                            Text(
                              className,
                              style:
                                  const TextStyle(
                                color: Colors
                                    .white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [

                      const Text(
                        "Course Progress",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      Text(
                        "$completedTopics / $totalTopics",
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor:
                          Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation(
                        Colors.greenAccent,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${(progress * 100).toStringAsFixed(0)}% Completed",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: topicController.topics.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 90,
                            color: Colors
                                .grey.shade400,
                          ),
                          const SizedBox(
                              height: 20),
                          const Text(
                            "No Topics Found",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  :ListView.separated(
  padding: const EdgeInsets.fromLTRB(
    16,
    0,
    16,
    16,
  ),
  itemCount: topicController.topics.length,
  separatorBuilder: (_, __) =>
      const SizedBox(height: 14),
  itemBuilder: (_, index) {
    final TopicModel topic =
        topicController.topics[index];

    final bool completed =
        topicController.completedTopicIds
            .contains(topic.id);
final TopicProgressModel? progress =
    topicController.completedTopicProgress[topic.id];
    return InkWell(
      borderRadius:
          BorderRadius.circular(18),
      onTap: () async {
        if (completed) {
          Get.snackbar(
            "Completed",
            "This topic has already been completed.",
            snackPosition:
                SnackPosition.BOTTOM,
            backgroundColor:
                Colors.green,
            colorText: Colors.white,
          );
          return;
        }

        // Get.toNamed(
        //   AppRoutes.completeTopic,
        //   arguments: topic,
        // );
        final result = await Get.toNamed(
  AppRoutes.completeTopic,
  arguments: topic,
);

if (result == true) {
  await topicController.loadCompletedTopics(
    teacherId: teacherId,
    classId: classId,
    subjectId: subjectId,
  );
}
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: completed
              ? Colors.green.shade50
              : Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: completed
                ? Colors.green
                : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.all(16),
          child: Row(
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor:
                    completed
                        ? Colors.green
                        : Colors.indigo,
                child: completed
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Text(
                        "${index + 1}",
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [

                    Text(
                      topic.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                        decoration:
                            completed
                                ? TextDecoration
                                    .lineThrough
                                : null,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      topic.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style: TextStyle(
                        color: Colors
                            .grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .indigo
                                .shade50,
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        20),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(
                                Icons
                                    .schedule,
                                size: 16,
                                color: Colors
                                    .indigo,
                              ),
                              const SizedBox(
                                  width: 4),
                             Text(
  completed
      ? "${progress?.durationMinutes ?? topic.estimatedDuration} mins"
      : "${topic.estimatedDuration} mins",
  style: const TextStyle(
    fontWeight: FontWeight.w600,
  ),
),
                            ],
                          ),
                        ),

                        const SizedBox(
                            width: 10),

                        if (completed)
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.green,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          20),
                            ),
                            child:
                                const Text(
                              "Completed",
                              style:
                                  TextStyle(
                                color: Colors
                                    .white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                completed
                    ? Icons.lock
                    : Icons
                        .arrow_forward_ios_rounded,
                color: completed
                    ? Colors.green
                    : Colors.indigo,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  },
),
            ),
          ],
        );
      }),
    );
  }
} 