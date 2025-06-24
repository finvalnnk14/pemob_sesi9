class OrderModel {
  final int id;
  final int item;
  final int total;
  final String timestamp;

  OrderModel({
    required this.id,
    required this.item,
    required this.total,
    required this.timestamp,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      item: json['item'],
      total: json['total'],
      timestamp: json['timestamp'],
    );
  }
}
