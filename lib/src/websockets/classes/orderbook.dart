import '../../common/classes/book_order.dart';
import '../enums/update_type.dart';

class OrderbookUpdate {
  String topic;
  UpdateType type;
  int ts;
  OrderbookData data;
  int? u;
  int? seq;

  OrderbookUpdate({
    required this.topic,
    required this.type,
    required this.ts,
    required this.data,
    required this.u,
    required this.seq,
  });

  factory OrderbookUpdate.fromJson(Map<String, dynamic> json) {
    return OrderbookUpdate(
      topic: json['topic'],
      type: UpdateType.fromStr(json['type']),
      ts: json['ts'],
      data: OrderbookData.fromJson(json['data']),
      u: json['u'],
      seq: json['seq'],
    );
  }
}

class OrderbookData {
  String symbol;
  List<BookOrder> asks;
  List<BookOrder> bids;

  OrderbookData({
    required this.symbol,
    required this.bids,
    required this.asks,
  });

  factory OrderbookData.fromJson(Map<String, dynamic> map) {
    return OrderbookData(
      symbol: map['s'],
      asks: List<BookOrder>.from(
        (map['a'] as List<dynamic>).map<BookOrder>(
          (x) => BookOrder.fromList(x as List<dynamic>),
        ),
      ),
      bids: List<BookOrder>.from(
        (map['b'] as List<dynamic>).map<BookOrder>(
          (x) => BookOrder.fromList(x as List<dynamic>),
        ),
      ),
    );
  }
}
