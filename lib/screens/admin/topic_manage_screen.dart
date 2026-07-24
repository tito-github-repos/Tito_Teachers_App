import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/class_controller.dart';
import '../../controllers/subject_controller.dart';
import '../../controllers/topic_controller.dart';
import '../../models/topic_model.dart';


class TopicManagementScreen extends StatefulWidget {
  const TopicManagementScreen({super.key});

  @override
  State<TopicManagementScreen> createState() =>
      _TopicManagementScreenState();
}

class _TopicManagementScreenState
    extends State<TopicManagementScreen> {

  final TopicController topicController =
      TopicController.instance;

  final ClassController classController =
      ClassController.instance;

  final SubjectController subjectController =
      SubjectController.instance;

  final TextEditingController searchController =
      TextEditingController();

  final RxList<TopicModel> filteredTopics =
      <TopicModel>[].obs;

  String? selectedClassId;
  String? selectedSubjectId;

  @override
  void initState() {
    super.initState();

    if (classController.classes.isEmpty) {
      classController.loadClasses();
    }

    if (subjectController.subjects.isEmpty) {
      subjectController.loadSubjects();
    }

    topicController.listenAllTopics();

    ever<List<TopicModel>>(
      topicController.topics,
      (_) => _applyFilters(),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {

    final keyword =
        searchController.text.trim().toLowerCase();

    filteredTopics.assignAll(
      topicController.topics.where((topic) {

        final classMatch =
            selectedClassId == null ||
                topic.classId == selectedClassId;

        final subjectMatch =
            selectedSubjectId == null ||
                topic.subjectId ==
                    selectedSubjectId;

        final searchMatch =
            keyword.isEmpty ||

                topic.title
                    .toLowerCase()
                    .contains(keyword) ||

                topic.description
                    .toLowerCase()
                    .contains(keyword) ||

                topic.className
                    .toLowerCase()
                    .contains(keyword) ||

                topic.subjectName
                    .toLowerCase()
                    .contains(keyword);

        return classMatch &&
            subjectMatch &&
            searchMatch;

      }).toList(),
    );
  }

  void _searchTopics(String value) {
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xffF5F7FA),

  appBar: AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    title: const Text(
      "Topic Management",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  floatingActionButton: FloatingActionButton.extended(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    icon: const Icon(Icons.add),
    label: const Text("Add Topic"),
    onPressed: () {
      _showTopicDialog(
        context,
        topicController,
        classController,
        subjectController,
      );
    },
  ),

  body: Obx(() {

    if (topicController.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(

      onRefresh: () async {
        topicController.listenAllTopics();
      },

      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
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
                    offset:
                        const Offset(0, 5),
                  ),
                ],
              ),

              child: Row(
                children: [

                  const CircleAvatar(
                    radius: 34,
                    backgroundColor:
                        Colors.white,
                    child: Icon(
                      Icons.menu_book,
                      color: Colors.indigo,
                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Topic Management",
                          style: TextStyle(
                            color:
                                Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Obx(
                          () => Text(
                            "${filteredTopics.length} Topics",
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Filter topics by Class & Subject",
                          style: TextStyle(
                            color:
                                Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// CLASS DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedClassId,
              decoration: InputDecoration(
                labelText: "Select Class",
                prefixIcon:
                    const Icon(Icons.school),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),

              items: classController.classes
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),

              onChanged: (value) {

                setState(() {

                  selectedClassId = value;

                  /// Reset subject
                  selectedSubjectId = null;

                  _applyFilters();
                });
              },
            ),

            const SizedBox(height: 18),

            /// SUBJECT DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedSubjectId,

              decoration: InputDecoration(
                labelText: "Select Subject",
                prefixIcon:
                    const Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),

              items: subjectController.subjects
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),

              onChanged: (value) {

                setState(() {

                  selectedSubjectId = value;

                  _applyFilters();
                });
              },
            ),

            const SizedBox(height: 20),

            /// SEARCH
            TextField(
              controller:
                  searchController,
              onChanged:
                  _searchTopics,

              decoration:
                  InputDecoration(

                hintText:
                    "Search Topic",

                prefixIcon:
                    const Icon(Icons.search),

                suffixIcon:
                    searchController
                            .text
                            .isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                                Icons.clear),
                            onPressed: () {

                              searchController
                                  .clear();

                              _applyFilters();

                              setState(() {});
                            },
                          )
                        : null,

                filled: true,
                fillColor: Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Topics",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            if (filteredTopics.isEmpty)
              _buildEmptyState()
            else
              ListView.separated(

                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                itemCount:
                    filteredTopics.length,

                separatorBuilder:
                    (_, __) =>
                        const SizedBox(
                  height: 16,
                ),

                itemBuilder:
                    (context, index) {

                  return _buildTopicCard(
                    filteredTopics[index],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }),
);
}
Widget _buildTopicCard(TopicModel topic) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Header
          Row(
            children: [

              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Text(
                  topic.order.toString(),
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.center,
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      topic.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {

                  if (value == "edit") {

                    _showTopicDialog(
                      context,
                      topicController,
                      classController,
                      subjectController,
                      topic: topic,
                    );

                  } else if (value ==
                      "delete") {

                    _deleteTopic(
                      topicController,
                      topic,
                    );
                  }
                },
                itemBuilder: (_) => const [

                  PopupMenuItem(
                    value: "edit",
                    child: ListTile(
                      leading:
                          Icon(Icons.edit),
                      title: Text("Edit"),
                    ),
                  ),

                  PopupMenuItem(
                    value: "delete",
                    child: ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title:
                          Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [

              Chip(
                avatar: const Icon(
                  Icons.school,
                  size: 18,
                  color: Colors.blue,
                ),
                backgroundColor:
                    Colors.blue.shade50,
                label: Text(
                  topic.className,
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
                  topic.subjectName,
                ),
              ),

              Chip(
                avatar: const Icon(
                  Icons.timer,
                  size: 18,
                  color: Colors.orange,
                ),
                backgroundColor:
                    Colors.orange.shade50,
                label: Text(
                  "${topic.estimatedDuration} mins",
                ),
              ),

              Chip(
                avatar: Icon(
                  topic.isActive
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 18,
                  color: topic.isActive
                      ? Colors.green
                      : Colors.red,
                ),
                backgroundColor:
                    topic.isActive
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                label: Text(
                  topic.isActive
                      ? "Active"
                      : "Inactive",
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.edit,
                  ),
                  label: const Text(
                    "Edit",
                  ),
                  onPressed: () {
                    _showTopicDialog(
                      context,
                      topicController,
                      classController,
                      subjectController,
                      topic: topic,
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,
                    foregroundColor:
                        Colors.white,
                  ),
                  icon: const Icon(
                    Icons.delete,
                  ),
                  label: const Text(
                    "Delete",
                  ),
                  onPressed: () {
                    _deleteTopic(
                      topicController,
                      topic,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget _buildEmptyState() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.indigo.shade50,
            child: const Icon(
              Icons.menu_book_outlined,
              size: 45,
              color: Colors.indigo,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "No Topics Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Please select a Class and Subject\nor create a new topic.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _showTopicDialog(
                context,
                topicController,
                classController,
                subjectController,
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Topic"),
          ),
        ],
      ),
    ),
  );
}

Future<void> _deleteTopic(
  TopicController topicController,
  TopicModel topic,
) async {
  final bool? confirm =
      await Get.dialog<bool>(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      title: const Text("Delete Topic"),
      content: Text(
        'Delete "${topic.title}" ?',
      ),
      actions: [

        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Get.back(result: true);
          },
          icon: const Icon(Icons.delete),
          label: const Text("Delete"),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  await topicController.deleteTopic(
    topic.id,
  );
}
}
Future<void> _showTopicDialog(
  BuildContext context,
  TopicController topicController,
  ClassController classController,
  SubjectController subjectController, {
  TopicModel? topic,
}) async {
  Get.snackbar(
    "Coming Soon",
    "Topic dialog is not added yet.",
  );
}