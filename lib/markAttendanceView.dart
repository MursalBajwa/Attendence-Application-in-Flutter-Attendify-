
import 'package:attendify/Parts/Custom_listCardMarkAttendance.dart';
import 'package:attendify/Parts/Custom_listCardStudent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/appTheme.dart';

class markAttendanceView extends StatefulWidget {
  final String classId;
  const markAttendanceView({super.key, required this.classId});

  @override
  _markAttendanceViewState createState() => _markAttendanceViewState();
}

class _markAttendanceViewState extends State<markAttendanceView> {
  final Map<String, String> attendanceStatus = {};
  late Future<String> _courseNameFuture;
  String dropdownValue = 'All Absent';
  bool saving = false;

  String get todayId => DateTime.now().toIso8601String().split('T').first;

  @override
  void initState() {
    super.initState();
    _courseNameFuture = _fetchCourseName();
    // load enrolled students and set default absent
    FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents')
        .get()
        .then((snap) {
      setState(() {
        for (var doc in snap.docs) {
          attendanceStatus[doc.id] = 'A';
        }
      });
    });
  }

  Future<String> _fetchCourseName() async {
    final doc = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .get();
    return (doc.data()?['courseName'] as String?) ?? 'Unknown Course';
  }

  void _setAll(String status) {
    setState(() {
      for (var key in attendanceStatus.keys) {
        attendanceStatus[key] = status;
      }
      dropdownValue = status == 'P' ? 'All Present' : 'All Absent';
    });
  }

  Future<void> _saveAttendance() async {
    final enrolledRef = FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents');

    // Check if today's attendance already exists for any student
    if (attendanceStatus.isNotEmpty) {
      final firstId = attendanceStatus.keys.first;
      final docRef =
          enrolledRef.doc(firstId).collection('attendance').doc(todayId);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        // Show snackbar if already marked
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance already marked for today'),
          ),
        );
        return;
      }
    }

    setState(() => saving = true);
    final batch = FirebaseFirestore.instance.batch();
    final now = Timestamp.now();

    for (var entry in attendanceStatus.entries) {
      final studentId = entry.key;
      final status = entry.value;
      final attRef = FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('enrolledStudents')
          .doc(studentId)
          .collection('attendance')
          .doc(todayId);
      batch.set(
          attRef,
          {
            'status': status,
            'markedAt': now,
          },
          SetOptions(merge: true));
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
    // define enrolledRef here for streams
    final enrolledRef = FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('Mark Attendance', style: theme.appBarTheme.titleTextStyle),
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
                      DropdownButton<String>(
                        value: dropdownValue,
                        items: const [
                          DropdownMenuItem(
                              value: 'All Present', child: Text('All Present')),
                          DropdownMenuItem(
                              value: 'All Absent', child: Text('All Absent')),
                        ],
                        onChanged: (val) {
                          if (val == 'All Present')
                            _setAll('P');
                          else if (val == 'All Absent') _setAll('A');
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: btnStyle,
                    onPressed: _saveAttendance,
                    child: Text('Save', style: textTh.labelLarge),
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
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty)
                    return const Center(child: Text('No students.'));
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final s = student(
                        id: doc.id,
                        studentName: data['name'] ?? '',
                        studentRegistrationNumber:
                            data['registrationNumber'] ?? '',
                      );
                      final status = attendanceStatus[doc.id] ?? 'A';
                      return listCardMarkAttendence(
                        Student: s,
                        status: status,
                        onToggle: () {
                          setState(() {
                            attendanceStatus[doc.id] =
                                status == 'A' ? 'P' : 'A';
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
      ),
    );
  }
}
