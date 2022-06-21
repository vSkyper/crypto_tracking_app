import 'package:flutter/material.dart';

class CoinCard extends StatelessWidget {
  const CoinCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image.network(
                    'https://bitcoin.org/img/icons/opengraph.png?1652976465',
                    width: 30,
                    height: 30),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bitcoin',
                    ),
                    Text(
                      'BTC',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w200,
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('\$21312'),
                SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    text: '24h: ',
                    children: [
                      TextSpan(
                        text: '2.62%',
                        style: TextStyle(
                          color: (2.62 < 0 ? Colors.red : Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
