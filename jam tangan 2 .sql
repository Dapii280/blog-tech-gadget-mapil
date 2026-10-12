DROP DATABASE IF EXISTS db_blog_app;
CREATE DATABASE db_blog_app;
USE db_blog_app;

-- ===================================================
-- 1. STRUKTUR TABEL BLOG (DARI KODINGAN AWAL KAMU)
-- ===================================================

-- Tabel Categories
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO categories (id, name) VALUES 
(1, 'Laptop & PC'),
(2, 'Peripheral'),
(3, 'Software & Gaming'),
(4, 'Mobile & Tablet');

-- Tabel Posts
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    views INT DEFAULT 0 CHECK (views >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

INSERT INTO posts (category_id, title, content, views) VALUES 
(1, 'Tips Memilih Laptop untuk Coding dan RPL', 'Untuk kebutuhan rekayasa perangkat lunak...', 150),
(2, 'Kelebihan Keyboard Mechanical Layout 65 Persen', 'Mechanical keyboard dengan layout 65 persen...', 200),
(3, 'Panduan Setup Terminal Nushell dan Fastfetch', 'Menggunakan terminal Nushell dikombinasikan...', 95),
(2, 'Rekomendasi Deskmat Topografi Terbaik', 'Ulasan lengkap deskmat motif topografi...', 310);


-- ===================================================
-- 2. STRUKTUR TABEL TOKO & PEGAWAI (DARI PPT 2)
-- ===================================================

-- Tabel Cabang
CREATE TABLE tb_cabang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_cabang VARCHAR(50) NOT NULL
);

INSERT INTO tb_cabang (id, nama_cabang) VALUES 
(1, 'Cabang Jakarta'),
(2, 'Cabang Bandung'),
(3, 'Cabang Depok');

-- Tabel Pegawai
CREATE TABLE tb_pegawai (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cabang INT NOT NULL,
    nama_pegawai VARCHAR(100) NOT NULL,
    gaji INT NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    FOREIGN KEY (id_cabang) REFERENCES tb_cabang(id) ON DELETE CASCADE
);

INSERT INTO tb_pegawai (id_cabang, nama_pegawai, gaji, jenis_kelamin) VALUES 
(1, 'Ardian', 4500000, 'L'),
(1, 'Syifa', 3500000, 'P'),
(2, 'Rafiq', 4000000, 'L'),
(2, 'Cyntia', 5000000, 'P');


-- ===================================================
-- 3. KUMPULAN QUERY DDL & DML (PPT 1 & PPT 2)
-- ===================================================

-- A. DDL (ALTER & DESCRIBE)
ALTER TABLE posts ADD COLUMN author VARCHAR(50) DEFAULT 'Admin';
DESCRIBE posts;
DESCRIBE tb_pegawai;

-- B. DML DASAR (SELECT, WHERE, UPDATE, DELETE)
SELECT * FROM categories;
SELECT nama_pegawai, gaji FROM tb_pegawai WHERE gaji > 4000000;
UPDATE posts SET title = 'Tips Laptop Coding RPL 2026' WHERE id = 1;
DELETE FROM posts WHERE id = 3;

-- C. JOIN 2 TABEL (MENAMPILKAN NAMA CABANG & GAJI)
SELECT 
    c.nama_cabang, 
    p.nama_pegawai, 
    p.gaji
FROM tb_pegawai p
JOIN tb_cabang c ON p.id_cabang = c.id;

-- D. LEFT JOIN (MENAMPILKAN SEMUA CABANG TERMASUK YANG BELUM ADA PEGAWAI)
SELECT 
    c.nama_cabang, 
    p.nama_pegawai
FROM tb_cabang c
LEFT JOIN tb_pegawai p ON p.id_cabang = c.id;

-- E. AGGREGATE FUNCTION & GROUP BY (SUM & COUNT)
-- Tampilkan total gaji per cabang
SELECT 
    c.nama_cabang, 
    SUM(p.gaji) AS total_gaji
FROM tb_cabang c
JOIN tb_pegawai p ON p.id_cabang = c.id
GROUP BY c.id, c.nama_cabang;

-- Hitung jumlah pegawai per cabang
SELECT 
    c.nama_cabang, 
    COUNT(p.id) AS jumlah_pegawai
FROM tb_cabang c
LEFT JOIN tb_pegawai p ON p.id_cabang = c.id
GROUP BY c.id, c.nama_cabang;

-- F. ORDER BY & LIMIT
-- Tampilkan 3 pegawai dengan gaji tertinggi
SELECT nama_pegawai, gaji 
FROM tb_pegawai 
ORDER BY gaji DESC 
LIMIT 3;