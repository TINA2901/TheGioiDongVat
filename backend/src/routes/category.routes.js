import express from 'express';
import { getCategories , getCategoryId} from '../controllers/category.controller.js';

const router = express.Router();

router.get('/', getCategories);
router.get('/:id', getCategoryId);


export default router;