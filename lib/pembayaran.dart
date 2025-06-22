import 'package:flutter/material.dart';

class PembayaranPage extends StatelessWidget {
  final List<Map<String, String>> cart;
  final VoidCallback onBayar;
  final Function(int) onRemove;

  const PembayaranPage({
    Key? key,
    required this.cart,
    required this.onBayar,
    required this.onRemove,
  }) : super(key: key);

  int _calculateTotal() {
    return cart.fold(0, (total, item) => total + int.parse(item['price']!));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: cart.isEmpty
              ? Center(child: Text("Belum ada produk ditambahkan."))
              : ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    return ListTile(
                      leading: Image.asset(item['image']!, width: 50, height: 50),
                      title: Text(item['name']!),
                      subtitle: Text("Rp ${item['price']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemove(index),
                      ),
                    );
                  },
                ),
        ),
        if (cart.isNotEmpty)
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
                  onPressed: onBayar,
                  child: Text("Bayar Sekarang"),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
