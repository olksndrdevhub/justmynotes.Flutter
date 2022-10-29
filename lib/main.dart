import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:justmynotes/constants/routes.dart';
import 'package:justmynotes/services/auth/auth_service.dart';
import 'package:justmynotes/views/login_view.dart';
import 'package:justmynotes/views/notes_view.dart';
import 'package:justmynotes/views/register_view.dart';
import 'package:justmynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log('User log in and email is verified');
                return const NotesView();
              } else {
                devtools.log('User log in, but email is not verified...');
                return const VerifyEmailView();
              }
            } else {
              devtools.log('User is not log in...');
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
