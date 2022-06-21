class Coins {
  final String name;
  final String symbol;
  final num currentPrice;
  final num priceChangePercentage24h;
  final String image;

  Coins({
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.image,
  });

  factory Coins.fromJson(dynamic json) {
    return Coins(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      currentPrice: json['current_price'] as num,
      priceChangePercentage24h: json['price_change_percentage_24h'] as num,
      image: json['image'] as String,
    );
  }

  static List<Coins> coinsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Coins.fromJson(data);
    }).toList();
  }
}
