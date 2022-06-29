import 'dart:convert';
import 'package:crypto_tracking_app/models/ohlc.dart';
import 'package:http/http.dart' as http;

class OhlcApi {
  static Future<List<Ohlc>> getOhlc(id, days) async {
    var uri = Uri.https('api.coingecko.com', '/api/v3/coins/$id/ohlc', {
      'vs_currency': 'usd',
      'days': days,
    });

    final response = await http.get(uri);

    List data = json.decode(response.body);

    return Ohlc.coinsFromSnapshot(data);
  }
}
