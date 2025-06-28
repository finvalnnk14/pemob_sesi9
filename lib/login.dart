import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pemob_sesi5/admin/regis_admin.dart';
import 'package:pemob_sesi5/admin/login_admin.dart';
import 'package:pemob_sesi5/driver/regis_driver.dart';
import 'dart:convert';
import 'register.dart';
import 'main.dart'; // Arahkan ke halaman utama Marketplace


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ganti IP ini dengan IP komputer server backend kamu
      final url = Uri.parse('http://localhost:3000/api/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 && data['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MarketplacePanganPage()),
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
      appBar: AppBar(title: Text('Login'), backgroundColor: Colors.green),
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
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                   const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                "Belum punya akun? Daftar di sini",
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisAdminPage()),
                );
              },
              child: Text(
                "Ingin menjadi mitra? Daftar di sini",
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisDriverPage()),
                );
              },
              child: Text(
                "Ingin menjadi driver mitra? Daftar di sini",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

         