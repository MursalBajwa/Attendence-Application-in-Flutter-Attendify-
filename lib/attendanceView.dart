// attendanceView.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/apptheme.dart';
import 'package:attendify/util/appRoutes.dart';
import 'Parts/Custom_listCardAttendance.dart';

class AttendanceViewPage extends StatefulWidget {
  final String classId;
  const AttendanceViewPage({super.key, required this.classId});

  @override
  _AttendanceViewPageState createState() => _AttendanceViewPageState();
}

class _AttendanceViewPageState extends State<AttendanceViewPage> {
  late Future<List<String>> _datesFuture;

  @override
  void initState() {
    super.initState();
    _datesFuture = _fetchAllDates();
  }

  Future<void> _refreshDates() async {
    setState(() {
      _datesFuture = _fetchAllDates();
    });
  }

  Future<List<String>> _fetchAllDates() async {
    final enrolledSnap = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents')
        .get();
    Set<String> unionDates = {};
    for (var student in enrolledSnap.docs) {
      final attSnap = await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('enrolledStudents')
          .doc(student.id)
          .collection('attendance')
          .get();
      for (var d in attSnap.docs) unionDates.add(d.id);
    }
    final sorted = unionDates.toList()..sort((a, b) => b.compareTo(a));
    return sorted;
  }

  Future<void> _deleteAttendance(String date) async {
    final batch = FirebaseFirestore.instance.batch();
    final enrolledSnap = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .collection('enrolledStudents')
        .get();
    for (var student in enrolledSnap.docs) {
      final attRef = FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('enrolledStudents')
          .doc(student.id)
          .collection('attendance')
          .doc(date);
      batch.delete(attRef);
    }
    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attendance of $date deleted')),
    );
    await _refreshDates();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;
    final btnTh = theme.elevatedButtonTheme.style;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text('Attendance', style: theme.appBarTheme.titleTextStyle),
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
                    FutureBuilder<List<String>>(
                      future: _datesFuture,
                      builder: (context, snap) {
                        final count = snap.hasData ? snap.data!.length : 0;
                        return Text('Total Attendances: $count', style: textTh.headlineSmall);
                      },
                    ),
                    ElevatedButton(
                      style: btnTh,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          appRoutes.markAttendance,
                          arguments: widget.classId,
                        ).then((_) => _refreshDates());
                      },
                      child: Text('Mark Attnd'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: _datesFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final dates = snap.data ?? [];
                    if (dates.isEmpty) return const Center(child: Text('No attendance records.'));
                    return ListView.builder(
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        return listCardAttendance(
                          attendance: Attendance(
                            attendanceDate: date,
                            presentStudents: '', // compute present count if desired
                          ),
                          classId: widget.classId,
                          onDelete: () => _deleteAttendance(date),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
