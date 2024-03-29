import 'dart:convert';
import 'package:crypto_tracking/models/coins.dart';
import 'package:http/http.dart';

class CoinsApi {
  static Future<List<CoinsModel>> getCoins({ids = ''}) async {
    try {
      final Uri uri = Uri.https('api.coingecko.com', '/api/v3/coins/markets', {
        'vs_currency': 'usd',
        'ids': ids,
        'order': 'market_cap_desc',
        'per_page': '250',
        'page': '1',
        'sparkline': 'false',
        'price_change_percentage': '24h',
      });

      final Response response = await get(uri);

      if (response.statusCode != 200) throw Exception('Error getting coins');

      final List data = json.decode(response.body);

      return CoinsModel.coinsFromSnapshot(data);
    } catch (e) {
      rethrow;
    }
  }
}
