import 'package:flutter/material.dart';

class OrderOnProgressDriverPage extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const OrderOnProgressDriverPage({Key? key, required this.orders})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesanan Sedang Diantar"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final items = order['items'] ?? [];
          final total = order['total'];
          final timestamp = order['timestamp'];
          final customerName = order['customerName'] ?? 'Customer';
          final destination = order['destination'] ?? 'Alamat tidak tersedia';
          final status = order['status'] ?? 'Dalam Perjalanan';

          return Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama Customer: $customerName",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text("Tujuan: $destination"),
                  SizedBox(height: 4),
                  Text("Total: Rp $total"),
                  Text("Waktu: $timestamp"),
                  Text("Status: $status"),
                  SizedBox(height: 8),
                  Text("Item:"),
                  ...items.map<Widget>((item) {
                    return Text("- ${item['name']} (Rp ${item['price']})");
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
