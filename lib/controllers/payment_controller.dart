import 'dart:async';

import 'package:get/get.dart';
import 'package:tito_teachers_app/constants/enums.dart';
import 'package:tito_teachers_app/repositories/auth_repo.dart';
import 'package:tito_teachers_app/repositories/monthly_payment_repo.dart';
import 'package:tito_teachers_app/repositories/payment_repo.dart';
import 'package:tito_teachers_app/repositories/student_payment_repo.dart';
import 'package:tito_teachers_app/repositories/teacher_payment_repo.dart';
import 'package:tito_teachers_app/services/monthly_payment_generate.dart';

import '../models/monthly_payment_model.dart';
import '../models/payment_setting_model.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  final PaymentSettingRepository _settingRepository =
      PaymentSettingRepository.instance;

  final MonthlyPaymentRepository _paymentRepository =
      MonthlyPaymentRepository.instance;

  final MonthlyPaymentGenerator _generator =
      MonthlyPaymentGenerator.instance;
final StudentPaymentRepository _studentRepository =
    StudentPaymentRepository.instance;
    final TeacherPaymentRepository _teacherRepository =
    TeacherPaymentRepository.instance;
  /// ---------------------------------------------------------------------------
  /// OBSERVABLES
  /// ---------------------------------------------------------------------------

  final RxBool isLoading = false.obs;

  final RxList<PaymentSettingModel> paymentSettings =
      <PaymentSettingModel>[].obs;

  final RxList<MonthlyPaymentModel> monthlyPayments =
      <MonthlyPaymentModel>[].obs;

  final Rx<PaymentStatus?> selectedStatus =
      Rx<PaymentStatus?>(null);

  final Rx<UserRole?> selectedRole =
      Rx<UserRole?>(null);

  final RxInt selectedMonth =
      DateTime.now().month.obs;

  final RxInt selectedYear =
      DateTime.now().year.obs;

  final RxDouble totalPending = 0.0.obs;
  final RxDouble totalPaid = 0.0.obs;
  final RxDouble totalCollection = 0.0.obs;

  StreamSubscription? _settingSubscription;
  StreamSubscription? _paymentSubscription;
final AuthRepository _authRepository =
    AuthRepository.instance;

final RxList<MonthlyPaymentModel> userPayments =
    <MonthlyPaymentModel>[].obs;

StreamSubscription<List<MonthlyPaymentModel>>?
    _userPaymentSubscription;
  @override
  void onInit() {
    super.onInit();

    listenPaymentSettings();
    listenPayments();
  }

  @override
  Future<void> onClose() async {
    _settingSubscription?.cancel();
    _paymentSubscription?.cancel();
await _userPaymentSubscription?.cancel();
    super.onClose();
  }

  /// ---------------------------------------------------------------------------
  /// SETTINGS
  /// ---------------------------------------------------------------------------

  void listenPaymentSettings() {
    _settingSubscription?.cancel();

    _settingSubscription = _settingRepository
        .getAllSettings()
        .listen((event) {
      paymentSettings.assignAll(event);
    });
  }

  Future<void> saveSetting(
      PaymentSettingModel model) async {
    isLoading.value = true;

    try {
      await _settingRepository.saveOrUpdate(model);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSetting(String id) async {
    isLoading.value = true;

    try {
      await _settingRepository.deleteSetting(id);
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------------------------------------------------------------------
  /// PAYMENTS
  /// ---------------------------------------------------------------------------

  void listenPayments() {
    _paymentSubscription?.cancel();

    _paymentSubscription =
        _paymentRepository.getAllPayments().listen(
      (event) {
        monthlyPayments.assignAll(event);

        calculateSummary();
      },
    );
  }

  /// ---------------------------------------------------------------------------
  /// FILTERS
  /// ---------------------------------------------------------------------------

  List<MonthlyPaymentModel> get filteredPayments {
    return monthlyPayments.where((payment) {
      if (payment.month != selectedMonth.value) {
        return false;
      }

      if (payment.year != selectedYear.value) {
        return false;
      }

      if (selectedRole.value != null &&
          payment.role != selectedRole.value!.value) {
        return false;
      }

      if (selectedStatus.value != null &&
          payment.status != selectedStatus.value!.value) {
        return false;
      }

      return true;
    }).toList();
  }

  /// ---------------------------------------------------------------------------
  /// SUMMARY
  /// ---------------------------------------------------------------------------

  void calculateSummary() {
    double paid = 0;
    double pending = 0;

    for (final payment in monthlyPayments) {
      if (payment.status ==
          PaymentStatus.paid.value) {
        paid += payment.totalAmount;
      } else {
        pending += payment.totalAmount;
      }
    }

    totalPaid.value = paid;
    totalPending.value = pending;
    totalCollection.value = paid + pending;
  }

  /// ---------------------------------------------------------------------------
  /// MARK PAID
  /// ---------------------------------------------------------------------------

  Future<void> markAsPaid({
    required String paymentId,
    required PaymentMode paymentMode,
    required String referenceNumber,
    required String remarks,
    required String recordedBy,
  }) async {
    isLoading.value = true;

    try {
      await _paymentRepository.markAsPaid(
        paymentId: paymentId,
        paymentMode: paymentMode,
        paidDate: DateTime.now(),
        referenceNumber: referenceNumber,
        remarks: remarks,
        recordedBy: recordedBy,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------------------------------------------------------------------
  /// GENERATE MONTHLY PAYMENTS
  /// ---------------------------------------------------------------------------

  Future<void> generateTeacherPayment({
    required TeacherMonthlyInput input,
    required DateTime dueDate,
  }) async {
    await _generator.generateTeacherPayment(
      teacher: input,
      settings: paymentSettings,
      month: selectedMonth.value,
      year: selectedYear.value,
      dueDate: dueDate,
    );
  }

  Future<void> generateStudentPayment({
    required StudentMonthlyInput input,
    required DateTime dueDate,
  }) async {
    await _generator.generateStudentPayment(
      student: input,
      settings: paymentSettings,
      month: selectedMonth.value,
      year: selectedYear.value,
      dueDate: dueDate,
    );
  }

  /// ---------------------------------------------------------------------------
  /// FILTER CHANGES
  /// ---------------------------------------------------------------------------

  void changeMonth(int month) {
    selectedMonth.value = month;
  }
 
  void changeYear(int year) {
    selectedYear.value = year;
  }

  void changeRole(UserRole? role) {
    selectedRole.value = role;
  }

  void changeStatus(PaymentStatus? status) {
    selectedStatus.value = status;
  }
  Future<void> generateAllStudentPayments({
  required DateTime dueDate,
}) async {
  isLoading.value = true;

  try {
    final students =
        await _studentRepository.getAllStudents();

    for (final student in students) {
      final input =
          await _studentRepository
              .buildStudentMonthlyInput(
        student,
      );

      await generateStudentPayment(
        input: input,
        dueDate: dueDate,
      );
    }

    Get.snackbar(
      "Success",
      "Student payments generated successfully.",
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
    );
  } finally {
    isLoading.value = false;
  }
}

List<MonthlyPaymentModel> get reportPayments {
  return monthlyPayments.where((payment) {

    if (payment.month != selectedMonth.value) {
      return false;
    }

    if (payment.year != selectedYear.value) {
      return false;
    }

    if (selectedRole.value != null &&
        payment.role != selectedRole.value!.value) {
      return false;
    }

    if (selectedStatus.value != null &&
        payment.status != selectedStatus.value!.value) {
      return false;
    }

    return true;

  }).toList();
}

double get reportTotal =>
    reportPayments.fold(
      0,
      (sum, e) => sum + e.totalAmount,
    );

double get reportPaid =>
    reportPayments
        .where(
          (e) =>
              e.status ==
              PaymentStatus.paid.value,
        )
        .fold(
          0,
          (sum, e) => sum + e.totalAmount,
        );

double get reportPending =>
    reportPayments
        .where(
          (e) =>
              e.status ==
              PaymentStatus.pending.value,
        )
        .fold(
          0,
          (sum, e) => sum + e.totalAmount,
        );

Future<void> generateAllTeacherPayments() async {

  try {

    isLoading.value = true;

    final teachers =
        await _teacherRepository
            .getTeacherMonthlyInputs(
      month: selectedMonth.value,
      year: selectedYear.value,
    );

    for (final teacher in teachers) {

      await _generator.generateTeacherPayment(

        teacher: teacher,

        settings: paymentSettings,

        month: selectedMonth.value,

        year: selectedYear.value,

        dueDate: DateTime(
          selectedYear.value,
          selectedMonth.value + 1,
          5,
        ),
      );
    }

    Get.snackbar(
      "Success",
      "Teacher payments generated successfully.",
    );

  } catch (e) {

    Get.snackbar(
      "Error",
      e.toString(),
    );

  } finally {

    isLoading.value = false;
  }
}
Future<void> loadCurrentUserPayments(
  UserRole role,
) async {

  final user =
      _authRepository.currentUser;

  if (user == null) return;

  isLoading.value = true;

  await _userPaymentSubscription?.cancel();

  _userPaymentSubscription =
        _paymentRepository
          .getUserHistory(user.uid)
          .listen((payments) {

    userPayments.assignAll(
      payments
          .where(
            (e) => e.role == role.value,
          )
          .toList(),
    );

    isLoading.value = false;
  });
}

}