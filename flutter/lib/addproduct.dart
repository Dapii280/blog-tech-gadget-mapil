import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final categoryIdController = TextEditingController();
  bool isSaving = false;

  Future<void> addProduct() async {
    setState(() => isSaving = true);

    // IP Emulator: 10.0.2.2 | IP HP Fisik: Ganti IP Laptop
    final response = await http.post(
      Uri.parse('http://localhost:3500/api/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'content': contentController.text,
        'category_id': int.tryParse(categoryIdController.text) ?? 1,
      }),
    );

    setState(() => isSaving = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menyimpan artikel tech')),
      );
      Navigator.pop(context, true); // Kembali ke HomePage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan artikel: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Artikel Tech')),
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
                labelText: 'ID Kategori (Contoh: 1=Laptop, 2=Peripheral, 3=Software)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaving ? null : addProduct,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan Artikel'),
            ),
          ],
        ),
      ),
    );
  }
}