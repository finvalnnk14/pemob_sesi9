import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PembayaranPage extends StatefulWidget {
  final List<Map<String, String>> cart;
  final VoidCallback onBayar;
  final Function(int) onRemove;

  const PembayaranPage({
    Key? key,
    required this.cart,
    required this.onBayar,
    required this.onRemove,
  }) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  bool isLoading = false;

  int _calculateTotal() {
    return widget.cart.fold(0, (total, item) => total + int.parse(item['price']!));
  }

  Future<void> _submitPembayaran() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("http://localhost:3000/api/order"); // ganti dengan endpoint kamu

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "items": widget.cart,
          "total": _calculateTotal(),
          "timestamp": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pembayaran berhasil!")),
        );
        widget.onBayar(); // kosongkan cart

         // Kirim data ke halaman admin
         
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan ke database.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.cart.isEmpty
              ? Center(child: Text("Belum ada produk ditambahkan."))
              : ListView.builder(
                  itemCount: widget.cart.length,
                  itemBuilder: (context, index) {
                    final item = widget.cart[index];
                    return ListTile(
                      leading: Image.asset(item['image']!, width: 50, height: 50),
                      title: Text(item['name']!),
                      subtitle: Text("Rp ${item['price']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.onRemove(index),
                      ),
                    );
                  },
                ),
        ),
        if (widget.cart.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.green,
            child: Column(
              children: [
                Text(
                  "Total: Rp ${_calculateTotal()}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  onPressed: isLoading ? null : _submitPembayaran,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text("Bayar Sekarang"),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
