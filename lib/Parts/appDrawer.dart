import 'package:attendify/util/appRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../Theme/appTheme.dart'; // <- your centralized theme

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Mursal Bajwa",
              style: textTh.titleLarge,
            ),
            accountEmail: Text(
              "mursal.bajwa@gmail.com",
              style: textTh.bodySmall,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("Student_Images/Student.jpg"),
            ),
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
          ),
          ListTile(
            leading: Image.asset(
              "Dashboard_Images/Dashboard.png",
              height: 30,
              width: 30,
              color: theme.iconTheme.color,
            ),
            title: Text(
              "Dashboard",
              style: textTh.bodyLarge,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, appRoutes.crDashboardPage);
            },
          ),
          ListTile(
            leading: Image.asset(
              "Dashboard_Images/Class.png",
              height: 30,
              width: 30,
              color: theme.iconTheme.color,
            ),
            title: Text(
              "Classes",
              style: textTh.bodyLarge,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, appRoutes.classesPage);
            },
          ),
          ListTile(
            leading: Image.asset(
              "Dashboard_Images/student.png",
              height: 30,
              width: 30,
              color: theme.iconTheme.color,
            ),
            title: Text(
              "Students",
              style: textTh.bodyLarge,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, appRoutes.studentsPage);
            },
          ),
          ListTile(
            leading: Image.asset(
              "Dashboard_Images/report.png",
              height: 30,
              width: 30,
              color: theme.iconTheme.color,
            ),
            title: Text(
              "Reports",
              style: textTh.bodyLarge,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, appRoutes.generateReportPage);
            },
          ),
          Divider(color: theme.dividerColor),
          ListTile(
            leading: Image.asset(
              "Dashboard_Images/profile.png",
              height: 30,
              width: 30,
              color: theme.iconTheme.color,
            ),
            title: Text(
              "Profile",
              style: textTh.bodyLarge,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, appRoutes.profilePage);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: theme.colorScheme.error,
            ),
            title: Text(
              "Logout",
              style: textTh.bodyLarge?.copyWith(color: theme.colorScheme.error),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).popUntil((route) => route.isFirst);

              Navigator.of(context).pushReplacementNamed(appRoutes.loginPage);
            },
          ),
        ],
      ),
    );
  }
}
