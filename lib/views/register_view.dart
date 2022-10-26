import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justmynotes/constants/routes.dart';
import 'package:justmynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
                final userCredentials = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                devtools.log(userCredentials.toString());
              } on FirebaseAuthException catch (error) {
                if (error.code == 'weak-password') {
                  devtools.log('Weak password...');
                  await showErrorDialog(
                    context,
                    'Weak password!',
                  );
                } else if (error.code == 'email-already-in-use') {
                  devtools.log('Email already in use...');
                  await showErrorDialog(
                    context,
                    'Email already in use!',
                  );
                } else if (error.code == 'invalid-email') {
                  devtools.log('Invalid email...');
                  await showErrorDialog(
                    context,
                    'Invalid email!',
                  );
                } else {
                  devtools.log(error.code);
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
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already register? Log In!'),
          )
        ],
      ),
    );
  }
}
