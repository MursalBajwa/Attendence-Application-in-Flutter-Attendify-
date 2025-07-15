// viewAttendanceView.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/appTheme.dart';
import 'Parts/Custom_listCardViewAttendance.dart';

class viewAttandenceView extends StatefulWidget {
  final String classId;
  final String attendanceDate;
  const viewAttandenceView(
      {super.key, required this.classId, required this.attendanceDate});

  @override
  _viewAttandenceViewState createState() => _viewAttandenceViewState();
}

class _viewAttandenceViewState extends State<viewAttandenceView> {
  late Future<List<Map<String, String>>> _attendanceListFuture;
  late Future<String> _courseNameFuture;

  @override
  void initState() {
    super.initState();
    _attendanceListFuture = _fetchAttendanceStatuses();
    _courseNameFuture = _fetchCourseName();
  }

  Future<String> _fetchCourseName() async {
    final doc = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .get();
    return (doc.data()?['courseName'] as String?) ?? 'Unknown Course';
  }

  Future<List<Map<String, String>>> _fetchAttendanceStatuses() async {
    final enrolledSnap = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents')
        .get();
    List<Map<String, String>> statuses = [];
    for (var doc in enrolledSnap.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final attDoc = await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('enrolledStudents')
          .doc(doc.id)
          .collection('attendance')
          .doc(widget.attendanceDate)
          .get();
      final status =
          attDoc.exists ? (attDoc.data()?['status'] as String? ?? 'A') : 'A';
      statuses.add({
        'id': doc.id,
        'name': data['name'] as String? ?? '',
        'reg': data['registrationNumber'] as String? ?? '',
        'status': status,
      });
    }
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('View Attendance - ${widget.attendanceDate}',
            style: theme.appBarTheme.titleTextStyle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: _courseNameFuture,
                  builder: (context, snap) {
                    final course = snap.data ?? 'Loading...';
                    return Text('Subject: $course',
                        style: textTh.headlineMedium);
                  },
                ),
                Text('Date: ${widget.attendanceDate}', style: textTh.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: _attendanceListFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snap.data ?? [];
                if (list.isEmpty)
                  return const Center(child: Text('No records found.'));
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return listCardViewAttendence(
                      studentName: item['name']!,
                      studentRegistration: item['reg']!,
                      status: item['status']!,
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
