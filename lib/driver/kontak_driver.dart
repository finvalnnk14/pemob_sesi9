import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KontakDriverPage extends StatelessWidget {
  final String customerName;
  final String customerId;
  final String imageUrl;

  const KontakDriverPage({
    Key? key,
    required this.customerName,
    required this.customerId,
    required this.imageUrl,
  }) : super(key: key);

  // Fungsi untuk membuka WhatsApp ke nomor tertentu
  void _openWhatsApp() async {
    const phoneNumber = '6285838999169'; // Ganti 0 dengan 62 untuk kode negara Indonesia
    final url = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kontak Customer"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(color: Colors.grey, blurRadius: 5),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto profil
              CircleAvatar(
                radius: 30,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/default_user.png') as ImageProvider,
              ),
              const SizedBox(width: 12),

              // Nama dan ID Customer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "ID $customerId",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Ikon Chat dan Call
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat, color: Colors.orange),
                    onPressed: _openWhatsApp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
