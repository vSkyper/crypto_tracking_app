class Coin {
  final num price;
  final num priceChangePercentage24h;
  final num marketCap;
  final num totalVolume;
  final num low;
  final num high;

  Coin({
    required this.price,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.low,
    required this.high,
  });

  factory Coin.fromJson(dynamic json) {
    return Coin(
      price: json['market_data']['current_price']['usd'] as num,
      priceChangePercentage24h:
          json['market_data']['price_change_percentage_24h'] as num,
      marketCap: json['market_data']['market_cap']['usd'] as num,
      totalVolume: json['market_data']['total_volume']['usd'] as num,
      low: json['market_data']['low_24h']['usd'] as num,
      high: json['market_data']['high_24h']['usd'] as num,
    );
  }

  static Coin coinFromSnapshot(dynamic snapshot) {
    return Coin.fromJson(snapshot);
  }
}
