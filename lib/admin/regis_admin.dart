import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pemob_sesi5/admin/login_admin.dart';

class RegisAdminPage extends StatefulWidget {
  @override
  _RegisAdminPageState createState() => _RegisAdminPageState();
}

class _RegisAdminPageState extends State<RegisAdminPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registeradmin() async {
    setState(() => _isLoading = true);

    final url = Uri.parse('http://localhost:3000/api/admin/daftar_admin'); // gunakan 10.0.2.2 di emulator Android

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nama": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registrasi berhasil')),
        );
        Navigator.pop(context); // Kembali ke login
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registrasi gagal')),
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
      appBar: AppBar(title: Text("Daftar Admin"), backgroundColor: Colors.green),
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
                    onPressed: _registeradmin,
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
            MaterialPageRoute(builder: (context) => LoginAdminPage()),
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
