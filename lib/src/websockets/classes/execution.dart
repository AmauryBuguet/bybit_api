import '../../common/enums/common_enums.dart';

class ExecutionUpdate {
  String topic;
  List<ExecutionData> data;

  ExecutionUpdate({
    required this.topic,
    required this.data,
  });

  factory ExecutionUpdate.fromJson(Map<String, dynamic> json) {
    return ExecutionUpdate(
      topic: json['topic'],
      data: List<ExecutionData>.from(json['data'].map((data) => ExecutionData.fromJson(data))),
    );
  }
}

class ExecutionData {
  String symbol;
  double execFee;
  String execId;
  double execPrice;
  double execQty;
  ExecType execType;
  double execValue;
  double feeRate;
  LastLiquidityInd lastLiquidityInd;
  double leavesQty;
  String orderId;
  String? orderLinkId;
  double orderPrice;
  double orderQty;
  OrderType orderType;
  StopOrderType? stopOrderType;
  Side side;
  int execTime;
  double closedSize;
  String? blockTradeId;
  double markPrice;

  ExecutionData({
    required this.symbol,
    required this.execFee,
    required this.execId,
    required this.execPrice,
    required this.execQty,
    required this.execType,
    required this.execValue,
    required this.feeRate,
    required this.lastLiquidityInd,
    required this.leavesQty,
    required this.orderId,
    required this.orderLinkId,
    required this.orderPrice,
    required this.orderQty,
    required this.orderType,
    required this.stopOrderType,
    required this.side,
    required this.execTime,
    required this.closedSize,
    required this.blockTradeId,
    required this.markPrice,
  });

  factory ExecutionData.fromJson(Map<String, dynamic> json) {
    return ExecutionData(
      symbol: json['symbol'],
      execFee: double.parse(json['execFee']),
      execId: json['execId'],
      execPrice: double.parse(json['execPrice']),
      execQty: double.parse(json['execQty']),
      execType: ExecType.fromStr(json['execType']),
      execValue: double.parse(json['execValue']),
      feeRate: double.parse(json['feeRate']),
      lastLiquidityInd: LastLiquidityInd.fromStr(json['lastLiquidityInd']),
      leavesQty: double.parse(json['leavesQty']),
      orderId: json['orderId'],
      orderLinkId: json['orderLinkId'],
      orderPrice: double.parse(json['orderPrice']),
      orderQty: double.parse(json['orderQty']),
      orderType: OrderType.fromStr(json['orderType']),
      stopOrderType: StopOrderType.fromStr(json['stopOrderType']),
      side: Side.fromStr(json['side']),
      execTime: int.parse(json['execTime']),
      closedSize: double.parse(json['closedSize']),
      blockTradeId: json['blockTradeId'],
      markPrice: double.parse(json['markPrice']),
    );
  }
}
