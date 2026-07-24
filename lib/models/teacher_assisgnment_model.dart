class TeachingAssignmentModel {
  final String classId;
  final String className;

  final String subjectId;
  final String subjectName;

  TeachingAssignmentModel({
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
  });

  factory TeachingAssignmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TeachingAssignmentModel(
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'className': className,
      'subjectId': subjectId,
      'subjectName': subjectName,
    };
  }
}