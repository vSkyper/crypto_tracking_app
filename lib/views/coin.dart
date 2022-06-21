import 'package:flutter/material.dart';

class Coin extends StatefulWidget {
  const Coin({Key? key}) : super(key: key);

  @override
  State<Coin> createState() => _CoinState();
}

class _CoinState extends State<Coin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {},
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
                'https://bitcoin.org/img/icons/opengraph.png?1652976465',
                width: 30,
                height: 30),
            const SizedBox(width: 10),
            const Text('Bitcoin'),
          ],
        ),
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
