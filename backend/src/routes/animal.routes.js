import express from 'express';
import { getAnimalById } from '../controllers/animal.controller.js';

const router = express.Router();

router.get('/:id', getAnimalById);


export default router;