// addClass.dart
import 'package:attendify/util/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/apptheme.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final name = _nameController.text.trim();
    final start = _startController.text.trim();
    final end = _endController.text.trim();
    if (name.isEmpty || start.isEmpty || end.isEmpty) return;

    await FirebaseFirestore.instance.collection('classes').add({
      'courseName': name,
      'startingDate': start,
      'endingDate': end,
      'ownerUid': user.uid,
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
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text('Add Class', style: theme.appBarTheme.titleTextStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z ]")),
                ],
                decoration: InputDecoration(
                  labelText: 'Class Name',
                  hintText: 'Software Engineering',
                  prefixIcon: Icon(Icons.class_, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _startController,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  hintText: '21-03-2025',
                  prefixIcon: Icon(Icons.calendar_today, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _endController,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                decoration: InputDecoration(
                  labelText: 'End Date',
                  hintText: '21-07-2025',
                  prefixIcon: Icon(Icons.calendar_today, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: double.infinity, height: 48),
                child: ElevatedButton(
                  style: btnTh,
                  onPressed: _submit,
                  child: Text('Add New Class'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
