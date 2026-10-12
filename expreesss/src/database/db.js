import mysql from 'mysql2/promise';

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '', // Sesuaikan jika MySQL kamu ada password
  database: 'db_blog_app',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

export default pool;