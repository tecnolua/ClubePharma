import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import { requireAdmin } from '../middlewares/adminAuth.js';
import {
  createOrder,
  getOrders,
  getOrderById,
  cancelOrder,
  updateOrderStatus,
  getOrderStats
} from '../controllers/orderController.js';

const router = express.Router();

// All routes require authentication
router.use(authenticateToken);

// Validation rules
const createOrderValidation = [
  body('paymentMethod').trim().notEmpty().withMessage('Payment method is required')
];

const updateOrderStatusValidation = [
  body('status')
    .isIn(['PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED'])
    .withMessage('Invalid status'),
  body('paymentId').optional().trim()
];

// User routes
router.post('/', createOrderValidation, createOrder);
router.get('/', getOrders);
router.get('/stats', getOrderStats);
router.get('/:id', getOrderById);
router.put('/:id/cancel', cancelOrder);

// Admin routes
router.put('/:id/status', requireAdmin, updateOrderStatusValidation, updateOrderStatus);

export default router;
