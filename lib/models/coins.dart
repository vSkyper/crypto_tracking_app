class CoinsModel {
  final String id;
  final String name;
  final String symbol;
  final num currentPrice;
  final num priceChangePercentage24h;
  final String image;
  final num rank;

  CoinsModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.image,
    required this.rank,
  });

  factory CoinsModel.fromJson(dynamic json) {
    return CoinsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      currentPrice: json['current_price'] as num,
      priceChangePercentage24h: json['price_change_percentage_24h'] as num,
      image: json['image'] as String,
      rank: json['market_cap_rank'] as num,
    );
  }

  static List<CoinsModel> coinsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return CoinsModel.fromJson(data);
    }).toList();
  }
}
