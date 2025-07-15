// editClass.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Theme/apptheme.dart';

class EditClassPage extends StatefulWidget {
  final String classId;
  const EditClassPage({super.key, required this.classId});

  @override
  _EditClassPageState createState() => _EditClassPageState();
}

class _EditClassPageState extends State<EditClassPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadClassData();
  }

  Future<void> _loadClassData() async {
    final doc = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .get();
    final data = doc.data();
    if (data != null) {
      _nameController.text = data['courseName'] ?? '';
      _startController.text = data['startingDate'] ?? '';
      _endController.text = data['endingDate'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _saveChanges() async {
    await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classId)
        .update({
      'courseName': _nameController.text.trim(),
      'startingDate': _startController.text.trim(),
      'endingDate': _endController.text.trim(),
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
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
          title: Text('Edit Class', style: theme.appBarTheme.titleTextStyle),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
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
                        prefixIcon: Icon(Icons.class_, color: theme.iconTheme.color),
                      ).applyDefaults(inputTh),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _startController,
                      style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        prefixIcon: Icon(Icons.calendar_today, color: theme.iconTheme.color),
                      ).applyDefaults(inputTh),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _endController,
                      style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        prefixIcon: Icon(Icons.calendar_today, color: theme.iconTheme.color),
                      ).applyDefaults(inputTh),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: double.infinity, height: 48),
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
