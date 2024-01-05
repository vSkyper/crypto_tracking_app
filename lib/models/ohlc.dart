class OhlcModel {
  final DateTime time;
  final num open;
  final num high;
  final num low;
  final num close;

  OhlcModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory OhlcModel.fromJson(dynamic json) {
    return OhlcModel(
      time: DateTime.fromMillisecondsSinceEpoch(json[0]),
      open: json[1] as num,
      high: json[2] as num,
      low: json[3] as num,
      close: json[4] as num,
    );
  }

  static List<OhlcModel> coinsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return OhlcModel.fromJson(data);
    }).toList();
  }
}
