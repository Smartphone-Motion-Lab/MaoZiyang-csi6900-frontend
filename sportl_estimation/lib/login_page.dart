import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UploadAndProcessVideoPage.dart';
import 'generated/l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Locale _selectedLocale = const Locale('en'); // 默认语言
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // 登录逻辑
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        );

        // 确保页面仍在上下文中
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UploadAndProcessVideoPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = S.of(context).this_user_was_not_found;
        } else if (e.code == 'wrong-password') {
          errorMessage = S.of(context).wrong_password_please_reenter;
        } else {
          errorMessage = S.of(context).login_failed_please_try_again;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(S.of(context).login_failed_please_try_again)),
          );
        }
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _usernameController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(S.of(context).please_enter_your_registered_email_address)),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S
                .of(context)
                .the_email_to_reset_your_password_has_been_sent_to_your_mailbox)),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = S.of(context).unable_to_send_reset_password_email;
      if (e.code == 'user-not-found') {
        errorMessage =
            S.of(context).this_user_was_not_found_please_check_your_mailbox;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
        actions: [
          TextButton(
            onPressed: _toggleLanguage, // 切换语言的方法
            child: Text(_selectedLocale.languageCode == 'en'
                ? '切换到中文'
                : 'Switch to English'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: S.of(context).username),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).please_enter_a_username;
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
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(S.of(context).login),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // 导航到注册页面
                  Navigator.pushNamed(context, '/register_page');
                },
                child: Text(S.of(context).dont_have_an_account_register),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _resetPassword,
                child: Text(S.of(context).forgot_your_password),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 切换语言的方法
  void _toggleLanguage() {
    setState(() {
      if (_selectedLocale.languageCode == 'en') {
        _selectedLocale = const Locale('zh');
      } else {
        _selectedLocale = const Locale('en');
      }
      S.load(_selectedLocale); // 加载新的语言
    });
  }
}
