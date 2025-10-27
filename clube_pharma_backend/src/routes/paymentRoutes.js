import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import {
  createPaymentPreference,
  getPaymentStatus,
  getPaymentsByUser
} from '../controllers/paymentController.js';

const router = express.Router();

// All routes require authentication
router.use(authenticateToken);

/**
 * Validation Rules
 */

const createPaymentValidation = [
  body('orderId')
    .trim()
    .notEmpty()
    .withMessage('Order ID is required')
    .isUUID()
    .withMessage('Order ID must be a valid UUID')
];

/**
 * Routes
 */

// Create payment preference for an order
router.post('/create', createPaymentValidation, createPaymentPreference);

// Get payment status by ID
router.get('/:id', getPaymentStatus);

// Get all payments for current user
router.get('/', getPaymentsByUser);

export default router;
