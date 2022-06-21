class Coin {
  final num price;

  Coin({
    required this.price,
  });

  factory Coin.fromJson(dynamic json) {
    return Coin(
      price: json['market_data']['current_price']['usd'] as num,
    );
  }

  static Coin coinFromSnapshot(dynamic snapshot) {
    return Coin.fromJson(snapshot);
  }
}
