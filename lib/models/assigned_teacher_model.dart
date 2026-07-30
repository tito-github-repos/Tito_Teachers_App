class AssignedTeacherModel {
  final String subjectId;
  final String teacherId;

  AssignedTeacherModel({
    required this.subjectId,
    required this.teacherId,
  });

  factory AssignedTeacherModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignedTeacherModel(
      subjectId: json["subjectId"] ?? "",
      teacherId: json["teacherId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subjectId": subjectId,
      "teacherId": teacherId,
    };
  }
}