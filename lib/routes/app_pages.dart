

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tito_teachers_app/screens/admin/payment_reports.dart';
import 'package:tito_teachers_app/routes/app_routes.dart';
import 'package:tito_teachers_app/screens/admin/admin_screen.dart';
import 'package:tito_teachers_app/screens/admin/import_excel_screen.dart';
import 'package:tito_teachers_app/screens/admin/payments_setting_screen.dart';
import 'package:tito_teachers_app/screens/admin/student_list_screen.dart';
import 'package:tito_teachers_app/screens/admin/student_payment_screen.dart';
import 'package:tito_teachers_app/screens/admin/teacher_payment_screen.dart';
import 'package:tito_teachers_app/screens/admin/teachers_list_screen.dart';
import 'package:tito_teachers_app/screens/admin/topic_manage_screen.dart';
import 'package:tito_teachers_app/screens/auth/login_screen.dart';
import 'package:tito_teachers_app/screens/auth/register_screen.dart';
import 'package:tito_teachers_app/screens/splash/splash.dart';
import 'package:tito_teachers_app/screens/students/payment_screen.dart';
import 'package:tito_teachers_app/screens/students/student_history.dart';
import 'package:tito_teachers_app/screens/students/student_profile.dart';
import 'package:tito_teachers_app/screens/students/student_screen.dart';
import 'package:tito_teachers_app/screens/students/student_subject_screen.dart';
import 'package:tito_teachers_app/screens/teachers/complete_topic_screen.dart';
import 'package:tito_teachers_app/screens/teachers/payment_screen.dart';
import 'package:tito_teachers_app/screens/teachers/teacher_history_screen.dart';
import 'package:tito_teachers_app/screens/teachers/teacher_profile_screen.dart';
import 'package:tito_teachers_app/screens/teachers/teacher_screen.dart';
import 'package:tito_teachers_app/screens/teachers/topic_screen.dart';

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
  name: AppRoutes.paymentsSettings,
  page: () =>  PaymentSettingsScreen(),
),


GetPage(
  name: AppRoutes.completeTopic,
  page: () => const CompleteTopicScreen(),
),
GetPage(
  name: AppRoutes.studentSubjects,
  page: () =>
      const StudentSubjectsScreen(),
),


GetPage(
  name: AppRoutes.topics,
  page: () => const TopicManagementScreen(),
),
GetPage(
  name: AppRoutes.teacherTopics,
  page: () => const TeacherTopicsScreen(),
),
GetPage(
  name: AppRoutes.teacherHistory,
  page: () => const TeacherHistoryScreen(),
),
GetPage(
  name: AppRoutes.teacherProfile,
  page: () => const TeacherProfileScreen(),
),
GetPage(
  name: AppRoutes.studentSubjects,
  page: () => const StudentSubjectsScreen(),
)
,
GetPage(
  name: AppRoutes.studentHistory,
  page: () => const StudentHistoryScreen(),),
  GetPage(
  name: AppRoutes.studentProfile,
  page: () => const StudentProfileScreen(),), 

  GetPage(
  name: AppRoutes.teacherPayments,
  page: () =>  TeacherPaymentsScreen(),  )

  ,GetPage(
  name: AppRoutes.studentPayments,
  page: () =>  StudentPaymentsScreen(),  ),
  GetPage(
  name: AppRoutes.paymentReport,
  page: () =>  PaymentReportsScreen(),  ),
  GetPage(
  name: AppRoutes.paymentTeacher,
  page: () =>  TeacherMyPaymentsScreen(),  ),
  GetPage(
  name: AppRoutes.paymentStudent,
  page: () =>  StudentMyPaymentsScreen(),  ),
  ];  
}