import '../../common/enums/common_enums.dart';
import '../enums/update_type.dart';

class TradeUpdate {
  String topic;
  UpdateType type;
  int ts;
  List<TradeData> data;

  TradeUpdate({
    required this.topic,
    required this.type,
    required this.ts,
    required this.data,
  });

  factory TradeUpdate.fromMap(Map<String, dynamic> json) {
    return TradeUpdate(
      topic: json['topic'],
      type: UpdateType.fromStr(json['type']),
      ts: json['ts'],
      data: List<TradeData>.from(json['data'].map((data) => TradeData.fromMap(data))),
    );
  }
}

class TradeData {
  int timestamp;
  String symbol;
  Side side;
  double qty;
  double price;
  TickDirection tickDirection;
  String tradeId;
  bool isBlockTrade;

  TradeData({
    required this.timestamp,
    required this.symbol,
    required this.side,
    required this.qty,
    required this.price,
    required this.tickDirection,
    required this.tradeId,
    required this.isBlockTrade,
  });

  factory TradeData.fromMap(Map<String, dynamic> json) {
    return TradeData(
      timestamp: json['T'],
      symbol: json['s'],
      side: Side.fromStr(json['S']),
      qty: double.parse(json['v']),
      price: double.parse(json['p']),
      tickDirection: TickDirection.fromStr(json['L']),
      tradeId: json['i'],
      isBlockTrade: json['BT'],
    );
  }
}
