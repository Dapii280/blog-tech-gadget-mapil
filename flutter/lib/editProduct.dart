import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductPage extends StatefulWidget {
  final Map product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late final titleController = TextEditingController(text: widget.product['title']);
  late final contentController = TextEditingController(text: widget.product['content']);
  late final categoryIdController = TextEditingController(text: widget.product['category_id'].toString());

  bool isSaving = false;

  Future<void> updateProduct() async {
    setState(() => isSaving = true);

    final response = await http.put(
      Uri.parse('http://localhost:3500/api/posts/${widget.product['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'content': contentController.text,
        'category_id': int.tryParse(categoryIdController.text) ?? 1,
      }),
    );

    setState(() => isSaving = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil memperbarui artikel tech')),
      );
      Navigator.pop(context, true); // Kembali ke HomePage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui artikel: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Artikel Tech')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Artikel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Isi / Konten Artikel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaving ? null : updateProduct,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Perbarui Artikel'),
            ),
          ],
        ),
      ),
    );
  }
}