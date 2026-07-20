class SubjectModel {
  final String id;
  final String name;
  final String code;
  final bool isActive;

  SubjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
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
    );
  }
}