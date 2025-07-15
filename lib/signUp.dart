import 'package:attendify/util/appRoutes.dart';
import 'package:attendify/util/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Theme/apptheme.dart';           // ← your theme file

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _firstName = TextEditingController();
  final _lastName  = TextEditingController();
  final _email     = TextEditingController();
  final _password  = TextEditingController();
  final _confirm   = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
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
          title: Text('Sign Up', style: theme.appBarTheme.titleTextStyle),
          backgroundColor: theme.primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // First Name
              TextField(
                controller: _firstName,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z]")),
                ],
                decoration: InputDecoration(
                  labelText: 'First Name',
                  hintText: 'John',
                  prefixIcon: Icon(Icons.person_outline, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastName,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z]")),
                ],
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'Gates',
                  prefixIcon: Icon(Icons.person_outline, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _email,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9._%+-@]")),
                ],
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'John@gmail.com',
                  prefixIcon: Icon(Icons.email, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'X23.?21kkq',
                  prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirm,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'X23.?21kkq',
                  prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: double.infinity, height: 48),
                child: ElevatedButton(
                  style: btnTh,
                  onPressed: _loading ? null : () async {
                    if (_password.text != _confirm.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")));
                      return;
                    }
                    setState(() => _loading = true);
                    bool ok = await UserAuth.signup(
                      firstName: _firstName.text,
                      lastName:  _lastName.text,
                      email:     _email.text,
                      password:  _password.text,
                    );
                    setState(() => _loading = false);
                    if (ok) {
                      Navigator.pushReplacementNamed(context, appRoutes.loginPage);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Signup failed")));
                    }
                  },
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text("Sign Up"),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Existing User?", style: textTh.bodyMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login", style: textTh.labelLarge),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
