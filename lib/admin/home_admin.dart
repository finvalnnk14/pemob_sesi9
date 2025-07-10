import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // ✅ Import http
import 'dart:convert'; // ✅ Untuk jsonEncode
import 'order_onprogress.dart'; // ✅ Import halaman tujuan

class HomeAdminPage extends StatefulWidget {
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
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  Future<void> accOrder() async {
    final url = Uri.parse('http://192.168.2.30:3000/api/admin/pesanan'); // ✅ Ganti URL API
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'orderId': widget.latestOrder['id'],
          'status': 'accepted',
          'adminName': widget.adminName,
          'adminEmail': widget.adminEmail,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pesanan berhasil di-ACC & disimpan!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengirim data ke server"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.latestOrder['items'] ?? [];
    final total = widget.latestOrder['total'];
    final timestamp = widget.latestOrder['timestamp'];

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
  onPressed: () async {
    final url = Uri.parse('http://localhost:3000/api/admin/pesanan');
    try {
      final response = await http.post(
  url,
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'status': 'accepted',
    'total': widget.latestOrder['total'],
  }),
);


      if (response.statusCode == 200) {
        // ✅ Berhasil simpan ke database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pesanan berhasil di-ACC & disimpan!"),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Setelah berhasil baru pindah halaman
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderOnProgressPage(
              orders: [widget.latestOrder],
            ),
          ),
        );
      } else {
        // Gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menyimpan ke database"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                    builder: (context) => OrderOnProgressPage(
                      orders: [widget.latestOrder],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: StadiumBorder(),
                minimumSize: Size(double.infinity, 50),
              ),
              child:
                  Text("Order On Progress", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
