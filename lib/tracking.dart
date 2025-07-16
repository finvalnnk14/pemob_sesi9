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
    statusFuture = fetchCombinedStatus();
  }

  Future<String> fetchCombinedStatus() async {
    try {
      // API dari Admin
      final responseAdmin = await http.get(
        Uri.parse('http://localhost:3000/api/admin/pesanan?status=accepted'),
        headers: {'Content-Type': 'application/json'},
      );

      // API dari Driver
      final responseDriver = await http.get(
        Uri.parse('http://localhost:3000/api/driver/terima?status=cooking'),
        headers: {'Content-Type': 'application/json'},
      );

      String adminStatus = 'pending';
      if (responseAdmin.statusCode == 200) {
        final body = jsonDecode(responseAdmin.body);
        final data = body['data'];
        if (data is List && data.isNotEmpty) {
          adminStatus = data[0]['status'] ?? 'pending';
        } else if (data is Map<String, dynamic>) {
          adminStatus = data['status'] ?? 'pending';
        }
      }

      String driverStatus = 'pending';
      if (responseDriver.statusCode == 200) {
        final body = jsonDecode(responseDriver.body);
        final data = body['data'];
        if (data is List && data.isNotEmpty) {
          driverStatus = data[0]['status'] ?? 'pending';
        } else if (data is Map<String, dynamic>) {
          driverStatus = data['status'] ?? 'pending';
        }
      }

      print('Admin Status: $adminStatus');
      print('Driver Status: $driverStatus');

      if (driverStatus != 'pending') {
        return driverStatus;
      } else {
        return adminStatus;
      }
    } catch (e) {
      print("Error fetching status: $e");
      return 'pending';
    }
  }

  Future<void> refreshStatus() async {
    setState(() {
      statusFuture = fetchCombinedStatus();
    });
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
        return 1;
    }
  }

  String getImageForStep(int step) {
    if (step >= 4) return 'images/done.gif';
    if (step >= 3) return 'images/delivery.gif';
    if (step >= 2) return 'images/driver.gif';
    return 'images/shopping.gif';
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.item['total'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tracking Pesanan"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshStatus,
          )
        ],
      ),
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
                          getImageForStep(step),
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Delivery Time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Estimated 8:30 - 9:15 PM",
                              style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTrackingIcon(Icons.event_note, true),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              const Text("Pesanan", style: TextStyle(fontSize: 15)),
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
