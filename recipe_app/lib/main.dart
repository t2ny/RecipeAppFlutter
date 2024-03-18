import 'package:flutter/material.dart';
import 'package:recipe_app/navigation_view.dart';
//import 'package:recipe_app/navigation_view.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
