import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MarketplacePanganPage(),
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
    {'name': 'Beras', 'image': 'images/beras.jpg'},
    {'name': 'Minyak Goreng', 'image': 'images/minyak.jpeg'},
    {'name': 'Telur', 'image': 'images/telur.jpeg'},
    {'name': 'Gula Pasir', 'image': 'images/gula.jpg'},
    {'name': 'Daging Ayam', 'image': 'images/ayam.jpg'},
    {'name': 'Daging Sapi', 'image': 'images/sapi.jpg'},
    {'name': 'Sayur Bayam', 'image': 'images/bayam.jpg'},
    {'name': 'Cabe Merah', 'image': 'images/cabe.jpg'},
    {'name': 'Bawang Merah', 'image': 'images/bawang_merah.jpg'},
    {'name': 'Bawang Putih', 'image': 'images/bawang_putih.jpg'},
    {'name': 'Tomat', 'image': 'images/tomat.jpg'},
  ];

  List<Map<String, String>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  void _filterSearch(String query) {
    final results = _allProducts
        .where((item) => item['name']!
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredProducts = results;
    });
  }

  Widget _buildContent() {
    if (_currentIndex == 0) {
      // Produk Page
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari bahan pangan...',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                        childAspectRatio: 3 / 4,
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
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.asset(
                                    product['image']!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name']!,
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
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
      // Pembayaran Page (Placeholder)
      return Center(
        child: Text("Halaman Pembayaran", style: TextStyle(fontSize: 20)),
      );
    } else {
      // Profile Page (Placeholder)
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
