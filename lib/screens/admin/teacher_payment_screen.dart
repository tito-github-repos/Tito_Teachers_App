import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/constants/date_helper.dart';
import 'package:tito_teachers_app/constants/enums.dart';

import '../../controllers/payment_controller.dart';
import '../../models/monthly_payment_model.dart';

class TeacherPaymentsScreen extends StatelessWidget {
  TeacherPaymentsScreen({super.key});

  final PaymentController controller =
      Get.find<PaymentController>();

  final RxString search = ''.obs;

  @override
  Widget build(BuildContext context) {
    controller.changeRole(UserRole.teacher);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Payments"),
        centerTitle: true,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          _buildFilters(),

          Expanded(
            child: Obx(() {

              final payments = controller.filteredPayments
                  .where(
                    (e) => e.userName
                        .toLowerCase()
                        .contains(
                          search.value.toLowerCase(),
                        ),
                  )
                  .toList();

              if (payments.isEmpty) {
                return const Center(
                  child: Text(
                    "No Teacher Payments Found",
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.all(16),
                itemCount: payments.length,
                itemBuilder: (_, index) {
                  return _buildPaymentCard(
                    context,
                    payments[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [

          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search Teacher",
            ),
            onChanged: (value) {
              search.value = value;
            },
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: DropdownButtonFormField<int>(
                  value:
                      controller.selectedMonth.value,
                  decoration:
                      const InputDecoration(
                    labelText: "Month",
                  ),
              items: List.generate(
  12,
  (index) => DropdownMenuItem(
    value: index + 1,
    child: Text(
      DateHelper.shortMonth(index + 1),
    ),
  ),
),
                  onChanged: (value) {
                    controller.changeMonth(
                        value!);
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child:
                    DropdownButtonFormField<
                        PaymentStatus?>(
                  value:
                      controller.selectedStatus.value,
                  decoration:
                      const InputDecoration(
                    labelText: "Status",
                  ),
                  items: [

                    const DropdownMenuItem(
                      value: null,
                      child: Text("All"),
                    ),

                    ...PaymentStatus.values.map(
                      (status) =>
                          DropdownMenuItem(
                        value: status,
                        child: Text(
                          status.name,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    controller.changeStatus(
                        value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.payments),
    label: const Text("Generate Teacher Payments"),
    onPressed: () async {
      await controller.generateAllTeacherPayments();
    },
  ),
),
        ],
      ),
    );
  }
    Widget _buildPaymentCard(
    BuildContext context,
    MonthlyPaymentModel payment,
  ) {
    final bool isPaid =
        payment.status == PaymentStatus.paid.value;

    final bool isPending =
        payment.status == PaymentStatus.pending.value;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        title: Text(
          payment.userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
"Month : ${DateHelper.monthYear(
  payment.month,
  payment.year,
)}"              ),

              const SizedBox(height: 5),

              Text(
                "Total Minutes : ${payment.totalMinutes}",
              ),

              const SizedBox(height: 5),

              Text(
                "Total Amount : ₹${payment.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        trailing: Chip(
          backgroundColor: isPaid
              ? Colors.green.shade100
              : isPending
                  ? Colors.orange.shade100
                  : Colors.red.shade100,
          label: Text(
            payment.status.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPaid
                  ? Colors.green
                  : isPending
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
        ),

        childrenPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        children: [

          const Divider(),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Subject Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          ...payment.details.map(
            (detail) {
              return Card(
                elevation: 0,
                color: Colors.grey.shade100,
                margin: const EdgeInsets.only(
                  bottom: 8,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.menu_book),
                  ),

                  title: Text(
                    detail.subjectName,
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Minutes : ${detail.minutes}",
                      ),

                      Text(
                        "Rate : ₹${detail.rate}",
                      ),
                    ],
                  ),

                  trailing: Text(
                    "₹${detail.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.receipt_long,
                  ),
                  label: const Text(
                    "Payment Info",
                  ),
                  onPressed: () {
                    _showPaymentInfo(
                      context,
                      payment,
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              if (!isPaid)
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check_circle,
                    ),
                    label: const Text(
                      "Mark Paid",
                    ),
                    onPressed: () {
                      _showMarkPaidDialog(
                        context,
                        payment,
                      );
                    },
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
    /// ==========================================================
  /// PAYMENT INFO
  /// ==========================================================

  void _showPaymentInfo(
    BuildContext context,
    MonthlyPaymentModel payment,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text("Payment Information"),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              _infoRow(
                "Teacher",
                payment.userName,
              ),

             _infoRow(
  "Month",
  DateHelper.monthYear(
    payment.month,
    payment.year,
  ),
),

              _infoRow(
                "Status",
                payment.status.toUpperCase(),
              ),

              _infoRow(
                "Total Minutes",
                payment.totalMinutes.toString(),
              ),

              _infoRow(
                "Total Amount",
                "₹${payment.totalAmount.toStringAsFixed(2)}",
              ),

              _infoRow(
                "Payment Mode",
                payment.paymentMode.isEmpty
                    ? "-"
                    : payment.paymentMode,
              ),

              _infoRow(
                "Reference",
                payment.referenceNumber.isEmpty
                    ? "-"
                    : payment.referenceNumber,
              ),

              _infoRow(
                "Remarks",
                payment.remarks.isEmpty
                    ? "-"
                    : payment.remarks,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// ==========================================================
  /// MARK PAID
  /// ==========================================================

  Future<void> _showMarkPaidDialog(
    BuildContext context,
    MonthlyPaymentModel payment,
  ) async {

    final formKey =
        GlobalKey<FormState>();

    PaymentMode? paymentMode;

    final referenceController =
        TextEditingController();

    final remarksController =
        TextEditingController();

    await Get.dialog(
      AlertDialog(
        title:
            const Text("Mark Payment Paid"),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [

                DropdownButtonFormField<
                    PaymentMode>(
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Payment Mode",
                  ),
                  items: PaymentMode
                      .values
                      .map(
                        (mode) =>
                            DropdownMenuItem(
                          value: mode,
                          child:
                              Text(mode.name),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Select payment mode";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    paymentMode = value;
                  },
                ),

                const SizedBox(
                  height: 15,
                ),

                TextFormField(
                  controller:
                      referenceController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Reference Number",
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                TextFormField(
                  controller:
                      remarksController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Remarks",
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [

          TextButton(
            onPressed: () {
              Get.back();
            },
            child:
                const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {

              if (!formKey
                  .currentState!
                  .validate()) {
                return;
              }

              await controller
                  .markAsPaid(

                paymentId: payment.id,

                paymentMode:
                    paymentMode!,

                referenceNumber:
                    referenceController.text
                        .trim(),

                remarks:
                    remarksController.text
                        .trim(),

                recordedBy:
                    "Admin",
              );

              Get.back();

              Get.snackbar(
                "Success",
                "Payment marked as Paid",
                snackPosition:
                    SnackPosition.BOTTOM,
              );
            },
            child:
                const Text("Save"),
          ),
        ],
      ),
    );
  }
}