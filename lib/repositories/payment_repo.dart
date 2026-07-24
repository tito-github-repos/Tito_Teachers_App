import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/payment_setting_model.dart';

class PaymentSettingRepository {
  PaymentSettingRepository._();

  static final PaymentSettingRepository instance =
      PaymentSettingRepository._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collection = "payment_settings";

  /// ---------------------------------------------------------------------------
  /// Get All Settings
  /// ---------------------------------------------------------------------------

  Stream<List<PaymentSettingModel>> getAllSettings() {
    return _db
        .collection(collection)
        .orderBy("subjectName")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PaymentSettingModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// ---------------------------------------------------------------------------
  /// Get Single Setting
  /// ---------------------------------------------------------------------------

  Future<PaymentSettingModel?> getSettingBySubject(
    String subjectId,
  ) async {
    final snapshot = await _db
        .collection(collection)
        .where("subjectId", isEqualTo: subjectId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return PaymentSettingModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Add Setting
  /// ---------------------------------------------------------------------------

  Future<void> addSetting(
    PaymentSettingModel setting,
  ) async {
    await _db
        .collection(collection)
        .doc(setting.id)
        .set(setting.toMap());
  }

  /// ---------------------------------------------------------------------------
  /// Update Setting
  /// ---------------------------------------------------------------------------

  Future<void> updateSetting(
    PaymentSettingModel setting,
  ) async {
    await _db
        .collection(collection)
        .doc(setting.id)
        .update(setting.toMap());
  }

  /// ---------------------------------------------------------------------------
  /// Delete Setting
  /// ---------------------------------------------------------------------------

  Future<void> deleteSetting(
    String id,
  ) async {
    await _db
        .collection(collection)
        .doc(id)
        .delete();
  }

  /// ---------------------------------------------------------------------------
  /// Check Subject Exists
  /// ---------------------------------------------------------------------------

  Future<bool> subjectExists(
    String subjectId,
  ) async {
    final snapshot = await _db
        .collection(collection)
        .where("subjectId", isEqualTo: subjectId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// ---------------------------------------------------------------------------
  /// Save or Update
  /// ---------------------------------------------------------------------------

  Future<void> saveOrUpdate(
    PaymentSettingModel setting,
  ) async {
    final exists = await subjectExists(
      setting.subjectId,
    );

    if (exists) {
      final snapshot = await _db
          .collection(collection)
          .where(
            "subjectId",
            isEqualTo: setting.subjectId,
          )
          .limit(1)
          .get();

      await snapshot.docs.first.reference.update(
        setting.toMap(),
      );
    } else {
      await _db
          .collection(collection)
          .doc(setting.id)
          .set(setting.toMap());
    }
  }
}