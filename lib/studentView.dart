// lib/studentView.dart

import 'package:attendify/Parts/Custom_listCardStudent.dart';
import 'package:attendify/Parts/appDrawer.dart';
import 'package:attendify/util/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentViewPage extends StatelessWidget {
  const StudentViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;
    final btnTh = theme.elevatedButtonTheme.style;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final studentsQuery = FirebaseFirestore.instance
        .collection('students')
        .where('ownerUid', isEqualTo: uid);

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('Students', style: theme.appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: studentsQuery.snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return Text("Total Students: $count", style: textTh.headlineMedium);
                  },
                ),
                ElevatedButton(
                  style: btnTh,
                  onPressed: () {
                    Navigator.pushNamed(context, appRoutes.addStudentPage);
                  },
                  child: const Text("Add Student"),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: studentsQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No students found.'));
                }
                final students = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return student(
                    id: doc.id,
                    studentName: data['name'] as String? ?? '',
                    studentRegistrationNumber: data['registrationNumber'] as String? ?? '',
                  );
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemCount: students.length,
                  itemBuilder: (context, i) => listCardStudent(
                    Student: students[i],
                    onEdit: () {
                      Navigator.pushNamed(
                        context,
                        appRoutes.editStudentPage,
                        arguments: {'docId': students[i].id},
                      );
                    },
                    onDelete: () async {
                      // delete document
                      await FirebaseFirestore.instance
                          .collection('students')
                          .doc(students[i].id)
                          .delete();
                      // optional: show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deleted ${students[i].studentName}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
