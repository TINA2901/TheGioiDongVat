import express from 'express';
import { getAnimalById } from '../controllers/animal.controller.js';

const router = express.Router();

// Định nghĩa: GET /api/animals/123
router.get('/:id', getAnimalById);

export default router;