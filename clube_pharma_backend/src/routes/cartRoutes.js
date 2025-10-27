import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import {
  getCart,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart
} from '../controllers/cartController.js';

const router = express.Router();

// All routes require authentication
router.use(authenticateToken);

// Validation rules
const addToCartValidation = [
  body('productId').trim().notEmpty().withMessage('Product ID is required'),
  body('quantity').optional().isInt({ min: 1 }).withMessage('Quantity must be at least 1')
];

const updateCartValidation = [
  body('quantity').isInt({ min: 1 }).withMessage('Quantity must be at least 1')
];

// Routes
router.get('/', getCart);
router.post('/', addToCartValidation, addToCart);
router.put('/:id', updateCartValidation, updateCartItem);
router.delete('/:id', removeFromCart);
router.delete('/', clearCart);

export default router;
