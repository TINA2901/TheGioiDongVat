import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../config/db.js';
import { JWT_SECRET } from '../middlewares/auth.middleware.js';

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
export const register = async (req, res) => {
  const { email, password, full_name } = req.body;
  console.log("JWT_SECRET:", JWT_SECRET);
  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Thiếu email hoặc mật khẩu'
    });
  }

  if (!EMAIL_REGEX.test(email)) {
    return res.status(400).json({
      success: false,
      message: 'Email không đúng định dạng'
    });
  }

  if (password.length < 6) {
    return res.status(400).json({
      success: false,
      message: 'Mật khẩu phải có ít nhất 6 ký tự'
    });
  }

  try {
    // Email là UNIQUE
    const [exist] = await pool.execute(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );

    if (exist.length > 0) {
      return res.status(409).json({
        success: false,
        message: 'Email đã tồn tại'
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    // full_name KHÔNG unique
    const finalName = full_name || email.split('@')[0];

    const [result] = await pool.execute(
      `INSERT INTO users (email, password, full_name, created_at)
       VALUES (?, ?, ?, NOW())`,
      [email, hashedPassword, finalName]
    );

    const token = jwt.sign(
      { id: result.insertId },
      JWT_SECRET,
      { expiresIn: '7d' },
      
    );
    
    res.status(201).json({
      success: true,
      message: 'Đăng ký thành công',
      token,
      user: {
        id: result.insertId,
        email,
        full_name: finalName
      }
    });

  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};


export const login = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Thiếu email hoặc mật khẩu'
    });
  }

  try {
    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Email hoặc mật khẩu không đúng'
      });
    }

    const user = rows[0];

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Email hoặc mật khẩu không đúng'
      });
    }

    const token = jwt.sign(
      {
        id: user.id,
        full_name: user.full_name
      },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    // 5. Response
    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        full_name: user.full_name
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server'
    });
  }
};
