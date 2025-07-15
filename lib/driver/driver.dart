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
    final url = Uri.parse('http://localhost:3000/api/driver/pengiriman');
    try {
      final response = await http.get(url);
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Parsed: $data");

        if (data is List && data.isNotEmpty) {
          // Urutkan kalau perlu, contoh:
          data.sort((a, b) =>
              DateTime.parse(b['timestamp'])
                  .compareTo(DateTime.parse(a['timestamp'])));

          setState(() {
            latestOrder = data.first; // Ambil pesanan terbaru
          });
        } else {
          print("Data kosong atau bukan list");
        }
      } else {
        print("Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    final harga = latestOrder['price'] ?? 0;
    final total = latestOrder['total'] ?? 0;
    final timestamp = latestOrder['timestamp'] ?? '-';
    final username = latestOrder['username'] ?? '-';
    final address = latestOrder['address'] ?? '-';

    final formattedDate =
        DateFormat("EEEE, dd/MM/yyyy", "id_ID").format(DateTime.now());
    final formattedTime = DateFormat("HH:mm:ss").format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard Driver"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchLatestOrder,
          )
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
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
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    formattedTime,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: latestOrder.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada pesanan.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Harga: Rp $harga",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("Total: Rp $total",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("Waktu Pesanan: $timestamp",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                        const SizedBox(height: 4),
                        Text("Username: $username",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),

                         Text("Alamat: $address",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
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
                              icon: const Icon(Icons.check),
                              label: const Text("Terima"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: const StadiumBorder(),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Pesanan ditolak"),
                                      backgroundColor: Colors.red),
                                );
                                // Tambah logika tolak kalau perlu
                              },
                              icon: const Icon(Icons.close),
                              label: const Text("Tolak"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
            ),
          ),

          const Spacer(),

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
                    const SnackBar(content: Text("Belum ada pesanan.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: const StadiumBorder(),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Lihat Pesanan Berjalan",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
