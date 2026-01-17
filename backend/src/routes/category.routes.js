import express from 'express';
import { getCategories } from '../controllers/category.controller.js';

const router = express.Router();

// Định nghĩa đường dẫn GET /api/categories
router.get('/', getCategories);

export default router;