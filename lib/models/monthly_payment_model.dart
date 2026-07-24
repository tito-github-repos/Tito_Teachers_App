import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyPaymentDetail {
  final String subjectId;
  final String subjectName;

  /// Teacher only
  final int minutes;

  /// Teacher rate per minute
  final double rate;

  /// Student monthly fee
  final double monthlyFee;

  final double amount;

  MonthlyPaymentDetail({
    required this.subjectId,
    required this.subjectName,
    required this.minutes,
    required this.rate,
    required this.monthlyFee,
    required this.amount,
  });

  factory MonthlyPaymentDetail.fromMap(
      Map<String, dynamic> map) {
    return MonthlyPaymentDetail(
      subjectId: map['subjectId'] ?? '',
      subjectName: map['subjectName'] ?? '',
      minutes: map['minutes'] ?? 0,
      rate: (map['rate'] ?? 0).toDouble(),
      monthlyFee:
          (map['monthlyFee'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'minutes': minutes,
      'rate': rate,
      'monthlyFee': monthlyFee,
      'amount': amount,
    };
  }
}

class MonthlyPaymentModel {
  final String id;

  final String userId;
  final String userName;

  /// teacher / student
  final String role;

  final int month;
  final int year;

  final List<MonthlyPaymentDetail> details;

  final int totalMinutes;

  final double totalAmount;

  /// Pending | Paid | Overdue
  final String status;

  final DateTime dueDate;

  final DateTime? paidDate;

  final String paymentMode;

  final String referenceNumber;

  final String remarks;

  final String recordedBy;

  final DateTime createdAt;

  final DateTime updatedAt;

  MonthlyPaymentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.role,
    required this.month,
    required this.year,
    required this.details,
    required this.totalMinutes,
    required this.totalAmount,
    required this.status,
    required this.dueDate,
    this.paidDate,
    required this.paymentMode,
    required this.referenceNumber,
    required this.remarks,
    required this.recordedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MonthlyPaymentModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return MonthlyPaymentModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      role: map['role'] ?? '',
      month: map['month'] ?? 0,
      year: map['year'] ?? 0,
      details: (map['details'] as List? ?? [])
          .map((e) =>
              MonthlyPaymentDetail.fromMap(e))
          .toList(),
      totalMinutes:
          map['totalMinutes'] ?? 0,
      totalAmount:
          (map['totalAmount'] ?? 0)
              .toDouble(),
      status: map['status'] ?? 'Pending',
   dueDate: map['dueDate'] is Timestamp
    ? (map['dueDate'] as Timestamp).toDate()
    : DateTime.parse(map['dueDate']),

paidDate: map['paidDate'] == null
    ? null
    : map['paidDate'] is Timestamp
        ? (map['paidDate'] as Timestamp).toDate()
        : DateTime.parse(map['paidDate']),

      referenceNumber:
          map['referenceNumber'] ?? '',
      remarks: map['remarks'] ?? '',
      recordedBy:
          map['recordedBy'] ?? '',
   
createdAt: map['createdAt'] is Timestamp
    ? (map['createdAt'] as Timestamp).toDate()
    : DateTime.parse(map['createdAt']),

updatedAt: map['updatedAt'] is Timestamp
    ? (map['updatedAt'] as Timestamp).toDate()
    : DateTime.parse(map['updatedAt']),
      paymentMode:
          map['paymentMode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'role': role,
      'month': month,
      'year': year,
      'details':
          details.map((e) => e.toMap()).toList(),
      'totalMinutes': totalMinutes,
      'totalAmount': totalAmount,
      'status': status,
      'dueDate':
          dueDate.toIso8601String(),
      'paidDate':
          paidDate?.toIso8601String(),
      'paymentMode': paymentMode,
      'referenceNumber':
          referenceNumber,
      'remarks': remarks,
      'recordedBy': recordedBy,
      'createdAt':
          createdAt.toIso8601String(),
      'updatedAt':
          updatedAt.toIso8601String(),
    };
  }
}