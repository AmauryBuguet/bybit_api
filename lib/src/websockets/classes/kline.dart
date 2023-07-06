import '../../common/classes/kline.dart';
import '../../common/enums/common_enums.dart';
import '../enums/update_type.dart';

class KlineUpdate {
  String topic;
  KlineData data;
  int ts;
  UpdateType type;

  KlineUpdate({
    required this.topic,
    required this.data,
    required this.ts,
    required this.type,
  });

  factory KlineUpdate.fromJson(Map<String, dynamic> json) {
    return KlineUpdate(
      topic: json['topic'],
      data: KlineData.fromJson(json['data'][0]),
      ts: json['ts'],
      type: UpdateType.fromStr(json['type']),
    );
  }
}

class KlineData {
  Kline kline;
  int end;
  Interval interval;
  bool confirm;
  int timestamp;

  KlineData({
    required this.kline,
    required this.end,
    required this.interval,
    required this.confirm,
    required this.timestamp,
  });

  factory KlineData.fromJson(Map<String, dynamic> json) {
    return KlineData(
      kline: Kline.fromJson(json),
      end: json['end'],
      interval: Interval.fromStr(json['interval']),
      confirm: json['confirm'],
      timestamp: json['timestamp'],
    );
  }
}
