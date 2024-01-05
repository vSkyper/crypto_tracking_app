import 'dart:convert';
import 'package:crypto_tracking/models/coins.dart';
import 'package:http/http.dart' as http;

class CoinsApi {
  static Future<List<Coins>> getCoins({ids = ''}) async {
    var uri = Uri.https('api.coingecko.com', '/api/v3/coins/markets', {
      'vs_currency': 'usd',
      'ids': ids,
      'order': 'market_cap_desc',
      'per_page': '250',
      'page': '1',
      'sparkline': 'false',
      'price_change_percentage': '24h',
    });

    final response = await http.get(uri);

    List data = json.decode(response.body);

    return Coins.coinsFromSnapshot(data);
  }
}
