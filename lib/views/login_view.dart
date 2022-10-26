import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmynotes/constants/routes.dart';
import 'package:justmynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _passowrd;

  @override
  void initState() {
    _email = TextEditingController();
    _passowrd = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _passowrd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _passowrd,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _passowrd.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
                devtools.log('User log in successfully');
              } on FirebaseAuthException catch (error) {
                if (error.code == 'user-not-found') {
                  devtools.log('User not found...');
                  await showErrorDialog(
                    context,
                    'User not found!',
                  );
                } else if (error.code == 'wrong-password') {
                  devtools.log('Wrong password...');
                  await showErrorDialog(
                    context,
                    'Wrong credentials!',
                  );
                } else {
                  devtools.log('Error: ${error.code}');
                  await showErrorDialog(
                    context,
                    'Error: ${error.code}',
                  );
                }
              } catch (e) {
                devtools.log(e.toString());
                await showErrorDialog(
                  context,
                  'Error: ${e.toString()}',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
