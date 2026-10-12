import express from 'express';
import cors from 'cors';
import { z } from 'zod';
import pool from './db.js';

const app = express();
const PORT = 3500;

// Middleware
app.use(cors());
app.use(express.json());

// ==========================================
// SCHEMA VALIDASI ZOD
// ==========================================

const categorySchema = z.object({
  name: z.string().min(3, { message: "Nama kategori minimal 3 karakter" })
});

const postSchema = z.object({
  title: z.string().min(3, { message: "Judul artikel minimal 3 karakter" }),
  content: z.string().min(10, { message: "Konten artikel minimal 10 karakter" }),
  category_id: z.number({ invalid_type_error: "Category ID harus berupa angka" }).int()
});

// ==========================================
// ENDPOINT CATEGORIES
// ==========================================

// GET /api/categories - Ambil semua kategori
app.get('/api/categories', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM categories');
    return res.status(200).json({
      message: 'Berhasil mengambil data kategori tech',
      data: rows
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal mengambil data kategori',
      error: error.message
    });
  }
});

// POST /api/categories - Tambah kategori baru
app.post('/api/categories', async (req, res) => {
  try {
    const parseResult = categorySchema.safeParse(req.body);

    if (!parseResult.success) {
      return res.status(400).json({
        message: 'Validasi data gagal',
        error: parseResult.error.errors
      });
    }

    const { name } = parseResult.data;
    const [result] = await pool.query(
      'INSERT INTO categories (name) VALUES (?)',
      [name]
    );

    return res.status(201).json({
      message: 'Kategori tech berhasil ditambahkan',
      data: {
        id: result.insertId,
        name
      }
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal menambahkan kategori',
      error: error.message
    });
  }
});

// DELETE /api/categories/:id - Hapus kategori berdasarkan ID
app.delete('/api/categories/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query('DELETE FROM categories WHERE id = ?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: 'Kategori tidak ditemukan'
      });
    }

    return res.status(200).json({
      message: 'Kategori berhasil dihapus'
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal menghapus kategori',
      error: error.message
    });
  }
});

// ==========================================
// ENDPOINT POSTS (ARTIKEL TECH)
// ==========================================

// GET /api/posts - Ambil semua artikel
app.get('/api/posts', async (req, res) => {
  try {
    const query = `
      SELECT posts.*, categories.name AS category_name 
      FROM posts 
      LEFT JOIN categories ON posts.category_id = categories.id
    `;
    const [rows] = await pool.query(query);

    return res.status(200).json({
      message: 'Berhasil mengambil semua artikel tech',
      data: rows
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal mengambil artikel',
      error: error.message
    });
  }
});

// GET /api/posts/:id - Ambil detail 1 artikel berdasarkan ID
app.get('/api/posts/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const query = `
      SELECT posts.*, categories.name AS category_name 
      FROM posts 
      LEFT JOIN categories ON posts.category_id = categories.id 
      WHERE posts.id = ?
    `;
    const [rows] = await pool.query(query, [id]);

    if (rows.length === 0) {
      return res.status(404).json({
        message: 'Artikel tech tidak ditemukan'
      });
    }

    return res.status(200).json({
      message: 'Berhasil mengambil detail artikel tech',
      data: rows[0]
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal mengambil detail artikel',
      error: error.message
    });
  }
});

// POST /api/posts - Tambah artikel tech baru
app.post('/api/posts', async (req, res) => {
  try {
    const parseResult = postSchema.safeParse(req.body);

    if (!parseResult.success) {
      return res.status(400).json({
        message: 'Validasi data gagal',
        error: parseResult.error.errors
      });
    }

    const { title, content, category_id } = parseResult.data;

    const [result] = await pool.query(
      'INSERT INTO posts (title, content, category_id) VALUES (?, ?, ?)',
      [title, content, category_id]
    );

    return res.status(201).json({
      message: 'Artikel tech berhasil ditambahkan',
      data: {
        id: result.insertId,
        title,
        content,
        category_id
      }
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal menambahkan artikel',
      error: error.message
    });
  }
});

// PUT /api/posts/:id - Update artikel tech berdasarkan ID
app.put('/api/posts/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const parseResult = postSchema.safeParse(req.body);

    if (!parseResult.success) {
      return res.status(400).json({
        message: 'Validasi data gagal',
        error: parseResult.error.errors
      });
    }

    const { title, content, category_id } = parseResult.data;

    const [result] = await pool.query(
      'UPDATE posts SET title = ?, content = ?, category_id = ? WHERE id = ?',
      [title, content, category_id, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: 'Artikel tech tidak ditemukan'
      });
    }

    return res.status(200).json({
      message: 'Artikel tech berhasil diperbarui',
      data: {
        id: Number(id),
        title,
        content,
        category_id
      }
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal memperbarui artikel',
      error: error.message
    });
  }
});

// DELETE /api/posts/:id - Hapus artikel tech berdasarkan ID
app.delete('/api/posts/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query('DELETE FROM posts WHERE id = ?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: 'Artikel tech tidak ditemukan'
      });
    }

    return res.status(200).json({
      message: 'Artikel tech berhasil dihapus'
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Gagal menghapus artikel',
      error: error.message
    });
  }
});

// ==========================================
// RUN SERVER
// ==========================================
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});