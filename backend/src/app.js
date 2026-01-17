import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import cors from 'cors';

import authRoutes from './routes/auth.routes.js';
import categoryRoutes from './routes/category.routes.js';
import animalRoutes from './routes/animal.routes.js';

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/auth', authRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/animals', animalRoutes);

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'API is running 🚀'
  });
});

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route không tồn tại'
  });
});

export default app;
