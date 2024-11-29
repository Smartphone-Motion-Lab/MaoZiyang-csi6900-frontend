import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'generated/l10n.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // 确保表单通过验证后才执行注册
      _formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        print("User registered: ${userCredential.user}");
        // 注册成功后的逻辑
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).registration_successful)),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = S.of(context).the_password_is_too_weak;
        } else if (e.code == 'email-already-in-use') {
          errorMessage = S.of(context).this_mailbox_has_been_registered;
        } else {
          errorMessage = S.of(context).registration_failed_please_try_again;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
          // ignore: avoid_print
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(S.of(context).registration_failed_please_try_again)),
        );
      }
    }
  }

  @override
  void dispose() {
    // 释放控制器资源
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).register),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: S.of(context).please_enter_a_valid_email_address),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).please_enter_a_username;
                }
                if (!value.contains('@')) {
                  return S.of(context).please_enter_a_valid_email_address;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: S.of(context).password),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).please_enter_your_password;
                }
                if (value.length < 6) {
                  return S
                      .of(context)
                      .passwords_need_to_be_at_least_6_characters;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration:
                  InputDecoration(labelText: S.of(context).confirm_password),
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return S.of(context).please_enter_your_password_again;
                }

                return null;
              },
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text(S.of(context).register),
            ),
          ],
        ),
      ),
    );
  }
}
