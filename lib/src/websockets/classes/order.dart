import '../../common/classes/order.dart';

class OrderUpdate {
  String topic;
  List<Order> data;

  OrderUpdate({
    required this.topic,
    required this.data,
  });

  factory OrderUpdate.fromMap(Map<String, dynamic> json) {
    return OrderUpdate(
      topic: json['topic'],
      data: List<Order>.from(json['data'].map((data) => Order.fromMap(data))),
    );
  }
}
