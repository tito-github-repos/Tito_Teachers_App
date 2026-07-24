import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/enums.dart';
import '../../../controllers/payment_controller.dart';
import '../../../models/monthly_payment_model.dart';

class PaymentReportsScreen extends StatelessWidget {
  PaymentReportsScreen({super.key});

  final PaymentController controller =
      Get.find<PaymentController>();

  final RxString search = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Reports"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          _buildFilters(),

          Expanded(
            child: Obx(() {

              final reports = controller.filteredPayments
                  .where(
                    (payment) =>
                        payment.userName
                            .toLowerCase()
                            .contains(
                              search.value
                                  .toLowerCase(),
                            ),
                  )
                  .toList();

              if (reports.isEmpty) {
                return const Center(
                  child: Text(
                    "No Payment Reports Found",
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
                  itemCount: reports.length,
                  itemBuilder:
                      (context, index) {
                    return _buildReportCard(
                      context,
                      reports[index],
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

        ///---------------------------------------------------
        /// SEARCH
        ///---------------------------------------------------
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Search Teacher / Student",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            search.value = value;
          },
        ),

        const SizedBox(height: 15),

        ///---------------------------------------------------
        /// MONTH
        /// ROLE
        ///---------------------------------------------------
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
              child:
                  DropdownButtonFormField<
                      UserRole?>(
                value:
                    controller.selectedRole.value,
                decoration:
                    const InputDecoration(
                  labelText: "Role",
                  border:
                      OutlineInputBorder(),
                ),
                items: [

                  const DropdownMenuItem(
                    value: null,
                    child: Text("All"),
                  ),

                  ...UserRole.values.map(
                    (role) =>
                        DropdownMenuItem(
                      value: role,
                      child: Text(
                        role.name
                            .toUpperCase(),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  controller.changeRole(value);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        ///---------------------------------------------------
        /// STATUS
        ///---------------------------------------------------
        DropdownButtonFormField<
            PaymentStatus?>(
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
              (status) =>
                  DropdownMenuItem(
                value: status,
                child: Text(
                  status.name.toUpperCase(),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            controller.changeStatus(value);
          },
        ),

        const SizedBox(height: 20),

        ///---------------------------------------------------
        /// SUMMARY
        ///---------------------------------------------------
        Obx(
          () {

            final reports =
                controller.filteredPayments;

            final totalAmount = reports.fold(
              0.0,
              (sum, item) =>
                  sum + item.totalAmount,
            );

            final paidAmount = reports
                .where(
                  (e) =>
                      e.status ==
                      PaymentStatus
                          .paid.value,
                )
                .fold(
                  0.0,
                  (sum, item) =>
                      sum +
                      item.totalAmount,
                );

            final pendingAmount = reports
                .where(
                  (e) =>
                      e.status ==
                      PaymentStatus
                          .pending.value,
                )
                .fold(
                  0.0,
                  (sum, item) =>
                      sum +
                      item.totalAmount,
                );

            return Row(
  children: [
    Expanded(
      child: _summaryCard(
        "Records",
        reports.length.toString(),
        Colors.blue,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _summaryCard(
        "Paid",
        "₹${paidAmount.toStringAsFixed(2)}",
        Colors.green,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _summaryCard(
        "Pending",
        "₹${pendingAmount.toStringAsFixed(2)}",
        Colors.orange,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _summaryCard(
        "Total",
        "₹${totalAmount.toStringAsFixed(2)}",
        Colors.deepPurple,
      ),
    ),
  ],
);
          },
        ),
      ],
    ),
  );
}

Widget _summaryCard(
  String title,
  String value,
  Color color,
) {
  return SizedBox(
    height: 110, // Fixed height
    child: Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget _buildReportCard(
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
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          ///---------------------------------------------------
          /// HEADER
          ///---------------------------------------------------

          Row(
            children: [

              CircleAvatar(
                radius: 25,
                child: Icon(
                  payment.role ==
                          UserRole.teacher.value
                      ? Icons.school
                      : Icons.person,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      payment.userName,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      payment.role
                          .toUpperCase(),
                      style:
                          const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Chip(
                backgroundColor: isPaid
                    ? Colors.green.shade100
                    : isPending
                        ? Colors.orange
                            .shade100
                        : Colors.red
                            .shade100,
                label: Text(
                  payment.status
                      .toUpperCase(),
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color: isPaid
                        ? Colors.green
                        : isPending
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 25),

          ///---------------------------------------------------
          /// DETAILS
          ///---------------------------------------------------

          Row(
            children: [

              Expanded(
                child: _reportInfo(
                  "Month",
                  "${payment.month}/${payment.year}",
                ),
              ),

              Expanded(
                child: _reportInfo(
                  "Subjects",
                  payment.details.length
                      .toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: _reportInfo(
                  "Amount",
                  "₹${payment.totalAmount.toStringAsFixed(2)}",
                ),
              ),

              Expanded(
                child: _reportInfo(
                  "Payment",
                  payment.paymentMode
                          .isEmpty
                      ? "-"
                      : payment
                          .paymentMode,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ///---------------------------------------------------
          /// BUTTONS
          ///---------------------------------------------------

          Row(
            children: [

              Expanded(
                child:
                    OutlinedButton.icon(
                  icon: const Icon(
                    Icons.visibility,
                  ),
                  label: const Text(
                    "View Details",
                  ),
                  onPressed: () {
                    _showPaymentDetails(
                      context,
                      payment,
                    );
                  },
                ),
              ),

              if (!isPaid) ...[

                const SizedBox(width: 10),

                Expanded(
                  child:
                      ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check,
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
            ],
          ),
        ],
      ),
    ),
  );
}

///---------------------------------------------------
/// REPORT INFO
///---------------------------------------------------

Widget _reportInfo(
  String title,
  String value,
) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [

      Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),

      const SizedBox(height: 4),

      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ],
  );
}
///==============================================================
/// PAYMENT DETAILS
///==============================================================

void _showPaymentDetails(
  BuildContext context,
  MonthlyPaymentModel payment,
) {
  Get.dialog(
    AlertDialog(
      title: const Text("Payment Details"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              _infoRow(
                "Name",
                payment.userName,
              ),

              _infoRow(
                "Role",
                payment.role.toUpperCase(),
              ),

              _infoRow(
                "Month",
                "${payment.month}/${payment.year}",
              ),

              _infoRow(
                "Status",
                payment.status.toUpperCase(),
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
                "Recorded By",
                payment.recordedBy.isEmpty
                    ? "-"
                    : payment.recordedBy,
              ),

              _infoRow(
                "Remarks",
                payment.remarks.isEmpty
                    ? "-"
                    : payment.remarks,
              ),

              const SizedBox(height: 20),

              const Text(
                "Subject Details",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ...payment.details.map(
                (detail) {
                  return Card(
                    elevation: 0,
                    color: Colors.grey.shade100,
                    margin:
                        const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: ListTile(
                      leading:
                          const CircleAvatar(
                        child: Icon(
                          Icons.menu_book,
                        ),
                      ),

                      title: Text(
                        detail.subjectName,
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [

                          if (payment.role ==
                              UserRole.teacher
                                  .value) ...[
                            Text(
                              "Minutes : ${detail.minutes}",
                            ),

                            Text(
                              "Rate : ₹${detail.rate.toStringAsFixed(2)}",
                            ),
                          ] else ...[
                            Text(
                              "Monthly Fee : ₹${detail.monthlyFee.toStringAsFixed(2)}",
                            ),
                          ],
                        ],
                      ),

                      trailing: Text(
                        "₹${detail.amount.toStringAsFixed(2)}",
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const Divider(),

              Align(
                alignment:
                    Alignment.centerRight,
                child: Text(
                  "Total : ₹${payment.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
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
          child: const Text("Close"),
        ),
      ],
    ),
  );
}
///==============================================================
/// INFO ROW
///==============================================================

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

///==============================================================
/// MARK PAID
///==============================================================

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

            await controller.markAsPaid(
              paymentId: payment.id,
              paymentMode:
                  paymentMode!,
              referenceNumber:
                  referenceController.text
                      .trim(),
              remarks:
                  remarksController.text
                      .trim(),
              recordedBy: "Admin",
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