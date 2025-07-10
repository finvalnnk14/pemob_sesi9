import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailOrderOnProgressPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const DetailOrderOnProgressPage({Key? key, required this.order})
      : super(key: key);

  Future<void> sendToDashboardDriver(BuildContext context) async {
    final url = Uri.parse('http://localhost:3000/api/admin/pesanan');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': order['username'],
          'name': order['name'],
          'items': order['items'],
          'total': order['total'],
          'address': order['address'],
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pesanan berhasil dikirim ke driver!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengirim pesanan. Code: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = order['username'] ?? 'N/A';
    final name = order['name'] ?? 'N/A';
    final items = order['items'] ?? [];
    final total = order['total'] ?? 0;
    final address = order['address'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Order"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // jika data panjang
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username: $username", style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text("Nama: $name", style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text("Items:", style: TextStyle(fontSize: 16)),
              ...items.map<Widget>((item) {
                return Text("- ${item['name']} (Rp ${item['price']})");
              }).toList(),
              SizedBox(height: 8),
              Text("Total: Rp $total", style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text("Alamat: $address", style: TextStyle(fontSize: 16)),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () => sendToDashboardDriver(context),
                  child: Text("Kirim ke Dashboard Driver"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
