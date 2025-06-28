import 'package:flutter/material.dart';
import 'package:pemob_sesi5/driver/login_driver.dart'; // Import halaman login driver

class DriverDashboardPage extends StatelessWidget {
  final String driverName;
  final String driverEmail;

  const DriverDashboardPage({
    Key? key,
    required this.driverName,
    required this.driverEmail,
  }) : super(key: key);

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginDriverPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Driver'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang, $driverName!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Email: $driverEmail',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
