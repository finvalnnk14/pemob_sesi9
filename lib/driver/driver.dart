import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'order_onprogress_driver.dart';

class DriverDashboardPage extends StatefulWidget {
  final String driverName;
  final String driverEmail;

  const DriverDashboardPage({
    Key? key,
    required this.driverName,
    required this.driverEmail,
  }) : super(key: key);

  @override
  State<DriverDashboardPage> createState() => _DriverDashboardPageState();
}

class _DriverDashboardPageState extends State<DriverDashboardPage> {
  Map<String, dynamic> latestOrder = {};

  @override
  void initState() {
    super.initState();
    fetchLatestOrder();
  }

  Future<void> fetchLatestOrder() async {
  final url = Uri.parse('http://localhost:3000/api/admin/pesanan');
  try {
    final response = await http.get(url);
    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Parsed: $data");
      setState(() {
        latestOrder = data;
      });
    } else {
      print("Failed: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    final items = latestOrder['items'] ?? [];
    final total = latestOrder['total'] ?? 0;
    final timestamp = latestOrder['timestamp'] ?? '-';

    final formattedDate =
        DateFormat("EEEE, dd/MM/yyyy", "id_ID").format(DateTime.now());
    final formattedTime = DateFormat("HH:mm:ss").format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dashboard Driver"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchLatestOrder,
          )
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, ${widget.driverName}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text(
                  "$formattedDate",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    formattedTime,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Pesanan Terbaru",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.local_shipping,
                          color: Colors.white, size: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Order Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: latestOrder.isEmpty
                  ? Center(
                      child: Text(
                        "Belum ada pesanan.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Pembayaran: Rp $total",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Waktu Pesanan: $timestamp",
                            style:
                                TextStyle(color: Colors.grey[600], fontSize: 12)),
                        SizedBox(height: 12),
                        Text("Detail Pesanan:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        if (items is List)
                          ...items.map((item) {
                            final itemName = item['name'] ?? 'Produk';
                            final itemPrice = item['price'] ?? '0';
                            return Text("- $itemName (Rp $itemPrice)");
                          }).toList()
                        else
                          Text("Data item tidak tersedia"),
                        SizedBox(height: 16),

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Pesanan diterima"),
                                      backgroundColor: Colors.green),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderOnProgressDriverPage(
                                      orders: [latestOrder],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.check),
                              label: Text("Terima"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: StadiumBorder(),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Pesanan ditolak"),
                                      backgroundColor: Colors.red),
                                );
                                // Tambah logika tolak kalau perlu
                              },
                              icon: Icon(Icons.close),
                              label: Text("Tolak"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: StadiumBorder(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
            ),
          ),

          Spacer(),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (latestOrder.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderOnProgressDriverPage(
                        orders: [latestOrder],
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Belum ada pesanan.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: StadiumBorder(),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Lihat Pesanan Berjalan",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
