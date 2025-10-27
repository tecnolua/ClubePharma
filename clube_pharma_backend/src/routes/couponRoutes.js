import express from 'express';
import { body } from 'express-validator';
import { authenticateToken, requireAdmin } from '../middlewares/auth.js';
import {
  createCoupon,
  getCoupons,
  getCouponById,
  validateCoupon,
  applyCoupon,
  updateCoupon,
  deleteCoupon
} from '../controllers/couponController.js';

const router = express.Router();

/**
 * Validation Rules
 */

const createCouponValidation = [
  body('code')
    .trim()
    .notEmpty()
    .withMessage('Coupon code is required')
    .isLength({ min: 3, max: 20 })
    .withMessage('Coupon code must be between 3 and 20 characters')
    .matches(/^[A-Z0-9]+$/)
    .withMessage('Coupon code must contain only uppercase letters and numbers'),
  body('type')
    .isIn(['PERCENTAGE', 'FIXED'])
    .withMessage('Type must be either PERCENTAGE or FIXED'),
  body('value')
    .isFloat({ min: 0 })
    .withMessage('Value must be a positive number'),
  body('minPurchase')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Minimum purchase must be a positive number'),
  body('maxUses')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Maximum uses must be a positive integer'),
  body('validUntil')
    .optional()
    .isISO8601()
    .withMessage('Valid until must be a valid date')
];

const validateCouponValidation = [
  body('code')
    .trim()
    .notEmpty()
    .withMessage('Coupon code is required'),
  body('totalAmount')
    .isFloat({ min: 0 })
    .withMessage('Total amount must be a positive number')
];

const applyCouponValidation = [
  body('code')
    .trim()
    .notEmpty()
    .withMessage('Coupon code is required')
];

const updateCouponValidation = [
  body('code')
    .optional()
    .trim()
    .isLength({ min: 3, max: 20 })
    .withMessage('Coupon code must be between 3 and 20 characters')
    .matches(/^[A-Z0-9]+$/)
    .withMessage('Coupon code must contain only uppercase letters and numbers'),
  body('type')
    .optional()
    .isIn(['PERCENTAGE', 'FIXED'])
    .withMessage('Type must be either PERCENTAGE or FIXED'),
  body('value')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Value must be a positive number'),
  body('minPurchase')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Minimum purchase must be a positive number'),
  body('maxUses')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Maximum uses must be a positive integer'),
  body('validUntil')
    .optional()
    .isISO8601()
    .withMessage('Valid until must be a valid date'),
  body('isActive')
    .optional()
    .isBoolean()
    .withMessage('isActive must be a boolean')
];

/**
 * Public Routes (with authentication)
 */

// Validate coupon (check if valid and calculate discount)
router.post('/validate', authenticateToken, validateCouponValidation, validateCoupon);

// Apply coupon (increment usage count)
router.post('/apply', authenticateToken, applyCouponValidation, applyCoupon);

/**
 * Admin Routes
 */

// Create new coupon
router.post('/', authenticateToken, requireAdmin, createCouponValidation, createCoupon);

// Get all coupons (with filters)
router.get('/', authenticateToken, requireAdmin, getCoupons);

// Get coupon by ID
router.get('/:id', authenticateToken, requireAdmin, getCouponById);

// Update coupon
router.put('/:id', authenticateToken, requireAdmin, updateCouponValidation, updateCoupon);

// Delete coupon (soft delete)
router.delete('/:id', authenticateToken, requireAdmin, deleteCoupon);

export default router;
