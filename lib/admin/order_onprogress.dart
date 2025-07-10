import 'package:flutter/material.dart';
import 'detail_order_on_progress.dart';

class OrderOnProgressPage extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const OrderOnProgressPage({Key? key, required this.orders})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order On Progress"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final items = order['items'] ?? [];
          final total = order['total'];
          final timestamp = order['timestamp'];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailOrderOnProgressPage(order: order),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total: Rp $total"),
                    Text("Waktu: $timestamp"),
                    SizedBox(height: 8),
                    Text("Item:"),
                    ...items.map<Widget>((item) {
                      return Text("- ${item['name']} (Rp ${item['price']})");
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
