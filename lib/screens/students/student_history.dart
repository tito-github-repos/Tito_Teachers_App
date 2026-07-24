import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/topic_progress_controller.dart';

class StudentHistoryScreen extends StatefulWidget {
  const StudentHistoryScreen({super.key});

  @override
  State<StudentHistoryScreen> createState() =>
      _StudentHistoryScreenState();
}

class _StudentHistoryScreenState
    extends State<StudentHistoryScreen> {

  final auth = AuthController.instance;
  final controller =
      TopicProgressController.instance;

  @override
  void initState() {
    super.initState();

    controller.listenClassHistory(
      auth.user!.classId!,
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
        title: const Text(
          "Learning History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {

        final history = controller.classHistory;

        final today = DateTime.now();

        final todayCount = history.where((e) {
          final d = e.completedAt.toDate();

          return d.year == today.year &&
              d.month == today.month &&
              d.day == today.day;
        }).length;

        final monthCount = history.where((e) {
          final d = e.completedAt.toDate();

          return d.year == today.year &&
              d.month == today.month;
        }).length;

        return Column(
          children: [

            Container(
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
              ),
              child: Row(
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
            ),

            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.history_edu,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "No Learning History",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

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
                        20,
                      ),
                      itemCount: history.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (_, index) {

                        final item = history[index];

                        return Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [

                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        Colors.indigo.shade50,
                                    child: Icon(
                                      Icons.menu_book,
                                      color: Colors.indigo.shade700,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          item.topicTitle,
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          "${item.subjectName} • ${item.className}",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
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
                                runSpacing: 8,
                                children: [

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${item.durationMinutes} mins",
                                      style: TextStyle(
                                        color:
                                            Colors.green.shade700,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Completed",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [

                                  Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      item.teacherName,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [

                                  Icon(
                                    Icons.schedule,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    DateFormat(
                                      "dd MMM yyyy • hh:mm a",
                                    ).format(
                                      item.completedAt.toDate(),
                                    ),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),

                              if (item.remarks.trim().isNotEmpty) ...[
                                const SizedBox(height: 16),

                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.orange.shade50,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Icon(
                                        Icons.notes,
                                        color: Colors.orange.shade700,
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Text(
                                          item.remarks,
                                          style: TextStyle(
                                            color:
                                                Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
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
      vertical: 18,
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