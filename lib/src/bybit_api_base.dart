import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'classes/common_classes.dart';
import 'enums/common_enums.dart';
import 'enums/derivatives_enums.dart';

/// Base class for all Bybit API operations
///
/// [documentation here](https://bybit-exchange.github.io/docs/v3/intro)
class BybitApi {
  /// Endpoint for rest requests
  final String endpoint = "api.bybit.com";

  /// Endpoint for websockets
  final String wsEndpoint = "wss://stream.binance.com:9443";

  /// API key that you can generate from your Bybit account
  String? apiKey;

  /// API secret that you can generate from your Bybit account
  String? apiSecret;

  /// Time (in ms) during which the request is valid, defaults to 5000
  int recvWindow;

  /// Constructor
  ///
  /// If you want to use signed endpoints you must provide API keys
  BybitApi({
    this.apiKey,
    this.apiSecret,
    this.recvWindow = 5000,
  });

  /// Helper function to perform any kind of request to Bybit API
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/v3/intro#authentication)
  Future<dynamic> sendRequest({
    required String path,
    required RequestType type,
    bool signatureRequired = false,
    Map<String, String>? params,
  }) async {
    params ??= {};

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (signatureRequired) {
      if (apiSecret == null || apiKey == null) {
        throw Exception("Missing API keys");
      }
      String payload = "";
      if (params.isNotEmpty) {
        if (type == RequestType.getRequest) {
          for (final p in params.entries) {
            payload += "&${p.key}=${p.value}";
          }
          payload = payload.replaceFirst("&", "");
        } else {
          payload = jsonEncode(params);
        }
      }
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      final String paramStr = "$timestamp$apiKey$recvWindow$payload";
      final Hmac hmacSha256 = Hmac(sha256, utf8.encode(apiSecret!));
      final Digest sign = hmacSha256.convert(utf8.encode(paramStr));
      final String signature = sign.toString();
      headers['X-BAPI-API-KEY'] = apiKey!;
      headers['X-BAPI-SIGN'] = signature;
      headers['X-BAPI-SIGN-TYPE'] = '2';
      headers['X-BAPI-TIMESTAMP'] = timestamp.toString();
      headers['X-BAPI-RECV-WINDOW'] = recvWindow.toString();
    }

    http.Response? response;

    if (type == RequestType.getRequest) {
      response = await http.get(
        Uri.https(endpoint, path, params),
        headers: headers,
      );
    } else if (type == RequestType.postRequest) {
      response = await http.post(
        Uri.https(endpoint, path),
        headers: headers,
        body: jsonEncode(params),
      );
    }

    final Map<String, dynamic> result = jsonDecode(response!.body);

    if ((result['retCode'] as int) != 0) {
      throw BybitException(result["retMsg"], result["retCode"]);
    }

    return result["result"];
  }

  /// Get candlestick data
  ///
  /// Max limit is 200, default is 200.
  /// Default category is linear.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/public/kline)
  Future<List<Kline>> getKlineData({
    required String symbol,
    required Interval interval,
    required int start,
    required int end,
    Category? category,
    int? limit,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      "interval": interval.str,
      "end": end.toString(),
      "start": start.toString(),
      if (category != null) "category": category.str,
      if (limit != null) "limit": limit.toString(),
    };
    try {
      final resp = await sendRequest(path: "/derivatives/v3/public/kline", type: RequestType.getRequest, params: params);
      return (resp["list"] as List<dynamic>).map((e) => Kline.fromList(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get orderbook data
  ///
  /// Max limit is 500, default is 25.
  /// Default category is linear.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/public/orderbook)
  Future<OrderBook> getOrderBook({
    required String symbol,
    Category? category,
    int? limit,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      if (category != null) "category": category.str,
      if (limit != null) "limit": limit.toString(),
    };
    try {
      final resp = await sendRequest(path: "/derivatives/v3/public/order-book/L2", type: RequestType.getRequest, params: params);
      return OrderBook.fromMap(resp as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Get all latest information of symbols.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/public/ticker)
  Future<TickerInfo> getTickerInfo({
    required String symbol,
    Category? category,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      if (category != null) "category": category.str,
    };
    try {
      final resp = await sendRequest(path: "/derivatives/v3/public/tickers", type: RequestType.getRequest, params: params);
      return TickerInfo.fromMap(resp["list"][0] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Place a new order.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/place-order)
  Future<String> createOrder({
    required String symbol,
    required Side side,
    required OrderType orderType,
    required String qty,
    TimeInForce timeInForce = TimeInForce.goodTillCancel,
    String? price,
    TriggerDirection? triggerDirection,
    String? triggerPrice,
    TriggerBy? triggerBy,
    PositionIdx? positionIdx,
    String? orderLinkId,
    String? takeProfitPrice,
    String? stopLossPrice,
    TriggerBy? tpTriggerBy,
    TriggerBy? slTriggerBy,
    bool? reduceOnly,
    SmpType? smpType,
    bool? closeOnTrigger,
    TpSlMode? tpslMode,
    String? tpLimitPrice,
    String? slLimitPrice,
    OrderType? tpOrderType,
    OrderType? slOrderType,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      "side": side.str,
      "orderType": orderType.str,
      "qty": qty,
      "timeInForce": timeInForce.str,
      if (price != null) "price": price,
      if (triggerDirection != null) "triggerDirection": triggerDirection.str,
      if (triggerPrice != null) "triggerPrice": triggerPrice,
      if (triggerBy != null) "triggerBy": triggerBy.str,
      if (positionIdx != null) "positionIdx": positionIdx.str,
      if (orderLinkId != null) "orderLinkId": orderLinkId,
      if (takeProfitPrice != null) "takeProfit": takeProfitPrice,
      if (stopLossPrice != null) "stopLoss": stopLossPrice,
      if (tpTriggerBy != null) "tpTriggerBy": tpTriggerBy.str,
      if (slTriggerBy != null) "slTriggerBy": slTriggerBy.str,
      if (reduceOnly != null) "reduceOnly": reduceOnly.toString(),
      if (smpType != null) "smpType": smpType.str,
      if (closeOnTrigger != null) "closeOnTrigger": closeOnTrigger.toString(),
      if (tpslMode != null) "tpslMode": tpslMode.str,
      if (tpLimitPrice != null) "tpLimitPrice": tpLimitPrice,
      if (slLimitPrice != null) "slLimitPrice": slLimitPrice,
      if (tpOrderType != null) "tpOrderType": tpOrderType.str,
      if (slOrderType != null) "slOrderType": slOrderType.str,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/order/create",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
      return resp["orderId"];
    } catch (e) {
      rethrow;
    }
  }

  /// Query unfilled or partially filled orders in real-time.
  ///
  /// One of symbol, baseCoin and settleCoin is required.
  ///
  /// Max limit is 50, default is 20.
  /// At most 500 unfilled or partially filled orders will be returned if neither orderId nor orderLinkId is passed.
  ///
  /// The records are sorted by the createdTime from newest to oldest.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/open-order)
  Future<List<Order>> getOpenOrders({
    String? symbol,
    String? baseCoin,
    String? settleCoin,
    String? orderId,
    String? orderLinkId,
    OrderFilter? orderFilter,
    int? limit,
    String? cursor,
  }) async {
    Map<String, String> params = {
      if (symbol != null) "symbol": symbol,
      if (baseCoin != null) "baseCoin": baseCoin,
      if (settleCoin != null) "settleCoin": settleCoin,
      if (orderId != null) "orderId": orderId,
      if (orderLinkId != null) "orderLinkId": orderLinkId,
      if (orderFilter != null) "orderFilter": orderFilter.str,
      if (limit != null) "limit": limit.toString(),
      if (cursor != null) "cursor": cursor,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/order/unfilled-orders",
        type: RequestType.getRequest,
        params: params,
        signatureRequired: true,
      );
      return (resp["list"] as List<dynamic>).map((e) => Order.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Replace an existing (unfilled or partially filled) order.
  ///
  /// Either orderId or orderLinkId is required
  ///
  /// Don't pass parameters that are not to be modified
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/replace-order)
  Future<String> replaceOrder({
    required String symbol,
    String? orderId,
    String? orderLinkId,
    String? price,
    String? qty,
    String? triggerPrice,
    String? takeProfitPrice,
    String? stopLossPrice,
    TriggerBy? tpTriggerBy,
    TriggerBy? slTriggerBy,
    TriggerBy? triggerBy,
    String? tpLimitPrice,
    String? slLimitPrice,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      if (orderId != null) "orderId": orderId,
      if (orderLinkId != null) "orderLinkId": orderLinkId,
      if (price != null) "price": price,
      if (qty != null) "qty": qty,
      if (triggerPrice != null) "triggerPrice": triggerPrice,
      if (takeProfitPrice != null) "takeProfit": takeProfitPrice,
      if (stopLossPrice != null) "stopLoss": stopLossPrice,
      if (tpTriggerBy != null) "tpTriggerBy": tpTriggerBy.str,
      if (slTriggerBy != null) "slTriggerBy": slTriggerBy.str,
      if (triggerBy != null) "triggerBy": triggerBy.str,
      if (tpLimitPrice != null) "tpLimitPrice": tpLimitPrice,
      if (slLimitPrice != null) "slLimitPrice": slLimitPrice,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/order/replace",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
      return resp["orderId"];
    } catch (e) {
      rethrow;
    }
  }

  /// Cancels an active (unfilled or partially filled) order.
  ///
  /// Either orderId or orderLinkId is required.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/cancel)
  Future<void> cancelOrder({
    required String symbol,
    String? orderId,
    String? orderLinkId,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      if (orderId != null) "orderId": orderId,
      if (orderLinkId != null) "orderLinkId": orderLinkId,
    };
    try {
      await sendRequest(
        path: "/contract/v3/private/order/cancel",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// This endpoint enables to cancel all open orders.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/cancel-all)
  Future<List<void>> cancelAllOrders({
    String? symbol,
    String? baseCoin,
    String? settleCoin,
  }) async {
    Map<String, String> params = {
      if (symbol != null) "symbol": symbol,
      if (baseCoin != null) "baseCoin": baseCoin,
      if (settleCoin != null) "settleCoin": settleCoin,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/order/cancel-all",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
      return (resp["list"] as List<dynamic>).map((e) => e["orderId"] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Query order list.
  ///
  ///  As order creation/cancellation is asynchronous, the data returned from this endpoint may delay.
  ///
  /// Max limit is 50, default is 20.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/order-list)
  Future<List<Order>> getOrderList({
    String? symbol,
    String? orderId,
    String? orderLinkId,
    OrderStatus? orderStatus,
    OrderFilter? orderFilter,
    int? limit,
    String? cursor,
  }) async {
    Map<String, String> params = {
      if (symbol != null) "symbol": symbol,
      if (orderId != null) "orderId": orderId,
      if (orderLinkId != null) "orderLinkId": orderLinkId,
      if (orderStatus != null) "orderStatus": orderStatus.str,
      if (orderFilter != null) "orderFilter": orderFilter.str,
      if (limit != null) "limit": limit.toString(),
      if (cursor != null) "cursor": cursor,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/order/list",
        type: RequestType.getRequest,
        params: params,
        signatureRequired: true,
      );
      return (resp["list"] as List<dynamic>).map((e) => Order.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get real-time position data
  ///
  /// Either symbol or settleCoin is required.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/position-list)
  Future<List<Position>> getPositions({
    String? symbol,
    String? settleCoin,
  }) async {
    Map<String, String> params = {
      if (symbol != null) "symbol": symbol,
      if (settleCoin != null) "settleCoin": settleCoin,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/position/list",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
      return (resp["list"] as List<dynamic>).map((e) => Position.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Turn on/off auto add position margin.
  ///
  /// This functionality only supports USDT Perpetual.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/auto-margin)
  Future<void> setAutoAddMargin({
    required String symbol,
    required Side side,
    required bool autoAddMargin,
    required PositionIdx positionIdx,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      "side": side.str,
      "autoAddMargin": autoAddMargin ? "1" : "0",
      "positionIdx": positionIdx.str,
    };
    try {
      await sendRequest(
        path: "/contract/v3/private/position/set-auto-add-margin",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Switch cross margin mode / isolated margin mode.
  ///
  /// Support USDT Perpetual, Inverse Perpetual and Inverse Future.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/cross-isolated)
  Future<void> setMarginMode({
    required String symbol,
    required TradeMode tradeMode,
    required int leverage,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      "tradeMode": tradeMode.str,
      "buyLeverage": leverage.toString(),
      "sellLeverage": leverage.toString(),
    };
    try {
      await sendRequest(
        path: "/contract/v3/private/position/switch-isolated",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Switch the position mode for USDT perpetual and Inverse futures.
  ///
  /// Either symbol or coin is required.
  ///
  /// If you are in one-way Mode, you can only open one position on Buy or Sell side.
  ///
  /// If you are in hedge mode, you can open both Buy and Sell side positions simultaneously.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/position-mode)
  Future<void> setPositionMode({
    String? symbol,
    String? coin,
    required PositionMode positionMode,
  }) async {
    Map<String, String> params = {
      if (symbol != null) "symbol": symbol,
      if (coin != null) "coin": coin,
      "positionMode": positionMode.str,
    };
    try {
      await sendRequest(
        path: "/contract/v3/private/position/switch-mode",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Set the leverage.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/leverage)
  Future<void> setLeverage({
    required String symbol,
    required int leverage,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      "buyLeverage": leverage.toString(),
      "sellLeverage": leverage.toString(),
    };
    try {
      await sendRequest(
        path: "/contract/v3/private/position/set-leverage",
        type: RequestType.postRequest,
        params: params,
        signatureRequired: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Query user's closed profit and loss records.
  ///
  /// Max limit is 200, default is 50.
  ///
  /// Support USDT Perpetual, Inverse Perpetual and Inverse Future
  ///
  /// Specify startTime and endTime, you can query up to 2 years records
  ///
  /// Without startTime and endTime, it returns past 6 months records by default
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/closepnl)
  Future<List<ClosedPnL>> getClosedPnL({
    required String symbol,
    int? startTime,
    int? endTime,
    int? limit,
    String? cursor,
  }) async {
    Map<String, String> params = {
      "symbol": symbol,
      if (startTime != null) "startTime": startTime.toString(),
      if (endTime != null) "endTime": endTime.toString(),
      if (limit != null) "limit": limit.toString(),
      if (cursor != null) "cursor": cursor,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/position/closed-pnl",
        type: RequestType.getRequest,
        params: params,
        signatureRequired: true,
      );
      return (resp["list"] as List<dynamic>).map((e) => ClosedPnL.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get wallet balance, including Derivatives account and USDC account.
  ///
  /// Return all wallet info if coin is not passed
  ///
  /// Multiple coins are allowed, separated by comma, like ```USDT,USDC```
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/wallet)
  Future<List<CoinBalance>> getWalletBalance({
    String? coin,
  }) async {
    Map<String, String> params = {
      if (coin != null) "coin": coin,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/account/wallet/balance",
        type: RequestType.getRequest,
        params: params,
        signatureRequired: true,
      );
      return (resp["list"] as List<dynamic>).map((e) => CoinBalance.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get user trading fee rate.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/contract/fee-rate)
  Future<List<FeeRate>> getFeeRate({
    String? symbol,
  }) async {
    Map<String, String> params = {
      if (symbol != null) "symbol": symbol,
    };
    try {
      final resp = await sendRequest(
        path: "/contract/v3/private/account/fee-rate",
        type: RequestType.getRequest,
        params: params,
        signatureRequired: true,
      );
      return (resp["list"] as List<dynamic>).map((e) => FeeRate.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
