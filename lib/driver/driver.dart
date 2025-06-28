import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'order_onprogress_driver.dart'; // ✅ Import halaman tujuan

class DriverDashboardPage extends StatelessWidget {
  final String driverName;
  final String driverEmail;
  final Map<String, dynamic> latestOrder;

  const DriverDashboardPage({
    Key? key,
    required this.driverName,
    required this.driverEmail,
    required this.latestOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = latestOrder['items'] ?? [];
    final total = latestOrder['total'];
    final timestamp = latestOrder['timestamp'];

    final formattedDate =
        DateFormat("EEEE, dd/MM/yyyy", "id_ID").format(DateTime.now());
    final formattedTime = DateFormat("HH:mm:ss").format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dashboard Driver"),
        backgroundColor: Colors.orange,
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
                  "Halo, $driverName",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Pembayaran: Rp $total",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text("Waktu Pesanan: $timestamp",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
                              builder: (context) => OrderOnProgressDriverPage(
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
                          // Logika tambahan jika perlu
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderOnProgressDriverPage(
                      orders: [latestOrder],
                    ),
                  ),
                );
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
