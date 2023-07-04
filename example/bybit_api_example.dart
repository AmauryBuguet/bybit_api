import 'package:bybit_api/bybit_api.dart';
import 'package:collection/collection.dart';

void main() async {
  final api = BybitApi(apiKey: "key", apiSecret: "secret");
  try {
    var a = await api.getFeeRate(
        // symbol: "BTCUSDT",
        );
    print(a.length);
    print(a.singleWhereOrNull((element) => element.symbol == "BTCUSDT")?.takerFeeRate);
    // var a = await api.createOrder(
    //   symbol: "BTCUSDT",
    //   orderType: OrderType.limit,
    //   qty: "0.01",
    //   side: Side.buy,
    //   price: "28015.2",
    //   triggerDirection: TriggerDirection.rise,
    //   triggerPrice: "32015",
    //   reduceOnly: true,
    // );
    // print(a);
    // print(a);
    // print(DateTime.fromMillisecondsSinceEpoch(a.deliveryTime));
  } on BybitException catch (e) {
    print(e.code);
    print(e.message);
  } catch (e) {
    print(e);
  }
}
