import pool from '../config/db.js';

// API Lấy tất cả danh mục
export const getCategories = async (req, res) => {
  try {
    // Truy vấn lấy toàn bộ bảng categories
    const [rows] = await pool.execute('SELECT * FROM categories');

    res.json({
      success: true,
      message: 'Lấy danh sách danh mục thành công',
      data: rows
    });
  } catch (error) {
    console.error('Get Categories Error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server khi lấy danh mục'
    });
  }
};