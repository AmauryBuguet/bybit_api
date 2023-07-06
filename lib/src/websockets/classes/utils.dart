import 'package:web_socket_channel/io.dart';

import '../enums/channel.dart';
import '../enums/topic.dart';

class Subscription {
  final Topic topic;
  final Channel channel;
  final String name;

  Subscription({
    required this.topic,
    required this.channel,
    required this.name,
  });
}

class Websocket {
  final Channel channel;
  final IOWebSocketChannel socket;

  Websocket({
    required this.channel,
    required this.socket,
  });
}
