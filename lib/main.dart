import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tito_teachers_app/controllers/auth_controller.dart';
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