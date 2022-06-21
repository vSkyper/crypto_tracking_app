import 'package:flutter/material.dart';

class CoinCard extends StatelessWidget {
  final String name;
  final String symbol;
  final num currentPrice;
  final num priceChangePercentage24h;
  final String image;

  const CoinCard({
    Key? key,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image.network(
                    image,
                    width: 30,
                    height: 30),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(
                      symbol.toUpperCase(),
                      style: const TextStyle(
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
              children: [
                Text('\$$currentPrice'),
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    text: '24h: ',
                    children: [
                      TextSpan(
                        text: '${priceChangePercentage24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: (priceChangePercentage24h < 0 ? Colors.red : Colors.green),
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
