import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const TrackingPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nama = item['nama'] ?? 'Produk';
    final price = item['price'] ?? 0;
    final total = item['total'] ?? 0;
    final waktu = item['timestamp'] ?? '-';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header User Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                    ),
                    SizedBox(width: 12),
                    // Name & ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Cristopert Dastin',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('ID 213752', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    // Icons
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          child: Icon(Icons.message, color: Colors.orange),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          child: Icon(Icons.phone, color: Colors.orange),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              Divider(),

              // Delivery Time Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Your Delivery Time",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text("Estimated 8:30 - 9:15 PM",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),

              // Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTrackingIcon(Icons.event_note, true),
                    _buildDashedLine(),
                    _buildTrackingIcon(Icons.restaurant, true),
                    _buildDashedLine(),
                    _buildTrackingIcon(Icons.delivery_dining, false),
                    _buildDashedLine(),
                    _buildTrackingIcon(Icons.check_circle, false),
                  ],
                ),
              ),

              Divider(),

              // Order Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("2 $nama", style: TextStyle(fontSize: 15)),
                        Text("Rp $total", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
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
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
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
