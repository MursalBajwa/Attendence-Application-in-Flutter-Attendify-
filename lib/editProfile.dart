// editProfile.dart
import 'package:attendify/Parts/appDrawer.dart';
import 'package:attendify/util/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Parts/Custom_buttons.dart';
import 'Theme/appTheme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _firstController = TextEditingController();
  final _lastController  = TextEditingController();
  final _emailController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid   = FirebaseAuth.instance.currentUser!.uid;
    final doc   = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data  = doc.data();
    if (data != null) {
      _firstController.text = data['firstName'] as String? ?? '';
      _lastController.text  = data['lastName']  as String? ?? '';
      _emailController.text = data['email']     as String? ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _saveChanges() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'firstName': _firstController.text.trim(),
      'lastName':  _lastController.text.trim(),
      // email not updated in Firestore, we keep existing
    });
    Navigator.pushReplacementNamed(context, appRoutes.profilePage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final btnTh = theme.elevatedButtonTheme.style;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // First name
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: _firstController,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                    FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z]")),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'John',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),

              // Last name
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: _lastController,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                    FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z]")),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Gates',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),

              // Email (read-only)
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: _emailController,
                  readOnly: true,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),

              // Save button
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                  width: double.infinity, height: 48),
                child: ElevatedButton(
                  style: btnTh,
                  onPressed: _saveChanges,
                  child: Text(
                    "Save Changes",
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
