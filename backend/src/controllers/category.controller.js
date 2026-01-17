import pool from '../config/db.js';

export const getCategories = async (req, res) => {
  try {
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
export const getCategoryId = async (req, res) => {
  const { id } = req.params;

  if (!id || isNaN(id)) {
    return res.status(400).json({
      success: false,
      message: 'ID không hợp lệ'
    });
  }

  try {
    const [rows] = await pool.execute(
      'SELECT * FROM animals WHERE category_id = ?',
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy danh mục'
      });
    }

    res.json({
      success: true,
      message: 'Lấy danh mục thành công',
      data: rows
    });

  } catch (error) {
    console.error('Get Category By ID Error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server khi lấy danh mục'
    });
  }
};

