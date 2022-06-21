import 'package:flutter/material.dart';

class FavoriteCoins extends StatefulWidget {
  const FavoriteCoins({Key? key}) : super(key: key);

  @override
  State<FavoriteCoins> createState() => _FavoriteCoinsState();
}

class _FavoriteCoinsState extends State<FavoriteCoins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Favorite Coins'),
      ),
    );
  }
}
