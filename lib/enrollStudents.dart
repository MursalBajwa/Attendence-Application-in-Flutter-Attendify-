// enrollStudents.dart
import 'package:attendify/Parts/Custom_listCardStudent.dart';
import 'package:attendify/Parts/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/apptheme.dart';
import 'package:attendify/util/appRoutes.dart';
import 'package:attendify/Parts/Custom_listCardEnrolledStudent.dart';

class EnrollStudentsPage extends StatelessWidget {
  final String classId;
  const EnrollStudentsPage({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;
    final btnTh = theme.elevatedButtonTheme.style;
    final enrolledRef = FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('enrolledStudents');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('Enrolled Students', style: theme.appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: enrolledRef.snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return Text('Total Students: $count', style: textTh.headlineMedium);
                  },
                ),
                ElevatedButton(
                  style: btnTh,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      appRoutes.addEnrolledStudentPage,
                      arguments: classId,
                    );
                  },
                  child: Text('Enroll Student'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: enrolledRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No students enrolled.'));
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final studentModel = student(
                      id: doc.id,
                      studentName: data['name'] as String? ?? '',
                      studentRegistrationNumber: data['registrationNumber'] as String? ?? '',
                    );
                    return listCardEnrolledStudent(
                      classId: classId,
                      Student: studentModel,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}