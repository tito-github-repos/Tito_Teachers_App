import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tito_teachers_app/controllers/auth_controller.dart';
import 'package:tito_teachers_app/controllers/class_controller.dart';
import 'package:tito_teachers_app/controllers/payment_controller.dart';
import 'package:tito_teachers_app/controllers/subject_controller.dart';
import 'package:tito_teachers_app/controllers/teachers_controller.dart';
import 'package:tito_teachers_app/controllers/topic_controller.dart';
import 'package:tito_teachers_app/controllers/topic_progress_controller.dart';
import 'package:tito_teachers_app/core/topics.dart';
import 'package:tito_teachers_app/firebase_options.dart';
import 'package:get/get.dart';
import 'package:tito_teachers_app/routes/app_pages.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';
import 'package:tito_teachers_app/theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
Get.put(AuthController(), permanent: true);
  Get.put(ClassController(), permanent: true);
  Get.put(SubjectController(), permanent: true);
  Get.put(TopicController(), permanent: true);
  Get.put(TopicProgressController(), permanent: true);
  Get.put(TeacherController(), permanent: true);
  Get.put(PaymentController(), permanent: true);
  
  
  // await SeedData.seedInitialData();
  // await TopicSeed.seedTopics();

  runApp(const TitoLearningApp());
  
}

class TitoLearningApp extends StatelessWidget {
  const TitoLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tito Teachers App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
