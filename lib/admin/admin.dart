import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pemob_sesi5/login.dart';
import 'home_admin.dart';

class AdminDashboardPage extends StatefulWidget {
  final String adminName;
  final String adminEmail;

  const AdminDashboardPage({
    Key? key,
    required this.adminName,
    required this.adminEmail,
  }) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('http://localhost:3000/api/order');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          orders = data;
          isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil data pesanan");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return Center(child: Text("Belum ada order terbaru."));
    }

    final latestOrder = orders[0];

    return HomeAdminPage(
      adminName: widget.adminName,
      adminEmail: widget.adminEmail,
      latestOrder: latestOrder,
    );
  }

  Widget _buildHistoryPage() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return Center(child: Text("Belum ada data pembayaran yang diterima."));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Riwayat Pembayaran",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = order['items'];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text("Total: Rp ${order['total']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Waktu: ${order['timestamp']}"),
                      SizedBox(height: 4),
                      if (items != null && items is List)
                        ...List<Widget>.from((items as List).map((item) {
                          final itemName = item['name'] ?? 'Produk';
                          final itemPrice = item['price'] ?? '0';
                          return Text("- $itemName (Rp $itemPrice)");
                        }))
                      else
                        Text("Data item tidak tersedia"),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 80, color: Colors.green),
          SizedBox(height: 12),
          Text(widget.adminName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(widget.adminEmail, style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.logout),
            label: Text("Logout"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      _buildHistoryPage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
        backgroundColor: Colors.green[800],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
