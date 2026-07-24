import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/topic_progress_controller.dart';
import '../../models/topic_progress_model.dart';

class TeacherHistoryScreen extends StatefulWidget {
  const TeacherHistoryScreen({super.key});

  @override
  State<TeacherHistoryScreen> createState() =>
      _TeacherHistoryScreenState();
}

class _TeacherHistoryScreenState
    extends State<TeacherHistoryScreen> {

  final TopicProgressController controller =
      TopicProgressController.instance;

  @override
  void initState() {
    super.initState();

    controller.listenTeacherHistory(
      AuthController.instance.user!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Teaching History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {

        final history = controller.teacherHistory;

        final today = DateTime.now();

        final todayCount = history.where((e) {

          final date = e.completedAt.toDate();

          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

        }).length;

        final monthCount = history.where((e) {

          final date = e.completedAt.toDate();

          return date.year == today.year &&
              date.month == today.month;

        }).length;

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
                    color:
                        Colors.indigo.withOpacity(.25),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Teaching Summary",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: _summaryCard(
                          "Completed",
                          history.length.toString(),
                          Icons.check_circle,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _summaryCard(
                          "Today",
                          todayCount.toString(),
                          Icons.today,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _summaryCard(
                          "Month",
                          monthCount.toString(),
                          Icons.calendar_month,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_toggle_off,
                            size: 90,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "No Teaching History",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Completed topics will appear here.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        16,
                      ),
                      itemCount: history.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 14),
                      itemBuilder: (_, index) {
                        final TopicProgressModel item =
                            history[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.grey.shade300,
                                blurRadius: 8,
                                offset:
                                    const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [

                                Row(
                                  children: [

                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor:
                                          Colors.green,
                                      child: const Icon(
                                        Icons.check,
                                        color:
                                            Colors.white,
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 14),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [

                                          Text(
                                            item.topicTitle,
                                            style:
                                                const TextStyle(
                                              fontSize: 17,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                              height: 4),

                                          Text(
                                            "${item.subjectName} • ${item.className}",
                                            style:
                                                TextStyle(
                                              color: Colors
                                                  .grey
                                                  .shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .indigo
                                            .shade50,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    25),
                                      ),
                                      child: Row(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min,
                                        children: [

                                          const Icon(
                                            Icons.timer,
                                            size: 16,
                                            color: Colors
                                                .indigo,
                                          ),

                                          const SizedBox(
                                              width: 5),

                                          Text(
                                            "${item.durationMinutes} mins",
                                            style:
                                                const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .green
                                            .shade100,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    25),
                                      ),
                                      child: const Text(
                                        "Completed",
                                        style:
                                            TextStyle(
                                          color:
                                              Colors.green,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  children: [

                                    Icon(
                                      Icons.schedule,
                                      color: Colors
                                          .grey.shade600,
                                      size: 18,
                                    ),

                                    const SizedBox(
                                        width: 6),

                                    Text(
                                      DateFormat(
                                        "dd MMM yyyy • hh:mm a",
                                      ).format(
                                        item.completedAt
                                            .toDate(),
                                      ),
                                      style: TextStyle(
                                        color: Colors
                                            .grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),

                                if (item.remarks
                                    .trim()
                                    .isNotEmpty) ...[
                                  const SizedBox(
                                      height: 16),

                                  const Divider(),

                                  const SizedBox(
                                      height: 8),

                                  const Text(
                                    "Remarks",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 6),

                                  Text(
                                    item.remarks,
                                    style: TextStyle(
                                      color: Colors
                                          .grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ],
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

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}