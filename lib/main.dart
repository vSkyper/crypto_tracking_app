import 'package:crypto_tracking/views/home.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        title: 'Cryptocurrency',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: darkDynamic ??
              ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 10, 173, 223), brightness: Brightness.dark),
          appBarTheme: const AppBarTheme(elevation: 0),
          textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 15)),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
        home: const HomePage(),
      );
    });
  }
}
