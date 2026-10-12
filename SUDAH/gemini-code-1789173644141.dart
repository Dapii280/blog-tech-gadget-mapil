import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addproduct.dart';
import 'editproduct.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List product = [];

  Future<void> getProduct() async {
    final response = await http.get(
      Uri.parse("http://localhost:3500/api/posts"),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        product = responseData['data']; // Mengambil array data dari Express
      });
    } else {
      print("data gagal di ambil");
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3500/api/posts/$id'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel Berhasil Dihapus')),
      );

      setState(() {
        product.removeWhere((item) => item['id'] == id);
      });
    } else {
      print('Gagal menghapus produk: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Tech & Gadget'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: product.length,
        itemBuilder: (context, index) {
          final itemProduct = product[index];

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductPage(product: itemProduct),
                  ),
                );
                if (result == true) {
                  getProduct(); // Auto refresh daftar setelah update
                }
              },
              child: ListTile(
                leading: const Icon(Icons.article, size: 36, color: Colors.blue),
                title: Text(itemProduct["title"] ?? ""),
                subtitle: Text(
                  'Kategori: ${itemProduct["category_name"] ?? "-"}\n${itemProduct["content"] ?? ""}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () {
                    deleteProduct(itemProduct['id']);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductPage(),
            ),
          );
          if (result == true) {
            getProduct(); // Auto refresh daftar setelah simpan
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}