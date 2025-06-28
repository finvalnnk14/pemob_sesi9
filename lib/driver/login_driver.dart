import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import halaman dashboard driver (pastikan file & class ini sudah dibuat)
import 'package:pemob_sesi5/driver/driver.dart';

class LoginDriverPage extends StatefulWidget {
  @override
  _LoginDriverPageState createState() => _LoginDriverPageState();
}

class _LoginDriverPageState extends State<LoginDriverPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ganti localhost -> 10.0.2.2 jika pakai Android emulator
      final url = Uri.parse('http://localhost:3000/api/driver/masuk_driver');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama_driver': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: $data');

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 && data['success'] == true) {
       Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => DriverDashboardPage(
      driverName: data['driver']['nama_driver'] ?? "Driver",
      driverEmail: "", // Kosongkan atau hapus kalau tidak perlu
    ),
  ),
);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: ${data['message']}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Driver'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login Driver'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
          ],
        ),
      ),
    );
  }
}
