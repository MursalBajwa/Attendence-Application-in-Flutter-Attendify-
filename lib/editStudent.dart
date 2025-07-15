// lib/editStudent.dart

import 'package:attendify/Parts/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/apptheme.dart';

class EditStudentPage extends StatefulWidget {
  final String? docId;
  const EditStudentPage({super.key, this.docId});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  late TextEditingController _nameController;
  late TextEditingController _regNumberController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _regNumberController = TextEditingController();
    if (widget.docId != null) _fetchStudent();
  }

  Future<void> _fetchStudent() async {
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.docId)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['name'] as String? ?? '';
      _regNumberController.text = data['registrationNumber'] as String? ?? '';
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (widget.docId == null) return;
    final newName = _nameController.text.trim();
    final newReg = _regNumberController.text.trim();
    if (newName.isEmpty || newReg.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.docId)
        .update({
      'name': newName,
      'registrationNumber': newReg,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTh = theme.textTheme;
    final inputTh = theme.inputDecorationTheme;
    final btnTh = theme.elevatedButtonTheme.style;

    return SafeArea(
      child: Scaffold(
        endDrawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text('Edit Student', style: theme.appBarTheme.titleTextStyle),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Student Name')
                          .applyDefaults(inputTh),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _regNumberController,
                      decoration: InputDecoration(labelText: 'Registration Number')
                          .applyDefaults(inputTh),
                    ),
                    SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 48),
                      child: ElevatedButton(
                        style: btnTh,
                        onPressed: _saveChanges,
                        child: Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}