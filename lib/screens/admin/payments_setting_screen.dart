import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/payment_controller.dart';
import '../../controllers/subject_controller.dart';
import '../../models/payment_setting_model.dart';
import '../../models/subjects_model.dart';

class PaymentSettingsScreen extends StatelessWidget {
  PaymentSettingsScreen({Key? key}) : super(key: key);

  final PaymentController controller =
      Get.put(PaymentController());

  final SubjectController subjectController =
      Get.find<SubjectController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Settings",
        ),
centerTitle: true,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSettingDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

       if (controller.paymentSettings.isEmpty) {
  return _buildEmptyState(context);
}

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount:
              controller.paymentSettings.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final setting =
                controller.paymentSettings[index];

            return _buildSettingCard(
              context,
              setting,
            );
          },
        );
      }),
    );
  }

  Widget _buildSettingCard(
    BuildContext context,
    PaymentSettingModel setting,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                const Icon(
                  Icons.menu_book,
                  color: Colors.blue,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    setting.subjectName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case "edit":
                        _showSettingDialog(
                          context,
                          setting: setting,
                        );
                        break;

                      case "delete":
                       _deleteSetting(
  context,
  setting,
);
                        break;
                    }
                  },
                  itemBuilder: (_) => const [

                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [

                          Icon(Icons.edit),

                          SizedBox(width: 10),

                          Text("Edit"),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [

                          Icon(Icons.delete),

                          SizedBox(width: 10),

                          Text("Delete"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                const Icon(
                  Icons.timer,
                  color: Colors.green,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "Teacher Rate / Hour",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),

                Text(
                  "₹ ${setting.teacherRatePerHour}",
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                const Icon(
                  Icons.school,
                  color: Colors.orange,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "Student Monthly Fee",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),

                Text(
                  "₹ ${setting.studentMonthlyFee}",
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Align(
              alignment:
                  Alignment.centerRight,
              child: Chip(
                backgroundColor:
                    setting.isActive
                        ? Colors.green
                            .withOpacity(0.15)
                        : Colors.red
                            .withOpacity(0.15),
                label: Text(
                  setting.isActive
                      ? "Active"
                      : "Inactive",
                  style: TextStyle(
                    color: setting.isActive
                        ? Colors.green
                        : Colors.red,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
    Future<void> _showSettingDialog(
    BuildContext context, {
    PaymentSettingModel? setting,
  }) async {
    final formKey = GlobalKey<FormState>();

    SubjectModel? selectedSubject;

    if (setting != null) {
      try {
        selectedSubject = subjectController.activeSubjects.firstWhere(
          (e) => e.id == setting.subjectId,
        );
      } catch (_) {}
    }

    final teacherRateController = TextEditingController(
      text: setting == null
          ? ''
          : setting.teacherRatePerHour.toString(),
    );

    final studentFeeController = TextEditingController(
      text: setting == null
          ? ''
          : setting.studentMonthlyFee.toString(),
    );

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                setting == null
                    ? "Add Payment Setting"
                    : "Edit Payment Setting",
              ),
              content: SizedBox(
                width: 450,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        /// Subject Dropdown
                        DropdownButtonFormField<SubjectModel>(
                          value: selectedSubject,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "Subject",
                            border: OutlineInputBorder(),
                          ),
                          items: subjectController.activeSubjects
                              .map(
                                (subject) => DropdownMenuItem(
                                  value: subject,
                                  child: Text(
                                    "${subject.name} (${subject.code})",
                                  ),
                                ),
                              )
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Please select subject";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedSubject = value;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        /// Teacher Rate
                        TextFormField(
                          controller: teacherRateController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText:
                                "Teacher Rate Per Hour",
                            prefixText: "₹ ",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return "Enter teacher rate";
                            }

                            if (double.tryParse(value) ==
                                null) {
                              return "Invalid amount";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        /// Student Monthly Fee
                        TextFormField(
                          controller: studentFeeController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText:
                                "Student Monthly Fee",
                            prefixText: "₹ ",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return "Enter monthly fee";
                            }

                            if (double.tryParse(value) ==
                                null) {
                              return "Invalid amount";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(
                    setting == null
                        ? "Save"
                        : "Update",
                  ),
                  onPressed: () async {
                    if (!formKey.currentState!
                        .validate()) {
                      return;
                    }

                    if (selectedSubject == null) {
                      Get.snackbar(
                        "Error",
                        "Please select a subject",
                        snackPosition:
                            SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    final model = PaymentSettingModel(
                      id: setting?.id ??
                          selectedSubject!.id,

                      subjectId:
                          selectedSubject!.id,

                      subjectName:
                          selectedSubject!.name,

                      teacherRatePerHour:
                          double.parse(
                        teacherRateController.text
                            .trim(),
                      ),

                      studentMonthlyFee:
                          double.parse(
                        studentFeeController.text
                            .trim(),
                      ),

                      isActive: true,

                      createdAt:
                          setting?.createdAt ??
                              DateTime.now(),

                      updatedAt: DateTime.now(),
                    );

                    await controller.saveSetting(
                      model,
                    );

                    Get.back();

                    Get.snackbar(
                      "Success",
                      setting == null
                          ? "Payment Setting Added Successfully"
                          : "Payment Setting Updated Successfully",
                      snackPosition:
                          SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
    /// ==========================================================
  /// Delete Setting
  /// ==========================================================

  Future<void> _deleteSetting(
    BuildContext context,
    PaymentSettingModel setting,
  ) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Payment Setting"),
        content: Text(
          "Are you sure you want to delete the payment setting for '${setting.subjectName}'?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await controller.deleteSetting(setting.id);

    Get.snackbar(
      "Success",
      "Payment Setting Deleted Successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// ==========================================================
  /// Empty State
  /// ==========================================================

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payments_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              "No Payment Settings Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Create payment settings for each subject.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                _showSettingDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Payment Setting"),
            ),
          ],
        ),
      ),
    );
  }
}