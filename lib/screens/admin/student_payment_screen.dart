import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/enums.dart';
import '../../controllers/payment_controller.dart';
import '../../models/monthly_payment_model.dart';

class StudentPaymentsScreen extends StatelessWidget {
  StudentPaymentsScreen({super.key});

  final PaymentController controller =
      Get.find<PaymentController>();

  final RxString search = ''.obs;

  @override
  Widget build(BuildContext context) {
    controller.changeRole(UserRole.student);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Payments",
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          _buildFilters(),

          Expanded(
            child: Obx(() {

              final payments =
                  controller.filteredPayments
                      .where(
                        (payment) => payment
                            .userName
                            .toLowerCase()
                            .contains(
                              search.value
                                  .toLowerCase(),
                            ),
                      )
                      .toList();

              if (payments.isEmpty) {
                return const Center(
                  child: Text(
                    "No Student Payments Found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.listenPayments();
                },
                child: ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount: payments.length,
                  itemBuilder:
                      (context, index) {
                    return _buildPaymentCard(
                      context,
                      payments[index],
                    );
                  },
                ),
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
              hintText: "Search Student",
              border: OutlineInputBorder(),
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
                  value: controller.selectedMonth.value,
                  decoration: const InputDecoration(
                    labelText: "Month",
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("${index + 1}"),
                    ),
                  ),
                  onChanged: (value) {
                    controller.changeMonth(value!);
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: DropdownButtonFormField<PaymentStatus?>(
                  value: controller.selectedStatus.value,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: [

                    const DropdownMenuItem(
                      value: null,
                      child: Text("All"),
                    ),

                    ...PaymentStatus.values.map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    controller.changeStatus(value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton.icon(
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.payments),
                label: const Text(
                  "Generate Student Payments",
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                      final dueDate = DateTime(
  controller.selectedYear.value,
  controller.selectedMonth.value,
  5,
);
                        await controller.generateAllStudentPayments(
                          dueDate: dueDate
                        );
                      },
              ),
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
              "Month : ${payment.month}/${payment.year}",
            ),

            const SizedBox(height: 5),

            Text(
              "Subjects : ${payment.details.length}",
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
            "Subject Fee Details",
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
                  child: Icon(
                    Icons.menu_book,
                  ),
                ),

                title: Text(
                  detail.subjectName,
                ),

                subtitle: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Monthly Fee : ₹${detail.monthlyFee.toStringAsFixed(2)}",
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "Amount : ₹${detail.amount.toStringAsFixed(2)}",
                    ),
                  ],
                ),

                trailing: Text(
                  "₹${detail.amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
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
              "Student",
              payment.userName,
            ),

            _infoRow(
              "Month",
              "${payment.month}/${payment.year}",
            ),

            _infoRow(
              "Subjects",
              payment.details.length.toString(),
            ),

            _infoRow(
              "Status",
              payment.status.toUpperCase(),
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
    padding: const EdgeInsets.symmetric(
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
                items: PaymentMode.values
                    .map(
                      (mode) =>
                          DropdownMenuItem(
                        value: mode,
                        child: Text(
                          mode.name,
                        ),
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

            await controller.markAsPaid(

              paymentId: payment.id,

              paymentMode:
                  paymentMode!,

              referenceNumber:
                  referenceController
                      .text
                      .trim(),

              remarks:
                  remarksController
                      .text
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
}}