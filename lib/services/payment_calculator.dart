import 'package:tito_teachers_app/constants/enums.dart';

import '../models/monthly_payment_model.dart';
import '../models/payment_setting_model.dart';

class PaymentCalculator {
  PaymentCalculator._();

  static final PaymentCalculator instance =
      PaymentCalculator._();

  /// ---------------------------------------------------------------------------
  /// TEACHER PAYMENT DETAIL
  /// ---------------------------------------------------------------------------

  MonthlyPaymentDetail createTeacherDetail({
    required String subjectId,
    required String subjectName,
    required int minutes,
    required double ratePerMinute,
  }) {
    return MonthlyPaymentDetail(
      subjectId: subjectId,
      subjectName: subjectName,
      minutes: minutes,
      rate: ratePerMinute,
      monthlyFee: 0,
      amount: minutes * ratePerMinute,
    );
  }

  /// ---------------------------------------------------------------------------
  /// STUDENT PAYMENT DETAIL
  /// ---------------------------------------------------------------------------

  MonthlyPaymentDetail createStudentDetail({
    required String subjectId,
    required String subjectName,
    required double monthlyFee,
  }) {
    return MonthlyPaymentDetail(
      subjectId: subjectId,
      subjectName: subjectName,
      minutes: 0,
      rate: 0,
      monthlyFee: monthlyFee,
      amount: monthlyFee,
    );
  }

  /// ---------------------------------------------------------------------------
  /// TOTAL MINUTES
  /// ---------------------------------------------------------------------------

  int calculateTotalMinutes(
      List<MonthlyPaymentDetail> details) {
    return details.fold(
      0,
      (sum, item) => sum + item.minutes,
    );
  }

  /// ---------------------------------------------------------------------------
  /// TOTAL AMOUNT
  /// ---------------------------------------------------------------------------

  double calculateTotalAmount(
      List<MonthlyPaymentDetail> details) {
    return details.fold(
      0,
      (sum, item) => sum + item.amount,
    );
  }

  /// ---------------------------------------------------------------------------
  /// CREATE MONTHLY PAYMENT
  /// ---------------------------------------------------------------------------

  MonthlyPaymentModel createMonthlyPayment({
    required String userId,
    required String userName,
    required UserRole role,
    required int month,
    required int year,
    required List<MonthlyPaymentDetail> details,
    required DateTime dueDate,
  }) {
    final totalMinutes =
        calculateTotalMinutes(details);

    final totalAmount =
        calculateTotalAmount(details);

    return MonthlyPaymentModel(
      id:
          "${userId}_${year}_${month.toString().padLeft(2, '0')}",

      userId: userId,

      userName: userName,

      role: role.value,

      month: month,

      year: year,

      details: details,

      totalMinutes: totalMinutes,

      totalAmount: totalAmount,

      status: PaymentStatus.pending.value,

      dueDate: dueDate,

      paidDate: null,

      paymentMode: "",

      referenceNumber: "",

      remarks: "",

      recordedBy: "",

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),
    );
  }

  /// ---------------------------------------------------------------------------
  /// GET SUBJECT RATE
  /// ---------------------------------------------------------------------------

  double getTeacherRate(
    List<PaymentSettingModel> settings,
    String subjectId,
  ) {
    try {
      return settings
          .firstWhere(
            (e) => e.subjectId == subjectId,
          )
          .teacherRatePerMinute;
    } catch (_) {
      return 0;
    }
  }

  /// ---------------------------------------------------------------------------
  /// GET STUDENT FEE
  /// ---------------------------------------------------------------------------

  double getStudentFee(
    List<PaymentSettingModel> settings,
    String subjectId,
  ) {
    try {
      return settings
          .firstWhere(
            (e) => e.subjectId == subjectId,
          )
          .studentMonthlyFee;
    } catch (_) {
      return 0;
    }
  }
}