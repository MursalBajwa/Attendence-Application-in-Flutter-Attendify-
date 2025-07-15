// addEnrolledStudent.dart
import 'package:attendify/Parts/Custom_listCardAddEnrolledStudent.dart';
import 'package:attendify/Parts/Custom_listCardStudent.dart';
import 'package:attendify/Parts/appDrawer.dart';
import 'package:attendify/util/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/appTheme.dart';

class AddEnrolledStudent extends StatefulWidget {
  const AddEnrolledStudent({super.key, this.classId});
  final String? classId;

  @override
  _AddEnrolledStudentState createState() => _AddEnrolledStudentState();
}

class _AddEnrolledStudentState extends State<AddEnrolledStudent> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference studentsRef =
      FirebaseFirestore.instance.collection('students');
  final List<String> selectedEnrolledStudent = [];
  List<String> enrolledIds = [];
  bool loadingEnrolled = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadEnrolledStudents();
  }

  Future<void> _loadEnrolledStudents() async {
    if (widget.classId == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents')
        .get();
    setState(() {
      enrolledIds = snapshot.docs.map((d) => d.id).toList();
      loadingEnrolled = false;
    });
  }

  Future<void> _saveSelected() async {
    if (widget.classId == null) return;
    setState(() => saving = true);
    final batch = FirebaseFirestore.instance.batch();
    final now = Timestamp.now();
    for (final studentId in selectedEnrolledStudent) {
      // get student details
      final doc = await studentsRef.doc(studentId).get();
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final target = FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('enrolledStudents')
          .doc(studentId);
      batch.set(target, {
        'name': data['name'] ?? '',
        'registrationNumber': data['registrationNumber'] ?? '',
        'enrolledAt': now,
      });
    }
    await batch.commit();
    setState(() => saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;
    final btnStyle = theme.elevatedButtonTheme.style;

    if (loadingEnrolled) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('Select Students', style: theme.appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: studentsRef
                          .where('ownerUid', isEqualTo: uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final count = snapshot.hasData
                            ? snapshot.data!.docs
                                .where((d) => !enrolledIds.contains(d.id))
                                .length
                            : 0;
                        return Text('Total Students: $count',
                            style: textTh.headlineMedium);
                      },
                    ),
                    Text('Selected: ${selectedEnrolledStudent.length}',
                        style: textTh.bodyLarge),
                  ],
                ),
                ElevatedButton(
                  style: btnStyle,
                  onPressed: _saveSelected,
                  child:  Text('Save', style: textTh.labelLarge),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  studentsRef.where('ownerUid', isEqualTo: uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No students found.'));
                }
                final docs = snapshot.data!.docs
                    .where((d) => !enrolledIds.contains(d.id))
                    .toList();
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final id = doc.id;
                    final studentModel = student(
                      id: id,
                      studentName: data['name'] as String? ?? '',
                      studentRegistrationNumber:
                          data['registrationNumber'] as String? ?? '',
                    );
                    final isSelected = selectedEnrolledStudent.contains(id);
                    return listCardAddEnrolledStudent(
                      Student: studentModel,
                      isSelected: isSelected,
                      onToggle: () {
                        setState(() {
                          if (isSelected) {
                            selectedEnrolledStudent.remove(id);
                          } else {
                            selectedEnrolledStudent.add(id);
                          }
                        });
                      },
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