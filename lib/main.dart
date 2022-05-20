import 'package:flutter/material.dart';
import 'package:flutter_login_app/providers/auth_provider.dart';
import 'package:flutter_login_app/providers/user_provider.dart';
import 'package:flutter_login_app/screens/dashboard.dart';
import 'package:flutter_login_app/screens/login.dart';
import 'package:flutter_login_app/screens/register.dart';
import 'package:flutter_login_app/utility/shared_preference.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import 'domain/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (_)=> AuthProvider()),
          ChangeNotifierProvider(create: (_)=> UserProvider()),
      ],
      child: MaterialApp(
        title: 'Login Registration',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  Login(),
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/dashboard': (context) => DashBoard(),

        },
      ),
    );


}}
