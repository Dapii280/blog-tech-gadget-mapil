DROP DATABASE IF EXISTS db_blog_app;
CREATE DATABASE db_blog_app;
USE db_blog_app;

-- Tabel Categories
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Isi Data Kategori Tech
INSERT INTO categories (id, name) VALUES 
(1, 'Laptop & PC'),
(2, 'Peripheral'),
(3, 'Software & Gaming');

-- Tabel Posts
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Isi Data Artikel Tech
INSERT INTO posts (category_id, title, content) VALUES 
(1, 'Tips Memilih Laptop untuk Coding dan RPL', 'Untuk kebutuhan rekayasa perangkat lunak dan kompilasi proyek yang berat, laptop dengan RAM minimal 16GB dan media penyimpanan SSD NVMe sangat disarankan agar performa multitasking tetap lancar.'),
(2, 'Kelebihan Keyboard Mechanical Layout 65 Persen', 'Mechanical keyboard dengan layout 65 persen memberikan keseimbangan antara ukuran meja yang ringkas dan fungsionalitas karena tetap mempertahankan tombol panah dedikasi.'),
(3, 'Panduan Setup Terminal Nushell dan Fastfetch', 'Menggunakan terminal Nushell dikombinasikan dengan Fastfetch membuat produktivitas dalam menjelajahi direktori dan eksekusi perintah perintah CLI menjadi lebih cepat dan estetis.');