import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String id;

  final String name;

  final String code;

  final bool isActive;

  final Timestamp createdAt;

  SubjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
    required this.createdAt,
  });

  factory SubjectModel.fromDocument(
    String id,
    Map<String, dynamic> json,
  ) {
    return SubjectModel(
      id: id,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  SubjectModel copyWith({
    String? id,
    String? name,
    String? code,
    bool? isActive,
    Timestamp? createdAt,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}