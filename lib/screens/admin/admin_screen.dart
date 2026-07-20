import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> items = [
      _DashboardItem(
        title: "Teachers",
        icon: Icons.person,
        color: Colors.blue,
        onTap: () {
          Get.toNamed(AppRoutes.teachersList);
        },
      ),
      _DashboardItem(
        title: "Students",
        icon: Icons.groups,
        color: Colors.green,
        onTap: () {
          Get.toNamed(AppRoutes.studentsList);
        },
      ),
      _DashboardItem(
        title: "Import Excel",
        icon: Icons.upload_file,
        color: Colors.orange,
        onTap: () {
          Get.snackbar(
            "Coming Soon",
            "Excel import will be added once the format is finalized.",
          );
        },
      ),
      _DashboardItem(
        title: "Payments",
        icon: Icons.payments,
        color: Colors.purple,
        onTap: () {
          Get.toNamed(AppRoutes.payments);
        },
      ),
      _DashboardItem(
        title: "Reports",
        icon: Icons.bar_chart,
        color: Colors.red,
        onTap: () {
          Get.toNamed(AppRoutes.reports);
          },
      ),
      _DashboardItem(
        title: "Logout",
        icon: Icons.logout,
        color: Colors.black54,
        onTap: () {
          Get.defaultDialog(
            title: "Logout",
            middleText: "Are you sure you want to logout?",
            textCancel: "Cancel",
            textConfirm: "Logout",
            onConfirm: () {
              Get.back();
              // Call AuthController.logout() here later
            },
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: item.onTap,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: item.color.withOpacity(.1),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}