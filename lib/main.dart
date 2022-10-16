import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import '../screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Sign in or Register new acc
            return const SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
              ],
            );
          } else {
            if (snapshot.data?.displayName == null) {
              // New user, create username
              return const ProfileScreen(
                providerConfigs: [
                  EmailProviderConfiguration(),
                ],
              );
            } else {
              // Current user, enter Home screen
              return const HomeScreen();
            }
          }
        },
      ),
    );
  }
}