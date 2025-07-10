import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackingPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const TrackingPage({Key? key, required this.item}) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late Future<String> statusFuture;

  @override
  void initState() {
    super.initState();
    statusFuture = fetchStatus();
  }

  Future<String> fetchStatus() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/admin/pesanan?status=accepted'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'];

      if (data is List && data.isNotEmpty) {
        final status = data[0]['status'] ?? 'pending';
        print('API STATUS: $status');
        return status;
      } else if (data is Map<String, dynamic>) {
        final status = data['status'] ?? 'pending';
        print('API STATUS: $status');
        return status;
      } else {
        return 'pending';
      }
    } else {
      throw Exception('Gagal mengambil status dari API');
    }
  }

  int getCurrentStep(String status) {
    switch (status) {
      case 'accepted':
        return 1;
      case 'cooking':
        return 2;
      case 'on_delivery':
        return 3;
      case 'done':
        return 4;
      default:
        return 1; // fallback minimal step = 1 supaya icon pertama tetap aktif
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.item['total'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<String>(
          future: statusFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final status = snapshot.data ?? 'pending';
              final step = getCurrentStep(status);

              print('STATUS: $status, STEP: $step');

              return SingleChildScrollView(
                child: Column(
                  children: [
                    
  Padding(
  padding: const EdgeInsets.all(16),
  child: Center(
    child: Image.asset(
      'images/shopping.gif',
      width: 120, // Ukuran lebih besar, sesuaikan
      height: 120,
      fit: BoxFit.contain,
    ),
  ),
),


                    const Divider(),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Delivery Time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Estimated 8:30 - 9:15 PM",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTrackingIcon(Icons.event_note, true), // icon pertama selalu aktif
                          _buildDashedLine(),
                          _buildTrackingIcon(Icons.restaurant, step >= 2),
                          _buildDashedLine(),
                          _buildTrackingIcon(Icons.delivery_dining, step >= 3),
                          _buildDashedLine(),
                          _buildTrackingIcon(Icons.check_circle, step >= 4),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Order",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Pesanan",
                                  style: TextStyle(fontSize: 15)),
                              Text("Rp $total",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTrackingIcon(IconData icon, bool isActive) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isActive ? Colors.orange : Colors.grey[300],
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildDashedLine() {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.orange,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
