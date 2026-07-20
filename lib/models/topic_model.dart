import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  final String id;
  final String subjectId;
  final String title;
  final int order;
  final bool isActive;
  final Timestamp createdAt;

  TopicModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.order,
    required this.isActive,
    required this.createdAt,
  });

  factory TopicModel.fromDocument(
    String id,
    Map<String, dynamic> json,
  ) {
    return TopicModel(
      id: id,
      subjectId: json['subjectId'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'title': title,
      'order': order,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}