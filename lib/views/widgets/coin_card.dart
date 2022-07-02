import 'package:crypto_tracking_app/views/coin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinCard extends StatelessWidget {
  final String id;
  final String name;
  final String symbol;
  final num currentPrice;
  final num priceChangePercentage24h;
  final String image;
  final num rank;

  const CoinCard({
    Key? key,
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.image,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('\$###,###,##0.00#########');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CoinWidget(id: id, name: name, image: image),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    rank.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w200,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Image.network(image, width: 27, height: 27),
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
                          fontSize: 12,
                        ),
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
                  Text(formatter.format(currentPrice)),
                  const SizedBox(height: 3),
                  Text.rich(
                    TextSpan(
                      text: '24h: ',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w200,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${priceChangePercentage24h.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: (priceChangePercentage24h < 0
                                ? Colors.red
                                : Colors.green),
                            fontWeight: FontWeight.normal,
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
      ),
    );
  }
}
