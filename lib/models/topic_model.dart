import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  final String id;

  final String classId;
  final String className;

  final String subjectId;
  final String subjectName;

  final String title;

  final String description;

  final int order;

  final int estimatedDuration;

  final bool isActive;

  final Timestamp createdAt;

  TopicModel({
    required this.id,
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.title,
    required this.description,
    required this.order,
    required this.estimatedDuration,
    required this.isActive,
    required this.createdAt,
  });

  factory TopicModel.fromDocument(
    String id,
    Map<String, dynamic> json,
  ) {
    return TopicModel(
      id: id,
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
      estimatedDuration: json['estimatedDuration'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'className': className,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'title': title,
      'description': description,
      'order': order,
      'estimatedDuration': estimatedDuration,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  TopicModel copyWith({
    String? id,
    String? classId,
    String? className,
    String? subjectId,
    String? subjectName,
    String? title,
    String? description,
    int? order,
    int? estimatedDuration,
    bool? isActive,
    Timestamp? createdAt,
  }) {
    return TopicModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      estimatedDuration:
          estimatedDuration ?? this.estimatedDuration,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}