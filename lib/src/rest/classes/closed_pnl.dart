import '../../common/enums/common_enums.dart';

class ClosedPnL {
  String symbol;
  String orderId;
  Side side;
  double qty;
  double orderPrice;
  OrderType orderType;
  ExecType execType;
  double closedSize;
  double cumEntryValue;
  double avgEntryPrice;
  double cumExitValue;
  double avgExitPrice;
  double closedPnl;
  int fillCount;
  int leverage;
  int createdAt;

  ClosedPnL({
    required this.symbol,
    required this.orderId,
    required this.side,
    required this.qty,
    required this.orderPrice,
    required this.orderType,
    required this.execType,
    required this.closedSize,
    required this.cumEntryValue,
    required this.avgEntryPrice,
    required this.cumExitValue,
    required this.avgExitPrice,
    required this.closedPnl,
    required this.fillCount,
    required this.leverage,
    required this.createdAt,
  });

  factory ClosedPnL.fromMap(Map<String, dynamic> map) {
    return ClosedPnL(
      symbol: map['symbol'],
      orderId: map['orderId'],
      side: Side.fromStr(map['side']),
      qty: double.parse(map['qty']),
      orderPrice: double.parse(map['orderPrice']),
      orderType: OrderType.fromStr(map['orderType']),
      execType: ExecType.fromStr(map['execType']),
      closedSize: double.parse(map['closedSize']),
      cumEntryValue: double.parse(map['cumEntryValue']),
      avgEntryPrice: double.parse(map['avgEntryPrice']),
      cumExitValue: double.parse(map['cumExitValue']),
      avgExitPrice: double.parse(map['avgExitPrice']),
      closedPnl: double.parse(map['closedPnl']),
      fillCount: int.parse(map['fillCount']),
      leverage: int.parse(map['leverage']),
      createdAt: int.parse(map['createdAt']),
    );
  }
}
