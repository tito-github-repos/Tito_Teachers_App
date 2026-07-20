import 'package:cloud_firestore/cloud_firestore.dart';

class TopicProgressModel {
  final String id;

  final String teacherId;
  final String teacherName;

  final String subjectId;
  final String subjectName;

  final String classId;
  final String className;

  final String topicId;
  final String topicTitle;

  final DateTime completedAt;

  final int durationMinutes;

  final String remarks;

  TopicProgressModel({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.subjectId,
    required this.subjectName,
    required this.classId,
    required this.className,
    required this.topicId,
    required this.topicTitle,
    required this.completedAt,
    required this.durationMinutes,
    required this.remarks,
  });

  factory TopicProgressModel.fromDocument(
    String id,
    Map<String, dynamic> json,
  ) {
    return TopicProgressModel(
      id: id,
      teacherId: json['teacherId'] ?? '',
      teacherName: json['teacherName'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      topicId: json['topicId'] ?? '',
      topicTitle: json['topicTitle'] ?? '',
      completedAt:
          (json['completedAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      durationMinutes: json['durationMinutes'] ?? 0,
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'classId': classId,
      'className': className,
      'topicId': topicId,
      'topicTitle': topicTitle,
      'completedAt': Timestamp.fromDate(completedAt),
      'durationMinutes': durationMinutes,
      'remarks': remarks,
    };
  }
}