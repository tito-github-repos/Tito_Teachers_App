import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tito_teachers_app/constants/enums.dart';

import '../models/monthly_payment_model.dart';

class MonthlyPaymentRepository {
  MonthlyPaymentRepository._();

  static final MonthlyPaymentRepository instance =
      MonthlyPaymentRepository._();

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static const String collection =
      "monthly_payments";

  /// ---------------------------------------------------------------------------
  /// GET ALL PAYMENTS
  /// ---------------------------------------------------------------------------

  Stream<List<MonthlyPaymentModel>> getAllPayments() {
    return _db
        .collection(collection)
        .orderBy("year", descending: true)
        .orderBy("month", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MonthlyPaymentModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// ---------------------------------------------------------------------------
  /// GET PAYMENTS BY ROLE
  /// ---------------------------------------------------------------------------

  Stream<List<MonthlyPaymentModel>> getPaymentsByRole(
    UserRole role,
  ) {
    return _db
        .collection(collection)
        .where(
          "role",
          isEqualTo: role.value,
        )
        .orderBy("year", descending: true)
        .orderBy("month", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MonthlyPaymentModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// ---------------------------------------------------------------------------
  /// GET USER HISTORY
  /// ---------------------------------------------------------------------------

  Stream<List<MonthlyPaymentModel>> getUserHistory(
    String userId,
  ) {
    return _db
        .collection(collection)
        .where(
          "userId",
          isEqualTo: userId,
        )
        .orderBy("year", descending: true)
        .orderBy("month", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MonthlyPaymentModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// ---------------------------------------------------------------------------
  /// GET SINGLE MONTH
  /// ---------------------------------------------------------------------------

  Future<MonthlyPaymentModel?> getMonthlyPayment({
    required String userId,
    required int month,
    required int year,
  }) async {

    final id =
        "${userId}_${year}_${month.toString().padLeft(2, '0')}";

    final doc = await _db
        .collection(collection)
        .doc(id)
        .get();

    if (!doc.exists) return null;

    return MonthlyPaymentModel.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  /// ---------------------------------------------------------------------------
  /// SAVE
  /// ---------------------------------------------------------------------------

  Future<void> savePayment(
    MonthlyPaymentModel payment,
  ) async {

    await _db
        .collection(collection)
        .doc(payment.id)
        .set(payment.toMap());
  }

  /// ---------------------------------------------------------------------------
  /// UPDATE
  /// ---------------------------------------------------------------------------

  Future<void> updatePayment(
    MonthlyPaymentModel payment,
  ) async {

    await _db
        .collection(collection)
        .doc(payment.id)
        .update(payment.toMap());
  }

  /// ---------------------------------------------------------------------------
  /// DELETE
  /// ---------------------------------------------------------------------------

  Future<void> deletePayment(
    String id,
  ) async {

    await _db
        .collection(collection)
        .doc(id)
        .delete();
  }

  /// ---------------------------------------------------------------------------
  /// MARK PAID
  /// ---------------------------------------------------------------------------

  Future<void> markAsPaid({
    required String paymentId,
    required PaymentMode paymentMode,
    required DateTime paidDate,
    required String referenceNumber,
    required String remarks,
    required String recordedBy,
  }) async {

    await _db
        .collection(collection)
        .doc(paymentId)
        .update({

      "status": PaymentStatus.paid.value,

      "paymentMode": paymentMode.value,

      "paidDate": Timestamp.fromDate(
        paidDate,
      ),

      "referenceNumber": referenceNumber,

      "remarks": remarks,

      "recordedBy": recordedBy,

      "updatedAt": Timestamp.now(),
    });
  }

  /// ---------------------------------------------------------------------------
  /// MARK OVERDUE
  /// ---------------------------------------------------------------------------

  Future<void> markAsOverdue(
    String paymentId,
  ) async {

    await _db
        .collection(collection)
        .doc(paymentId)
        .update({

      "status":
          PaymentStatus.overdue.value,

      "updatedAt": Timestamp.now(),
    });
  }

  /// ---------------------------------------------------------------------------
  /// CHECK MONTH EXISTS
  /// ---------------------------------------------------------------------------

  Future<bool> paymentExists({
    required String userId,
    required int month,
    required int year,
  }) async {

    final id =
        "${userId}_${year}_${month.toString().padLeft(2, '0')}";

    final doc = await _db
        .collection(collection)
        .doc(id)
        .get();

    return doc.exists;
  }
}