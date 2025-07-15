import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

import 'Theme/appTheme.dart';
import 'package:attendify/Parts/appDrawer.dart';

class GenerateReports extends StatefulWidget {
  const GenerateReports({super.key});
  @override
  _GenerateReportsPageState createState() => _GenerateReportsPageState();
}

class _GenerateReportsPageState extends State<GenerateReports> {
  Map<String, String> _classes = {};
  String? _selectedClassId;
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final snap = await FirebaseFirestore.instance.collection('classes').get();
    final map = {
      for (var d in snap.docs) d.id: (d.data()['courseName'] as String? ?? '')
    };
    setState(() => _classes = map);
  }

  Future<void> _generateReport() async {
    if (_selectedClassId == null ||
        _fromController.text.isEmpty ||
        _toController.text.isEmpty) return;
    setState(() => _generating = true);

    final from = DateTime.parse(_fromController.text);
    final to   = DateTime.parse(_toController.text);

    // 1) fetch students
    final studSnap = await FirebaseFirestore.instance
        .collection('classes')
        .doc(_selectedClassId)
        .collection('enrolledStudents')
        .get();

    // 2) collect all dates in range
    final datesSet = <String>{};
    for (var s in studSnap.docs) {
      final attSnap = await FirebaseFirestore.instance
          .collection('classes')
          .doc(_selectedClassId)
          .collection('enrolledStudents')
          .doc(s.id)
          .collection('attendance')
          .get();
      for (var a in attSnap.docs) {
        final dt = DateTime.tryParse(a.id);
        if (dt != null && !dt.isBefore(from) && !dt.isAfter(to))
          datesSet.add(a.id);
      }
    }
    final dates = datesSet.toList()..sort();

    // 3) build the Excel
    final wb    = xls.Workbook();
    final sheet = wb.worksheets[0];
    final header = ['RegistrationNumber', 'StudentName', ...dates];
    for (var c = 0; c < header.length; c++) {
      sheet.getRangeByIndex(1, c + 1).setText(header[c]);
    }
    for (var i = 0; i < studSnap.docs.length; i++) {
      final doc  = studSnap.docs[i];
      final data = doc.data();
      sheet.getRangeByIndex(i + 2, 1)
           .setText(data['registrationNumber'] as String? ?? '');
      sheet.getRangeByIndex(i + 2, 2)
           .setText(data['name'] as String? ?? '');
      for (var j = 0; j < dates.length; j++) {
        final att = await FirebaseFirestore.instance
            .collection('classes')
            .doc(_selectedClassId)
            .collection('enrolledStudents')
            .doc(doc.id)
            .collection('attendance')
            .doc(dates[j])
            .get();
        final status = att.exists 
            ? (att.data()?['status'] as String? ?? '') 
            : '';
        sheet.getRangeByIndex(i + 2, j + 3).setText(status);
      }
    }

    // save to bytes
    final bytes = wb.saveAsStream();
    // avoid the "unmodifiable list" bug by NOT disposing the workbook

    // write into app docs as fallback
    final appDocDir = await getApplicationDocumentsDirectory();
    final fallbackPath = '${appDocDir.path}/attendance_report_$_selectedClassId.xlsx';
    final fallbackFile = File(fallbackPath);
    await fallbackFile.writeAsBytes(bytes, flush: true);

    String finalPath = fallbackPath;

    // now try to write directly into /storage/emulated/0/Download
    if (Platform.isAndroid) {
      // ask for MANAGE_EXTERNAL_STORAGE on Android 11+ or WRITE on <11
      final perm = Platform.isAndroid && (await Permission.manageExternalStorage.isGranted)
          ? Permission.manageExternalStorage
          : Permission.storage;
      if (await perm.request().isGranted) {
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          final targetPath = '${downloadsDir.path}/attendance_report_$_selectedClassId.xlsx';
          final targetFile = File(targetPath);
          await targetFile.writeAsBytes(bytes, flush: true);
          finalPath = targetPath;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Saved to Downloads: $targetPath')),
          );
        }
      }
    }

    // open whichever file we ended up with
    await OpenFile.open(finalPath);

    setState(() => _generating = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final textTh  = theme.textTheme;
    final colors  = theme.colorScheme;
    final btnStyle= theme.elevatedButtonTheme.style;

    return Scaffold(
      endDrawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text('Generate Report', style: theme.appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Class Name:', style: textTh.headlineSmall?.copyWith(color: colors.primary)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedClassId,
              hint: const Text('Select class'),
              items: _classes.entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedClassId = v),
            ),
            const SizedBox(height: 20),
            Text('From Date (YYYY-MM-DD):', style: textTh.headlineSmall?.copyWith(color: colors.primary)),
            TextField(controller: _fromController, decoration: const InputDecoration(hintText: '2025-01-13')),
            const SizedBox(height: 20),
            Text('To Date (YYYY-MM-DD):', style: textTh.headlineSmall?.copyWith(color: colors.primary)),
            TextField(controller: _toController, decoration: const InputDecoration(hintText: '2025-01-20')),
            const Spacer(),
            ElevatedButton(
              style: btnStyle,
              onPressed: _generating ? null : _generateReport,
              child: _generating
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Generate Report', style: textTh.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}
