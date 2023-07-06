import '../../common/enums/common_enums.dart';
import '../enums/update_type.dart';

class LiquidationUpdate {
  LiquidationData data;
  String topic;
  int ts;
  UpdateType type;

  LiquidationUpdate({
    required this.data,
    required this.topic,
    required this.ts,
    required this.type,
  });

  factory LiquidationUpdate.fromJson(Map<String, dynamic> json) {
    return LiquidationUpdate(
      data: LiquidationData.fromJson(json['data']),
      topic: json['topic'],
      ts: json['ts'],
      type: UpdateType.fromStr(json['type']),
    );
  }
}

class LiquidationData {
  double price;
  Side side;
  double size;
  String symbol;
  int updatedTime;

  LiquidationData({
    required this.price,
    required this.side,
    required this.size,
    required this.symbol,
    required this.updatedTime,
  });

  factory LiquidationData.fromJson(Map<String, dynamic> json) {
    return LiquidationData(
      price: double.parse(json['price']),
      side: Side.fromStr(json['side']),
      size: double.parse(json['size']),
      symbol: json['symbol'],
      updatedTime: json['updatedTime'],
    );
  }
}
