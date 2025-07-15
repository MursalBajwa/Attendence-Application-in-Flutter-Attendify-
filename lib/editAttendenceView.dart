import 'package:attendify/Parts/Custom_listCardStudent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/appTheme.dart';
import 'Parts/Custom_listCardMarkAttendance.dart';

class editAttendanceView extends StatefulWidget {
  final String classId;
  final String attendanceDate;
  const editAttendanceView(
      {super.key, required this.classId, required this.attendanceDate});

  @override
  _EditAttendancePageState createState() => _EditAttendancePageState();
}

class _EditAttendancePageState extends State<editAttendanceView> {
  final Map<String, String> attendanceStatus = {};
  late Future<String> _courseNameFuture;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadStatuses();
    _courseNameFuture = _fetchCourseName();
  }

  Future<String> _fetchCourseName() async {
    final doc = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .get();
    return (doc.data()?['courseName'] as String?) ?? 'Unknown Course';
  }

  Future<void> _loadStatuses() async {
    final snap = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents')
        .get();
    for (var doc in snap.docs) {
      final attDoc = await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('enrolledStudents')
          .doc(doc.id)
          .collection('attendance')
          .doc(widget.attendanceDate)
          .get();
      attendanceStatus[doc.id] =
          attDoc.exists ? (attDoc.data()?['status'] as String? ?? 'A') : 'A';
    }
    setState(() => loading = false);
  }

  Future<void> _save() async {
    setState(() => saving = true);
    final batch = FirebaseFirestore.instance.batch();
    final now = Timestamp.now();
    attendanceStatus.forEach((studentId, status) {
      final ref = FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('enrolledStudents')
          .doc(studentId)
          .collection('attendance')
          .doc(widget.attendanceDate);
      batch.set(
          ref, {'status': status, 'markedAt': now}, SetOptions(merge: true));
    });
    await batch.commit();
    setState(() => saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;
    final btnStyle = theme.elevatedButtonTheme.style;

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('Edit Attendance', style: theme.appBarTheme.titleTextStyle),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: theme.primaryColor),
            onPressed: _save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Subject:', style: textTh.headlineMedium),
                      FutureBuilder<String>(
                        future: _courseNameFuture,
                        builder: (context, snap) {
                          final course = snap.data ?? 'Loading...';
                          return Text('$course', style: textTh.headlineSmall);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: btnStyle,
                    onPressed: saving ? null : _save,
                    child: Text('Save', style: textTh.labelLarge),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: attendanceStatus.keys.map((studentId) {
                  final current = attendanceStatus[studentId]!;
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('classes')
                        .doc(widget.classId)
                        .collection('enrolledStudents')
                        .doc(studentId)
                        .get(),
                    builder: (context, snap) {
                      if (!snap.hasData) return const SizedBox.shrink();
                      final d = snap.data!.data() as Map<String, dynamic>;
                      final s = student(
                        id: studentId,
                        studentName: d['name'] as String? ?? '',
                        studentRegistrationNumber:
                            d['registrationNumber'] as String? ?? '',
                      );
                      return listCardMarkAttendence(
                        Student: s,
                        status: current,
                        onToggle: () {
                          setState(() => attendanceStatus[studentId] =
                              current == 'A' ? 'P' : 'A');
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
