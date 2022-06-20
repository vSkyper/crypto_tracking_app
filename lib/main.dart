import 'package:crypto_tracking_app/views/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food recipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF18181B),
          primaryColor: const Color(0xFF18181B),
          textTheme: const TextTheme(
            bodyText2: TextStyle(color: Colors.white),
          )),
      home: HomePage(),
    );
  }
}
