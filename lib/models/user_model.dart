import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/models/teacher_assisgnment_model.dart';


class UserModel {
  final String uid;

  final String name;

  final String phone;

  final String email;

  final String role;

  /// Used only for Student
  final String? classId;
  final String? className;

  /// Used only for Teacher
  final List<TeachingAssignmentModel> teachingAssignments;

  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.classId,
    this.className,
    required this.teachingAssignments,
    required this.createdAt,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserModel(
      uid: json['uid'] ?? '',

      name: json['name'] ?? '',

      phone: json['phone'] ?? '',

      email: json['email'] ?? '',

      role: json['role'] ?? '',

      classId: json['classId'],

      className: json['className'],

      teachingAssignments:
      (json['teachingAssignments'] as List<dynamic>? ?? [])
          .map(
            (e) => TeachingAssignmentModel.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),

      createdAt:
      json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,

      'name': name,

      'phone': phone,

      'email': email,

      'role': role,

      'classId': classId,

      'className': className,

      'teachingAssignments':
      teachingAssignments
          .map(
            (e) => e.toJson(),
      )
          .toList(),

      'createdAt': createdAt,
    };
  }

  bool get isTeacher => role == "teacher";

  bool get isStudent => role == "student";

  bool get isAdmin => role == "admin";
}