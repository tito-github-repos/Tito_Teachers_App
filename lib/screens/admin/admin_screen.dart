import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.instance;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      drawer: Drawer(
        child: Column(
          children: [
        
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4F46E5),
                    Color(0xff6366F1),
                  ],
                ),
              ),
              child: Column(
                children: [
        
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Colors.indigo,
                      size: 40,
                    ),
                  ),
        
                  const SizedBox(height: 15),
        
                  Text(
                    auth.user?.name ?? "Administrator",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
        
                  const SizedBox(height: 5),
        
                  const Text(
                    "Tito Administrator",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
        
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),
        
ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Teachers"),
              onTap: () {
                Get.toNamed(AppRoutes.teachersList);
              },
            ),  
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Students"),
              onTap: () {
                Get.toNamed(AppRoutes.studentsList);
              },
            ),  

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                // await auth.logout();
                // Get.offAllNamed(AppRoutes.login);


                 Navigator.pop(context);
      
              final logout =
                  await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text(
                    "Are you sure you want to logout?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(
                              context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor:
                            Colors.white,
                      ),
                      onPressed: () =>
                          Navigator.pop(
                              context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
      
              if (logout == true) {
                await auth.logout();
                Get.offAllNamed(
                  AppRoutes.login,
                );
              }
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: .70,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [

                _managementBox(
                  title: "Teachers",
                  icon: Icons.people,
                  color: Colors.blue,
                  onTap: () {
                    Get.toNamed(AppRoutes.teachersList);
                  },
                ),

                _managementBox(
                  title: "Students",
                  icon: Icons.school,
                  color: Colors.green,
                  onTap: () {
                    Get.toNamed(AppRoutes.studentsList);
                  },
                ),

                _managementBox(
                  title: "Topics",
                  icon: Icons.menu_book,
                  color: Colors.orange,
                  onTap: () {
                    Get.toNamed(AppRoutes.topics);
                  },
                ),

                _managementBox(
                  title: "Payments",
                  icon: Icons.payments,
                  color: Colors.purple,
                  onTap: () {
                    Get.toNamed(AppRoutes.paymentsSettings);
                  },
                ),

                _managementBox(
  title: "Teacher Payments",
  icon: Icons.payments,
  color: Colors.teal,
  onTap: () {
    Get.toNamed(AppRoutes.teacherPayments);
  },
),

_managementBox(
  title: "Student Payments",
  icon: Icons.account_balance_wallet,
  color: Colors.redAccent,
  onTap: () {
    Get.toNamed(AppRoutes.studentPayments);
  },
),

_managementBox(
  title: "Payment Reports",
  icon: Icons.history,
  color: Colors.brown,
  onTap: () {
    Get.toNamed(AppRoutes.paymentReport);
  },)

              
              ],
            ),

          ],
        ),
      ),
    );
  }

Widget _managementBox({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    elevation: 4,
    shadowColor: Colors.black12,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 34,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Manage",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Open",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}