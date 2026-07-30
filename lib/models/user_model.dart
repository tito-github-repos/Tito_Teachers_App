import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/models/assigned_teacher_model.dart';
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
 /// Used only for Student
final List<String> subjectIds;
final List<AssignedTeacherModel> assignedTeachers;
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
      this.subjectIds = const [],

this.assignedTeachers = const [],
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
subjectIds: List<String>.from(
  json['subjectIds'] ?? [],
),
assignedTeachers:
    (json["assignedTeachers"] as List<dynamic>?)
            ?.map(
              (e) => AssignedTeacherModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList() ??
        [],
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
      'subjectIds': subjectIds,
"assignedTeachers": assignedTeachers
    .map((e) => e.toJson())
    .toList(),
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
  factory UserModel.fromDocument(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data()!;

  return UserModel.fromJson({
    ...data,
    "uid": doc.id,
  });
}
}