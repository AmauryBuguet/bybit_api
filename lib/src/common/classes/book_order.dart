class BookOrder {
  double price;
  double qty;

  BookOrder({
    required this.price,
    required this.qty,
  });

  factory BookOrder.fromList(List<dynamic> list) {
    if (list.length != 2) {
      throw FormatException('Invalid list length. Expected 2 elements.');
    }

    return BookOrder(
      price: double.parse(list[0]),
      qty: double.parse(list[1]),
    );
  }
}
