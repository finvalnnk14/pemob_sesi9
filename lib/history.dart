import 'package:flutter/material.dart';
import 'main.dart';

class HistoryPage extends StatelessWidget {
  final List<List<Map<String, String>>> history;

  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Belanja')),
      body: history.isEmpty
          ? Center(child: Text("Belum ada riwayat belanja."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final transaksi = history[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Transaksi #${index + 1}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green)),
                      ),
                      ...transaksi.map((item) => ListTile(
                            leading: Image.asset(item['image']!, width: 40),
                            title: Text(item['name']!),
                            subtitle: Text("Rp ${item['price']}"),
                          )),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
