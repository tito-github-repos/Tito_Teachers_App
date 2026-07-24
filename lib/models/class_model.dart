import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String id;

  final String name;

  final int order;

  final bool isActive;

  final Timestamp createdAt;
  final List<String> subjectIds;

  ClassModel({
    required this.id,
    required this.name,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.subjectIds,
  });

  factory ClassModel.fromDocument(
    String id,
    Map<String, dynamic> json,
  ) {
    return ClassModel(
      id: id,
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? Timestamp.now(),
      subjectIds: List<String>.from(
  json['subjectIds'] ?? [],
),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'order': order,
      'isActive': isActive,
      'createdAt': createdAt,
      'subjectIds': subjectIds,
    };
  }

  ClassModel copyWith({
    String? id,
    String? name,
    int? order,
    bool? isActive,
    Timestamp? createdAt,
    List<String>? subjectIds,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      subjectIds: subjectIds ?? this.subjectIds,
    );
  }
}