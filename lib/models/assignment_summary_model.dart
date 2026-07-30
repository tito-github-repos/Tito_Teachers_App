import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherAssignmentSummary {
  final String teacherId;
  final String teacherName;

  final String classId;
  final String subjectId;

  final int totalTopics;
  final int completedTopics;

  final int assignedStudents;

  final String? lastCompletedTopic;
  final Timestamp? lastCompletedAt;

  TeacherAssignmentSummary({
    required this.teacherId,
    required this.teacherName,
    required this.classId,
    required this.subjectId,
    required this.totalTopics,
    required this.completedTopics,
    required this.assignedStudents,
    this.lastCompletedTopic,
    this.lastCompletedAt,
  });

  double get progressPercentage {
    if (totalTopics == 0) {
      return 0;
    }

    return (completedTopics / totalTopics) * 100;
  }

  bool get isCompletedAllTopics {
    return totalTopics > 0 &&
        completedTopics == totalTopics;
  }

  bool get hasStarted {
    return completedTopics > 0;
  }

  int get remainingTopics {
    return totalTopics - completedTopics;
  }
}