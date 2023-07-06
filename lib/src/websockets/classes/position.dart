import '../../common/classes/position.dart';

class PositionUpdate {
  String topic;
  List<Position> data;

  PositionUpdate({
    required this.topic,
    required this.data,
  });

  factory PositionUpdate.fromJson(Map<String, dynamic> json) {
    return PositionUpdate(
      topic: json['topic'],
      data: List<Position>.from(json['data'].map((data) => Position.fromMap(data))),
    );
  }
}
