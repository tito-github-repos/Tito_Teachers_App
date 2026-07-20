

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';
import 'package:tito_teachers_app/screens/admin/admin_screen.dart';
import 'package:tito_teachers_app/screens/admin/import_excel_screen.dart';
import 'package:tito_teachers_app/screens/admin/payments_screen.dart';
import 'package:tito_teachers_app/screens/admin/report_screen.dart';
import 'package:tito_teachers_app/screens/admin/student_list_screen.dart';
import 'package:tito_teachers_app/screens/admin/teachers_list_screen.dart';
import 'package:tito_teachers_app/screens/auth/login_screen.dart';
import 'package:tito_teachers_app/screens/auth/register_screen.dart';
import 'package:tito_teachers_app/screens/splash/splash.dart';
import 'package:tito_teachers_app/screens/students/student_screen.dart';
import 'package:tito_teachers_app/screens/teachers/teacher_screen.dart';

class AppPages {
  static final pages = [

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () =>  LoginScreen(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () =>  RegisterScreen(),
    ),

    GetPage(
      name: AppRoutes.teacher,
      page: () => const TeacherDashboard(),
    ),

    GetPage(
      name: AppRoutes.student,
      page: () => const StudentHomeScreen(),
    ),

    GetPage(
      name: AppRoutes.admin,
      page: () => const AdminDashboard(),
    ),
  
  GetPage(
  name: AppRoutes.teachersList,
  page: () =>  TeacherListScreen(),
),

GetPage(
  name: AppRoutes.studentsList,
  page: () =>  StudentListScreen(),
),

GetPage(
  name: AppRoutes.importExcel,
  page: () => const ImportExcelScreen(),
),

GetPage(
  name: AppRoutes.payments,
  page: () => const PaymentsScreen(),
),

GetPage(
  name: AppRoutes.reports,
  page: () => const ReportsScreen(),
),
  ];
}