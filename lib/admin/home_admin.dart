import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'order_onprogress.dart'; // ✅ Import halaman tujuan

class HomeAdminPage extends StatelessWidget {
  final String adminName;
  final String adminEmail;
  final Map<String, dynamic> latestOrder;

  const HomeAdminPage({
    Key? key,
    required this.adminName,
    required this.adminEmail,
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
                  "$formattedDate",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    formattedTime,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Order Hari Ini",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "2", // jumlah order dinamis jika perlu
                        style: TextStyle(color: Colors.white, fontSize: 36),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.white70, size: 24),
                      SizedBox(width: 8),
                      Icon(Icons.circle_outlined,
                          color: Colors.white70, size: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // View All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("View All",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  Text("Waktu: $timestamp",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  SizedBox(height: 12),
                  Text("Item Pembelian:",
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
                                content: Text("Pesanan di-ACC"),
                                backgroundColor: Colors.green),
                          );
                          // Navigasi ke halaman OrderOnProgressPage sambil bawa data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderOnProgressPage(
                                orders: [latestOrder],
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.check),
                        label: Text("ACC"),
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
        backgroundColor: Colors.red,
      ),
    );
    // Tidak perlu pop, cukup tetap di halaman ini
    // Jika mau tambahkan logika lain (misalnya update UI), lakukan di sini
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
                // Navigasi ke halaman OrderOnProgressPage tanpa data baru
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderOnProgressPage(
                      orders: [latestOrder], // Atur list orders di sini
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: StadiumBorder(),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Order On Progress",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
