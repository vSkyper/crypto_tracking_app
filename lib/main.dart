import 'package:crypto_tracking_app/models/favorite_coins_list_model.dart';
import 'package:crypto_tracking_app/views/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ChangeNotifierProvider<FavoriteCoinsListModel>(
      create: (_) => FavoriteCoinsListModel(),
      lazy: false,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptocurrency',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF18181B),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF18181B),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white, fontSize: 15),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Color(0xFF18181B),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
