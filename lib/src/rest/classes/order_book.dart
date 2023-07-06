import '../../common/classes/book_order.dart';

class OrderBook {
  List<BookOrder> asks;
  List<BookOrder> bids;
  int timestamp;
  int updateId;
  String symbol;

  OrderBook({
    required this.asks,
    required this.bids,
    required this.timestamp,
    required this.updateId,
    required this.symbol,
  });

  factory OrderBook.fromMap(Map<String, dynamic> map) {
    return OrderBook(
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
      timestamp: map['ts'] as int,
      updateId: map['u'] as int,
      symbol: map['s'] as String,
    );
  }
}
