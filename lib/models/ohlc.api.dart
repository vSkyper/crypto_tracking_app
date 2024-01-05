import 'dart:convert';
import 'package:crypto_tracking/models/ohlc.dart';
import 'package:http/http.dart';

class OhlcApi {
  static Future<List<OhlcModel>> getOhlc(id, days) async {
    try {
      final Uri uri = Uri.https('api.coingecko.com', '/api/v3/coins/$id/ohlc', {
        'vs_currency': 'usd',
        'days': days,
      });

      final Response response = await get(uri);

      if (response.statusCode != 200) throw Exception('Error getting ohlc');

      final List data = json.decode(response.body);

      return OhlcModel.coinsFromSnapshot(data);
    } catch (e) {
      rethrow;
    }
  }
}
