// profileView.dart
import 'package:attendify/Parts/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/appTheme.dart';  // <-- centralized theme
import 'util/appRoutes.dart';
import 'Parts/Custom_buttons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final textTh = theme.textTheme;
    final colors = theme.colorScheme;
    final uid    = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

    return Scaffold(
      endDrawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text(
          'Profile',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: Text('No user data found'));
          }
          final data = snap.data!;
          final first = data['firstName'] as String? ?? '';
          final last  = data['lastName']  as String? ?? '';
          final email = data['email']     as String? ?? '';
          final fullName = '$first $last';

          return Column(
            children: [
              // Profile picture
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("Student_Images/StudentProfile.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Details list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildInfoTile(
                      icon: Icons.person,
                      label: 'Name',
                      value: fullName,
                      textTh: textTh,
                      colors: colors,
                    ),
                    _buildInfoTile(
                      icon: Icons.email,
                      label: 'Email',
                      value: email,
                      textTh: textTh,
                      colors: colors,
                    ),

                    // Edit Profile button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        style: theme.elevatedButtonTheme.style,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            appRoutes.editProfilePage,
                          );
                        },
                        child: Text(
                          'Edit Profile',
                          style: textTh.labelLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required TextTheme textTh,
    required ColorScheme colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 40, color: colors.primary),
        title: Text(
          label,
          style: textTh.titleSmall,
        ),
        subtitle: Text(
          value,
          style: textTh.headlineMedium,
        ),
      ),
    );
  }
}
