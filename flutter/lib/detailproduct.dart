import 'package:flutter/material.dart';
import 'editproduct.dart';

class DetailProductPage extends StatelessWidget {
  final Map product;
  const DetailProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['title'] ?? 'Detail Artikel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(product: product),
                ),
              );
              if (result == true) {
                Navigator.pop(context, true); // Kembali & refresh HomePage
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              product['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text('Kategori: ${product['category_name'] ?? '-'}'),
              backgroundColor: Colors.blue.shade50,
            ),
            const SizedBox(height: 16),
            Text(
              product['content'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}