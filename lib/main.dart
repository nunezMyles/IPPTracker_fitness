import 'package:flutter/material.dart';
import 'package:my_fitness/screens/account_screen.dart';
import 'package:my_fitness/screens/map_screen.dart';
import 'package:my_fitness/screens/calendar_screen.dart';
import 'package:my_fitness/screens/register_screen.dart';
import 'package:my_fitness/screens/account_screen.dart';
import 'package:my_fitness/utilities/auth_service.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../providers/user_provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => UserProvider(),
            )
          ],
          child: const MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 46, 46, 46),
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 23, 23, 23),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            )
          )
      ),
      //initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/account': (context) => const AccountScreen(),

      },
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? const HomeScreen()    // when app is closed then reopened immediately, restore user runtime data
          : const LoginScreen(),  // else, dont restore and go back to login screen
    );
  }
}