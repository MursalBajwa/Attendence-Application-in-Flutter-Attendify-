import 'package:attendify/addClass.dart';
import 'package:attendify/addEnrolledStudent.dart';
import 'package:attendify/addStudent.dart';
import 'package:attendify/attendanceView.dart';
import 'package:attendify/editAttendenceView.dart';
import 'package:attendify/editClass.dart';
import 'package:attendify/editProfile.dart';
import 'package:attendify/editStudent.dart';
import 'package:attendify/enrollStudents.dart';
import 'package:attendify/login.dart';
import 'package:attendify/markAttendanceView.dart';
import 'package:attendify/profileView.dart';
import 'package:attendify/signUp.dart';
import 'package:attendify/studentView.dart';
import 'package:attendify/viewAttendenceView.dart';
import 'package:flutter/material.dart';
import '../crDashboard.dart';
import '../classesView.dart';
import '../generateReports.dart';
import 'package:attendify/editStudent.dart';

class appRoutes {
  static const String loginPage = "/";
  static const String signupPage = "/signup";
  static const String crDashboardPage = "/crdashboard";
  static const String classesPage = "/classes";
  static const String generateReportPage = "/report";
  static const String studentsPage = "/students";
  static const String profilePage = "/profile";
  static const String addStudentPage = "/addstudent";
  static const String addClassPage = "/addclass";
  static const String attendancePage = "/attendance";
  static const String markAttendance = "/markattendance";
  static const String enrollStudentPage = "/enrollStudent";
  static const String editProfilePage = "/editprofile";
  static const String editStudentPage = "/editstudent";
  static const String editClassPage = "/editclass";
  static const String editAttendanceViewPage = "/editAttendance";
  static const String viewAttendanceViewPage = "/viewAttendance";
  static const String addEnrolledStudentPage = "/addEnrolledStudentPage";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appRoutes.loginPage:
        return MaterialPageRoute(builder: (c) {
          return LoginPage();
        });
      case appRoutes.signupPage:
        {
          return MaterialPageRoute(builder: (c) {
            return SignUpPage();
          });
        }
      case appRoutes.crDashboardPage:
        return MaterialPageRoute(builder: (c) {
          return CrDashboard();
        });
      case appRoutes.classesPage:
        return MaterialPageRoute(builder: (c) {
          return ClassesViewPage();
        });
      case appRoutes.generateReportPage:
        return MaterialPageRoute(builder: (c) {
          return GenerateReports();
        });
      case appRoutes.studentsPage:
        return MaterialPageRoute(builder: (c) {
          return StudentViewPage();
        });
      case appRoutes.profilePage:
        return MaterialPageRoute(builder: (c) {
          return ProfileView();
        });
      case appRoutes.addStudentPage:
        return MaterialPageRoute(builder: (c) {
          return AddStudentPage();
        });
      case appRoutes.addClassPage:
        return MaterialPageRoute(builder: (c) {
          return AddClassPage();
        });
      case appRoutes.attendancePage:
        final classId = settings.arguments as String?;
        return MaterialPageRoute(builder: (c) {
          return AttendanceViewPage(classId: classId ?? '');
        });
      case appRoutes.markAttendance:
        final classId = settings.arguments as String?;
        return MaterialPageRoute(builder: (c) {
          return markAttendanceView(classId: classId ?? "",);
        });
      case appRoutes.enrollStudentPage:
        final classId = settings.arguments as String?;
        return MaterialPageRoute(builder: (c) {
          return EnrollStudentsPage(classId: classId ?? '');
        });
      case appRoutes.editProfilePage:
        return MaterialPageRoute(builder: (c) {
          return EditProfile();
        });
      case appRoutes.editStudentPage:
        final args = settings.arguments as Map<String, dynamic>?;
        final docId = args?['docId'] as String?;
        return MaterialPageRoute(builder: (c) {
          return EditStudentPage(docId: docId);
        });
      case appRoutes.editClassPage:
        final classId = settings.arguments as String?;
        return MaterialPageRoute(builder: (c) {
          return EditClassPage(classId: classId ?? '');
        });
      case appRoutes.editAttendanceViewPage:
        final args = settings.arguments as Map<String, String>;
        final classId = args['classId'] as String;
        final attendanceDate= args['Date'] as String;
        return MaterialPageRoute(builder: (c) {
          return editAttendanceView(classId: classId,attendanceDate: attendanceDate,);
        });
      case appRoutes.viewAttendanceViewPage:
          final args = settings.arguments as Map<String, dynamic>;
          final classId = args['classId'] as String;
          final attendanceDate = args['Date'] as String;
        return MaterialPageRoute(builder: (c) {
          return viewAttandenceView(classId:classId, attendanceDate:attendanceDate);
        });
      case appRoutes.addEnrolledStudentPage:
      final classId = settings.arguments as String?; 
        return MaterialPageRoute(builder: (c) {
          return AddEnrolledStudent(classId: classId,);
        });
      default:
        return MaterialPageRoute(
          builder: (c) => Text("Page Does Not Exist"),
        );
    }
  }
}
