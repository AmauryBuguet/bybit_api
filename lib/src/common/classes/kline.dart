class Kline {
  int timestamp;
  double open;
  double high;
  double low;
  double close;
  double volume;
  double turnover;

  Kline({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.turnover,
  });

  factory Kline.fromList(List<dynamic> list) {
    if (list.length != 7) {
      throw FormatException('Invalid list length. Expected 7 elements.');
    }

    return Kline(
      timestamp: int.parse(list[0]),
      open: double.parse(list[1]),
      high: double.parse(list[2]),
      low: double.parse(list[3]),
      close: double.parse(list[4]),
      volume: double.parse(list[5]),
      turnover: double.parse(list[6]),
    );
  }

  factory Kline.fromMap(Map<String, dynamic> json) {
    return Kline(
      timestamp: json['start'],
      open: double.parse(json['open']),
      close: double.parse(json['close']),
      high: double.parse(json['high']),
      low: double.parse(json['low']),
      volume: double.parse(json['volume']),
      turnover: double.parse(json['turnover']),
    );
  }
}
