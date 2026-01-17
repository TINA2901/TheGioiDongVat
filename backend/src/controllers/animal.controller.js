import pool from '../config/db.js';

// API Lấy chi tiết 1 con vật theo ID
export const getAnimalById = async (req, res) => {
  // 1. Lấy id từ đường dẫn (URL params)
  const { id } = req.params;

  if (!id) {
    return res.status(400).json({ success: false, message: 'Thiếu ID động vật' });
  }

  try {
    // 2. Query Database
    // Mẹo: Bạn có thể JOIN với bảng categories để lấy luôn tên loài nếu muốn
    const query = `
      SELECT animals.*
      FROM animals 
      LEFT JOIN categories ON animals.category_id = categories.id
      WHERE animals.id = ?
    `;
    
    const [rows] = await pool.execute(query, [id]);

    // 3. Kiểm tra xem có dữ liệu không
    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy động vật này'
      });
    }

    // 4. Trả về kết quả (chỉ lấy phần tử đầu tiên vì id là duy nhất)
    res.json({
      success: true,
      data: rows[0]
    });

  } catch (error) {
    console.error('Get Animal Detail Error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};
