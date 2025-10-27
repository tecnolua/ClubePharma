import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import { requireAdmin } from '../middlewares/adminAuth.js';
import {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  getCategories
} from '../controllers/productController.js';

const router = express.Router();

// Validation rules
const productValidation = [
  body('name').trim().notEmpty().withMessage('Product name is required'),
  body('description').trim().notEmpty().withMessage('Description is required'),
  body('price').isFloat({ min: 0 }).withMessage('Valid price is required'),
  body('discount').optional().isInt({ min: 0, max: 100 }).withMessage('Discount must be between 0 and 100'),
  body('category').trim().notEmpty().withMessage('Category is required'),
  body('stock').optional().isInt({ min: 0 }).withMessage('Stock must be a positive number'),
  body('imageUrl').optional().trim().isURL().withMessage('Valid image URL required'),
  body('sku').optional().trim()
];

const updateProductValidation = [
  body('name').optional().trim().notEmpty(),
  body('description').optional().trim().notEmpty(),
  body('price').optional().isFloat({ min: 0 }),
  body('discount').optional().isInt({ min: 0, max: 100 }),
  body('category').optional().trim().notEmpty(),
  body('stock').optional().isInt({ min: 0 }),
  body('imageUrl').optional().trim().isURL(),
  body('sku').optional().trim(),
  body('isActive').optional().isBoolean()
];

// Public routes
router.get('/', getProducts);
router.get('/categories', getCategories);
router.get('/:id', getProductById);

// Admin only routes
router.post('/', authenticateToken, requireAdmin, productValidation, createProduct);
router.put('/:id', authenticateToken, requireAdmin, updateProductValidation, updateProduct);
router.delete('/:id', authenticateToken, requireAdmin, deleteProduct);

export default router;
