import 'package:cloud_firestore/cloud_firestore.dart';

class TopicProgressModel {
  final String id;

  final String teacherId;
  final String teacherName;

  final String classId;
  final String className;

  final String subjectId;
  final String subjectName;

  final String topicId;
  final String topicTitle;

  final int durationMinutes;

  final String remarks;

  final Timestamp completedAt;

  TopicProgressModel({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.topicId,
    required this.topicTitle,
    required this.durationMinutes,
    required this.remarks,
    required this.completedAt,
  });

  factory TopicProgressModel.fromDocument(
    String id,
    Map<String, dynamic> json,
  ) {
    return TopicProgressModel(
      id: id,
      teacherId: json['teacherId'] ?? '',
      teacherName: json['teacherName'] ?? '',
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      topicId: json['topicId'] ?? '',
      topicTitle: json['topicTitle'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      remarks: json['remarks'] ?? '',
      completedAt: json['completedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'classId': classId,
      'className': className,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'topicId': topicId,
      'topicTitle': topicTitle,
      'durationMinutes': durationMinutes,
      'remarks': remarks,
      'completedAt': completedAt,
    };
  }

  TopicProgressModel copyWith({
    String? id,
    String? teacherId,
    String? teacherName,
    String? classId,
    String? className,
    String? subjectId,
    String? subjectName,
    String? topicId,
    String? topicTitle,
    int? durationMinutes,
    String? remarks,
    Timestamp? completedAt,
  }) {
    return TopicProgressModel(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      topicId: topicId ?? this.topicId,
      topicTitle: topicTitle ?? this.topicTitle,
      durationMinutes:
          durationMinutes ?? this.durationMinutes,
      remarks: remarks ?? this.remarks,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}