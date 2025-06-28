import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pemob_sesi5/driver/login_driver.dart'; // Ganti sesuai path file login driver

class RegisDriverPage extends StatefulWidget {
  @override
  _RegisDriverPageState createState() => _RegisDriverPageState();
}

class _RegisDriverPageState extends State<RegisDriverPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registerDriver() async {
    setState(() => _isLoading = true);

    final url = Uri.parse('http://localhost:3000/api/driver/daftar_driver'); // Ganti localhost jadi 10.0.2.2 kalau pakai emulator Android

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nama_driver": _nameController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registrasi driver berhasil')),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registrasi driver gagal')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Driver"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
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
                    onPressed: _registerDriver,
                    child: Text('Daftar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginDriverPage()),
                );
              },
              child: Text(
                "Sudah punya akun? Login di sini",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
