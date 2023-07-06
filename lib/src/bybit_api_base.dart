import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import 'common/classes/exception.dart';
import 'common/classes/kline.dart';
import 'common/enums/common_enums.dart';
import 'rest/enums/rest_enums.dart';
import 'rest/classes/closed_pnl.dart';
import 'rest/classes/coin_balance.dart';
import 'rest/classes/fee_rate.dart';
import 'common/classes/order.dart';
import 'rest/classes/order_book.dart';
import 'common/classes/position.dart';
import 'rest/classes/ticker_info.dart';
import 'websockets/classes/execution.dart';
import 'websockets/classes/kline.dart';
import 'websockets/classes/liquidation.dart';
import 'websockets/classes/order.dart';
import 'websockets/classes/orderbook.dart';
import 'websockets/classes/position.dart';
import 'websockets/classes/ticker.dart';
import 'websockets/classes/trade.dart';
import 'websockets/classes/utils.dart';
import 'websockets/classes/wallet.dart';
import 'websockets/enums/channel.dart';
import 'websockets/enums/depth.dart';
import 'websockets/enums/topic.dart';
import 'websockets/enums/ws_action.dart';

/// Base class for all Bybit API operations
///
/// [documentation here](https://bybit-exchange.github.io/docs/v3/intro)
class BybitApi {
  /// Endpoint for rest requests
  final String endpoint = "api.bybit.com";

  /// Endpoint for _openedWebsockets
  final String wsEndpoint = "wss://stream.bybit.com/";

  /// API key that you can generate from your Bybit account
  String? apiKey;

  /// API secret that you can generate from your Bybit account
  String? apiSecret;

  /// Time (in ms) during which the request is valid, defaults to 5000
  int recvWindow;

  /// Opened webSockets
  ///
  /// Each websocket corresponds to a different channel
  final List<Websocket> _openedWebsockets = [];

  /// Stream _controller used to remap all streams outputs to 1 stream of json data.
  final StreamController<Map<String, dynamic>> _controller = StreamController<Map<String, dynamic>>.broadcast();

  /// Dynamic list of subscribed topics
  List<Subscription> subscriptions = [];

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
  Future<dynamic> _sendRequest({
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

  /// Helper function to subscribe to any websocket stream from Bybit API
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws/connect)
  void _wsConnect(Channel channel) {
    if (_openedWebsockets.any((e) => e.channel == channel)) {
      return;
    }
    String url = '$wsEndpoint/${channel.str}';
    final socket = IOWebSocketChannel.connect(
      url,
      pingInterval: const Duration(minutes: 5),
      connectTimeout: const Duration(seconds: 10),
    );
    _openedWebsockets.add(Websocket(channel: channel, socket: socket));
    _controller.addStream(socket.stream.map((event) => jsonDecode(event)));
    if (channel.isPrivate()) {
      _wsAuthenticate(channel);
    }
  }

  /// Send a command and arguments to Bybit over the websocket with the desired channel
  void _wsRequest(WsAction action, List<dynamic> args, Channel channel) {
    _openedWebsockets.singleWhereOrNull((e) => e.channel == channel)?.socket.sink.add(
          jsonEncode(
            {
              "op": action.name,
              if (args.isNotEmpty) "args": args,
            },
          ),
        );
  }

  /// Athenticate the websocket connection
  ///
  /// This is useful for private endpoints
  void _wsAuthenticate(Channel channel) {
    if (apiKey == null || apiSecret == null) {
      throw Exception("Missing API keys");
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch + 2000;

    final msg = utf8.encode('GET/realtime$timestamp');
    final key = utf8.encode(apiSecret!);
    final hmac = Hmac(sha256, key);
    final signature = hmac.convert(msg).toString();
    _wsRequest(
      WsAction.auth,
      [apiKey, timestamp, signature],
      channel,
    );
  }

  /// Disconnect the WebSocket with the specified channel
  void wsDisconnect(Channel channel) {
    _openedWebsockets.singleWhereOrNull((e) => e.channel == channel)?.socket.sink.close();
    _openedWebsockets.removeWhere((e) => e.channel == channel);
  }

  /// Disconnect all connected webSockets
  void wsDisconnectAll() {
    for (final websocket in _openedWebsockets) {
      websocket.socket.sink.close();
    }
    _openedWebsockets.clear();
  }

  /// Subscribe to a topic
  void _subscribe(String name, Topic topic, Channel channel) {
    if (!subscriptions.any((e) => e.name == name)) {
      _wsRequest(WsAction.subscribe, [name], channel);
      subscriptions.add(Subscription(topic: topic, channel: channel, name: name));
    }
  }

  /// Unsubscribe from a particular topic name
  ///
  /// This does not disconnect the associated websocket
  void unsubscribe(String name) {
    final topic = subscriptions.singleWhereOrNull((e) => e.name == name);
    if (topic != null) {
      _wsRequest(WsAction.unsubscribe, [topic.topic], topic.channel);
    }
    subscriptions.removeWhere((e) => e.name == name);
  }

  /// Unsubscribe from all websockets with the specified topic
  void unsubscribeFromTopic(Topic topic) {
    final topics = subscriptions.where((e) => e.topic == topic);
    for (final subscribedTopic in topics) {
      _wsRequest(WsAction.unsubscribe, [subscribedTopic.name], subscribedTopic.channel);
    }
    subscriptions.removeWhere((e) => e.topic == topic);
  }

  /// Orderbook stream
  ///
  /// Once subscribe successfully, you will receive a snapshot first.
  ///
  /// Push frequency is determined according to selected Depth
  ///
  /// If you receive a new snapshot data, it is necessary to reset your local orderbook.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-public/orderbook)
  Stream<OrderbookUpdate> orderbookStream({
    required String symbol,
    required Depth depth,
  }) {
    final channel = Channel.publicChannelFromSymbol(symbol);
    _wsConnect(channel);
    final String topicName = "${Topic.orderbook.str}.${depth.str}.$symbol";
    _subscribe(topicName, Topic.orderbook, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => OrderbookUpdate.fromJson(e));
  }

  /// Get recent public trades data in Bybit.
  ///
  /// Push frequency: real-time
  ///
  /// After subscription, you will be pushed delta trade message in real-time once there is an order filled.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-public/trade)
  Stream<TradeUpdate> publicTradeStream({
    required String symbol,
  }) {
    final channel = Channel.publicChannelFromSymbol(symbol);
    _wsConnect(channel);
    final String topicName = "${Topic.publicTrade.str}.$symbol";
    _subscribe(topicName, Topic.publicTrade, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => TradeUpdate.fromJson(e));
  }

  /// Get latest information of the symbol
  ///
  /// Push frequency: 100ms
  ///
  /// Future has snapshot and delta types. If a key does not exist in the field, it means the value is not changed.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-public/ticker)
  Stream<TickerUpdate> tickerStream({
    required String symbol,
  }) {
    final channel = Channel.publicChannelFromSymbol(symbol);
    _wsConnect(channel);
    final String topicName = "${Topic.tickers.str}.$symbol";
    _subscribe(topicName, Topic.tickers, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => TickerUpdate.fromJson(e));
  }

  /// Candlestick stream
  ///
  /// Push frequency: 1-60s
  ///
  /// If confirm is true, then the data is a final tick for this interval. Otherwise, it is a snapshot.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-public/kline)
  Stream<KlineUpdate> klineStream({
    required String symbol,
    required Interval interval,
  }) {
    final channel = Channel.publicChannelFromSymbol(symbol);
    _wsConnect(channel);
    final String topicName = "${Topic.kline.str}.${interval.str}.$symbol";
    _subscribe(topicName, Topic.kline, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => KlineUpdate.fromJson(e));
  }

  /// Get recent liquidation orders in Bybit.
  ///
  /// Push frequency: real-time
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-public/liquidation)
  Stream<LiquidationUpdate> liquidationStream({
    required String symbol,
  }) {
    final channel = Channel.publicChannelFromSymbol(symbol);
    _wsConnect(channel);
    final String topicName = "${Topic.liquidation.str}.$symbol";
    _subscribe(topicName, Topic.liquidation, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => LiquidationUpdate.fromJson(e));
  }

  /// Subscribe to the position stream to see changes to your position size, position setting changes, etc.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-contract/position)
  Stream<PositionUpdate> userContractPositionStream() {
    final Channel channel = Channel.privateContract;
    _wsConnect(channel);
    final String topicName = "${Topic.userPosition.str}.contractAccount";
    _subscribe(topicName, Topic.userPosition, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => PositionUpdate.fromJson(e));
  }

  /// Subscribe to the execution stream to see when an open order gets filled or partially filled.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-contract/execution)
  Stream<ExecutionUpdate> userContractExecutionStream() {
    final Channel channel = Channel.privateContract;
    _wsConnect(channel);
    final String topicName = "${Topic.userExecution.str}.contractAccount";
    _subscribe(topicName, Topic.userExecution, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => ExecutionUpdate.fromJson(e));
  }

  /// Subscribe to the order stream to see new orders, when an order's order status changes, etc.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-contract/order)
  Stream<OrderUpdate> userContractOrderStream() {
    final Channel channel = Channel.privateContract;
    _wsConnect(channel);
    final String topicName = "${Topic.userOrder.str}.contractAccount";
    _subscribe(topicName, Topic.userOrder, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => OrderUpdate.fromJson(e));
  }

  /// Subscribe to the wallet stream to see changes to your wallet in real-time.
  ///
  /// [documentation here](https://bybit-exchange.github.io/docs/derivatives/ws-contract/wallet)
  Stream<WalletUpdate> userContractWalletStream() {
    final Channel channel = Channel.privateContract;
    _wsConnect(channel);
    final String topicName = "${Topic.userWallet.str}.contractAccount";
    _subscribe(topicName, Topic.userWallet, channel);
    return _controller.stream.where((e) => e["topic"] == topicName).map((e) => WalletUpdate.fromJson(e));
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
      final resp = await _sendRequest(path: "/derivatives/v3/public/kline", type: RequestType.getRequest, params: params);
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
      final resp = await _sendRequest(path: "/derivatives/v3/public/order-book/L2", type: RequestType.getRequest, params: params);
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
      final resp = await _sendRequest(path: "/derivatives/v3/public/tickers", type: RequestType.getRequest, params: params);
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
      final resp = await _sendRequest(
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
      final resp = await _sendRequest(
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
      final resp = await _sendRequest(
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
      await _sendRequest(
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
      final resp = await _sendRequest(
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
      final resp = await _sendRequest(
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
      final resp = await _sendRequest(
        path: "/contract/v3/private/position/list",
        type: RequestType.getRequest,
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
      await _sendRequest(
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
      await _sendRequest(
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
      await _sendRequest(
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
      await _sendRequest(
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
      final resp = await _sendRequest(
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
      final resp = await _sendRequest(
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
      final resp = await _sendRequest(
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
