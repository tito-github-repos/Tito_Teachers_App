import 'package:tito_teachers_app/constants/enums.dart';
import 'package:tito_teachers_app/repositories/monthly_payment_repo.dart';

import '../models/monthly_payment_model.dart';
import '../models/payment_setting_model.dart';
import '../services/payment_calculator.dart';

/// ---------------------------------------------------------------------------
/// INPUT MODELS
/// ---------------------------------------------------------------------------

class TeacherMonthlyInput {
  final String teacherId;
  final String teacherName;

  /// subjectId -> total minutes
  final Map<String, int> subjectMinutes;

  /// subjectId -> subjectName
  final Map<String, String> subjectNames;

  TeacherMonthlyInput({
    required this.teacherId,
    required this.teacherName,
    required this.subjectMinutes,
    required this.subjectNames,
  });
}

class StudentMonthlyInput {
  final String studentId;
  final String studentName;

  /// Selected subjects
  final List<String> subjectIds;

  /// subjectId -> subjectName
  final Map<String, String> subjectNames;

  StudentMonthlyInput({
    required this.studentId,
    required this.studentName,
    required this.subjectIds,
    required this.subjectNames,
  });
}

/// ---------------------------------------------------------------------------
/// GENERATOR
/// ---------------------------------------------------------------------------

class MonthlyPaymentGenerator {
  MonthlyPaymentGenerator._();

  static final MonthlyPaymentGenerator instance =
      MonthlyPaymentGenerator._();

  final MonthlyPaymentRepository _repository =
      MonthlyPaymentRepository.instance;

  final PaymentCalculator _calculator =
      PaymentCalculator.instance;

  /// -------------------------------------------------------------------------
  /// GENERATE TEACHER PAYMENT
  /// -------------------------------------------------------------------------

  Future<void> generateTeacherPayment({
    required TeacherMonthlyInput teacher,
    required List<PaymentSettingModel> settings,
    required int month,
    required int year,
    required DateTime dueDate,
  }) async {

    final exists =
        await _repository.paymentExists(
      userId: teacher.teacherId,
      month: month,
      year: year,
    );

    if (exists) return;

    List<MonthlyPaymentDetail> details = [];

    teacher.subjectMinutes.forEach(
      (subjectId, minutes) {

        final rate = _calculator.getTeacherRate(
          settings,
          subjectId,
        );

        details.add(
          _calculator.createTeacherDetail(
            subjectId: subjectId,
            subjectName:
                teacher.subjectNames[subjectId] ??
                    "",
            minutes: minutes,
            ratePerMinute: rate,
          ),
        );
      },
    );

    final payment =
        _calculator.createMonthlyPayment(
      userId: teacher.teacherId,
      userName: teacher.teacherName,
      role: UserRole.teacher,
      month: month,
      year: year,
      details: details,
      dueDate: dueDate,
    );

    await _repository.savePayment(payment);
  }

  /// -------------------------------------------------------------------------
  /// GENERATE STUDENT PAYMENT
  /// -------------------------------------------------------------------------

  Future<void> generateStudentPayment({
    required StudentMonthlyInput student,
    required List<PaymentSettingModel> settings,
    required int month,
    required int year,
    required DateTime dueDate,
  }) async {

    final exists =
        await _repository.paymentExists(
      userId: student.studentId,
      month: month,
      year: year,
    );

    if (exists) return;

    List<MonthlyPaymentDetail> details = [];

    for (final subjectId in student.subjectIds) {

      final fee =
          _calculator.getStudentFee(
        settings,
        subjectId,
      );

      details.add(
        _calculator.createStudentDetail(
          subjectId: subjectId,
          subjectName:
              student.subjectNames[subjectId] ??
                  "",
          monthlyFee: fee,
        ),
      );
    }

    final payment =
        _calculator.createMonthlyPayment(
      userId: student.studentId,
      userName: student.studentName,
      role: UserRole.student,
      month: month,
      year: year,
      details: details,
      dueDate: dueDate,
    );

    await _repository.savePayment(payment);
  }
}