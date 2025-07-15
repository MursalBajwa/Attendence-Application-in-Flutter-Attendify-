

import 'package:attendify/util/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/apptheme.dart';            // <-- your theme
import 'Parts/custom_widgets.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _nameCtrl = TextEditingController();
  final _regCtrl  = TextEditingController();
  final _auth     = FirebaseAuth.instance;
  final _fire     = FirebaseFirestore.instance;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _regCtrl.dispose();
    super.dispose();
  }

  Future<void> _addStudent() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final name = _nameCtrl.text.trim();
    final reg  = _regCtrl.text.trim();
    if (name.isEmpty || reg.isEmpty) return;

    final newStudent = {
      'name': name,
      'registrationNumber': reg,
      'ownerUid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await _fire.collection('students').add(newStudent);
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error adding student: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to add student')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final textTh  = theme.textTheme;
    final inputTh = theme.inputDecorationTheme;
    final btnTh   = theme.elevatedButtonTheme.style;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text('Add Student', style: theme.appBarTheme.titleTextStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Student Name
              TextField(
                controller: _nameCtrl,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z\s]")),
                ],
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  hintText: 'Hassan Mahsam',
                  prefixIcon: Icon(Icons.school, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 30),
              // Registration Number
              TextField(
                controller: _regCtrl,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                decoration: InputDecoration(
                  labelText: 'Registration Number',
                  hintText: '22-CS-404',
                  prefixIcon: Icon(Icons.confirmation_number, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 20),
              // Add Button
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: double.infinity, height: 48),
                child: ElevatedButton(
                  style: btnTh,
                  onPressed: _addStudent,
                  child: const Text("Add New Student"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
