class PaymentSettingModel {
  final String id;
  final String subjectId;
  final String subjectName;

  final double teacherRatePerMinute;
  final double studentMonthlyFee;

  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentSettingModel({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.teacherRatePerMinute,
    required this.studentMonthlyFee,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentSettingModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return PaymentSettingModel(
      id: id,
      subjectId: map['subjectId'] ?? '',
      subjectName: map['subjectName'] ?? '',
      teacherRatePerMinute:
          (map['teacherRatePerMinute'] ?? 0).toDouble(),
      studentMonthlyFee:
          (map['studentMonthlyFee'] ?? 0).toDouble(),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'teacherRatePerMinute':
          teacherRatePerMinute,
      'studentMonthlyFee':
          studentMonthlyFee,
      'isActive': isActive,
      'createdAt':
          createdAt.toIso8601String(),
      'updatedAt':
          updatedAt.toIso8601String(),
    };
  }
}