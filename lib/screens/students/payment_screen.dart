import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/constants/date_helper.dart';

import '../../constants/enums.dart';
import '../../controllers/payment_controller.dart';
import '../../models/monthly_payment_model.dart';

class StudentMyPaymentsScreen extends StatelessWidget {
  StudentMyPaymentsScreen({super.key});

  final PaymentController controller =
      Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {

    controller.loadCurrentUserPayments(
      UserRole.student,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Payments"),
        centerTitle: true,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      ),

      body: Obx(() {

        final payments =
            controller.userPayments;

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (payments.isEmpty) {
          return const Center(
            child: Text(
              "No Payments Found",
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadCurrentUserPayments(
              UserRole.student,
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: payments.length,
            itemBuilder: (_, index) {
              return _buildPaymentCard(
                context,
                payments[index],
              );
            },
          ),
        );
      }),
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
)}",
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

        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(
              Icons.receipt_long,
            ),
            label: const Text(
              "Payment Details",
            ),
            onPressed: () {
              _showPaymentInfo(
                context,
                payment,
              );
            },
          ),
        ),

        const SizedBox(height: 10),
      ],
    ),
  );
}
///==============================================================
/// PAYMENT DETAILS
///==============================================================

void _showPaymentInfo(
  BuildContext context,
  MonthlyPaymentModel payment,
) {
  Get.dialog(
    AlertDialog(
      title: const Text("Payment Details"),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              _infoRow(
                "Student",
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
                "Total Subjects",
                payment.details.length.toString(),
              ),

              _infoRow(
                "Total Amount",
                "₹${payment.totalAmount.toStringAsFixed(2)}",
              ),

              _infoRow(
                "Due Date",
                payment.dueDate == null
                    ? "-"
                    : DateHelper.formatDate(
  payment.dueDate,
)
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

              const SizedBox(height: 15),

              const Divider(),

              const Text(
                "Subject Fee Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              ...payment.details.map(
                (detail) {
                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.menu_book,
                      ),

                      title: Text(
                        detail.subjectName,
                      ),

                      subtitle: Text(
                        "Monthly Fee : ₹${detail.monthlyFee.toStringAsFixed(2)}",
                      ),

                      trailing: Text(
                        "₹${detail.amount.toStringAsFixed(2)}",
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
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
          width: 130,
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
}}