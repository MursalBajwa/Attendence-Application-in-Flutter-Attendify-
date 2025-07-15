import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Theme/apptheme.dart';             
import 'package:attendify/util/appRoutes.dart';
import 'package:attendify/util/user_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          title: Text('Login', style: theme.appBarTheme.titleTextStyle),
          backgroundColor: theme.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
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
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                style: textTh.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'X23.?21kkq',
                  prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                ).applyDefaults(inputTh),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: double.infinity, height: 48),
                child: ElevatedButton(
                  style: btnTh,
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          bool ok = await UserAuth.login(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                          setState(() => _loading = false);

                          if (ok) {
                            Navigator.pushReplacementNamed(
                                context, appRoutes.crDashboardPage);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid credentials')),
                            );
                          }
                        },
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),
      
   
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New User?', style: textTh.bodyMedium),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                        context, appRoutes.signupPage),
                    child: Text('Sign Up', style: textTh.labelLarge),
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
