import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  Widget buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            const SizedBox(height: 10),

            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person,size:40),
            ),

            const SizedBox(height:20),

            const Text(
              "Welcome",
              style: TextStyle(fontSize:16),
            ),

            const Text(
              "Teacher",
              style: TextStyle(
                fontSize:24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:30),

            buildCard(
              icon: Icons.menu_book,
              title: "My Subjects",
              subtitle: "View assigned subjects",
              onTap: (){
                Get.toNamed(AppRoutes.teacherSubjects);
              },
            ),

            buildCard(
              icon: Icons.book,
              title: "Today's Topics",
              subtitle: "View today's topics",
              onTap: (){
                Get.toNamed(AppRoutes.teacherTopics);
              },
            ),

            buildCard(
              icon: Icons.history,
              title: "Topic History",
              subtitle: "View completed topics",
              onTap: (){
                Get.toNamed(AppRoutes.teacherHistory);
              },
            ),

            buildCard(
              icon: Icons.person_outline,
              title: "My Profile",
              subtitle: "View profile",
              onTap: (){
                Get.toNamed(AppRoutes.teacherProfile);
              },
            ),

            buildCard(
              icon: Icons.logout,
              title: "Logout",
              subtitle: "Sign out",
              onTap: (){
                // logout
              },
            ),

          ],
        ),
      ),
    );
  }
}