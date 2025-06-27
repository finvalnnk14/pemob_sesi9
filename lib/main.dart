import 'package:flutter/material.dart';
import 'pembayaran.dart';
import 'login.dart';
import 'register.dart';
import 'history.dart'; // Import halaman History
import 'admin/regis_admin.dart';
import 'package:pemob_sesi5/admin/login_admin.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // wajib jika pakai async di main
  await initializeDateFormatting('id_ID', null); // inisialisasi locale Indonesia
  runApp(MaterialApp(
    home: LoginPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MarketplacePanganPage extends StatefulWidget {
  @override
  _MarketplacePanganPageState createState() => _MarketplacePanganPageState();
}

class _MarketplacePanganPageState extends State<MarketplacePanganPage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  final List<Map<String, String>> _allProducts = [
    {'name': 'Beras', 'image': 'images/beras.jpg', 'price': '15000'},
    {'name': 'Minyak Goreng', 'image': 'images/minyak.jpeg', 'price': '20000'},
    {'name': 'Telur', 'image': 'images/telur.jpeg', 'price': '18000'},
    {'name': 'Gula Pasir', 'image': 'images/gula.jpg', 'price': '13000'},
    {'name': 'Daging Ayam', 'image': 'images/ayam.jpg', 'price': '35000'},
    {'name': 'Daging Sapi', 'image': 'images/sapi.jpg', 'price': '70000'},
    {'name': 'Sayur Bayam', 'image': 'images/bayam.jpg', 'price': '5000'},
    {'name': 'Cabe Merah', 'image': 'images/cabe.jpg', 'price': '25000'},
    {'name': 'Bawang Merah', 'image': 'images/bawang_merah.jpg', 'price': '30000'},
    {'name': 'Bawang Putih', 'image': 'images/bawang_putih.jpg', 'price': '28000'},
    {'name': 'Tomat', 'image': 'images/tomat.jpg', 'price': '8000'},
  ];

  List<Map<String, String>> _filteredProducts = [];
  List<Map<String, String>> _cart = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  void _filterSearch(String query) {
    final results = _allProducts
        .where((item) =>
            item['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredProducts = results;
    });
  }

  void _addToCart(Map<String, String> product) {
    setState(() {
      _cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product['name']} ditambahkan ke keranjang."),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildContent() {
    if (_currentIndex == 0) {
      // Halaman Produk
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari bahan pangan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _filterSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(child: Text("Tidak ditemukan hasil."))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.asset(
                                    product['image']!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      product['name']!,
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Rp ${product['price']}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700]),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle,
                                          color: Colors.green),
                                      onPressed: () => _addToCart(product),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    } else if (_currentIndex == 1) {
      // Halaman Pembayaran
      return PembayaranPage(
        cart: _cart,
        onRemove: (index) {
          setState(() {
            _cart.removeAt(index);
          });
        },
        onBayar: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Pembayaran berhasil!")),
          );
          setState(() {
            _cart.clear();
          });
        },
      );
    } else if (_currentIndex == 2) {
      // Halaman Riwayat Belanja
      return HistoryPage(); // Panggil halaman history.dart
    } else {
      // Halaman Profil
      return Center(
        child: Text("Halaman Profil", style: TextStyle(fontSize: 20)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodNest"),
        backgroundColor: Colors.green,
      ),
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pembayaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat Belanja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
