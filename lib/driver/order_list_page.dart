import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'kontak_driver.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<dynamic> pengirimanList = [];

  @override
  void initState() {
    super.initState();
    fetchPengiriman();
  }

  Future<void> fetchPengiriman() async {
    // GANTI localhost ke IP LAN kamu!
    final url = Uri.parse('http://localhost:3000/api/driver');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        pengirimanList = data;
      });
    } else {
      debugPrint('Gagal mengambil data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengiriman'),
      ),
      body: pengirimanList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pengirimanList.length,
              itemBuilder: (context, index) {
                final pengiriman = pengirimanList[index];
                return ListTile(
                  title: Text(pengiriman['username']),
                  subtitle: Text('ID: ${pengiriman['id']} | Status: ${pengiriman['status']}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KontakDriverPage(
                          customerName: pengiriman['username'] ?? 'Unknown',
                          customerId: pengiriman['id'].toString(),
                          imageUrl: '',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
