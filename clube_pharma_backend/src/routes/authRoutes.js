import express from 'express';
import { body } from 'express-validator';
import {
  register,
  login,
  me,
  forgotPassword,
  resetPassword,
} from '../controllers/authController.js';
import { authMiddleware } from '../middlewares/auth.js';

const router = express.Router();

/**
 * Authentication Routes
 *
 * All routes under /api/auth
 */

/**
 * @route   POST /api/auth/register
 * @desc    Register a new user
 * @access  Public
 */
router.post(
  '/register',
  [
    // Validation rules
    body('email')
      .isEmail()
      .withMessage('Please provide a valid email address')
      .normalizeEmail(),
    body('password')
      .isLength({ min: 6 })
      .withMessage('Password must be at least 6 characters long')
      .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
      .withMessage('Password must contain at least one uppercase letter, one lowercase letter, and one number'),
    body('name')
      .trim()
      .notEmpty()
      .withMessage('Name is required')
      .isLength({ min: 2 })
      .withMessage('Name must be at least 2 characters long'),
    body('cpf')
      .optional()
      .matches(/^\d{11}$/)
      .withMessage('CPF must be 11 digits'),
    body('phone')
      .optional()
      .matches(/^\d{10,11}$/)
      .withMessage('Phone must be 10 or 11 digits'),
    body('planType')
      .optional()
      .isIn(['BASIC', 'FAMILY'])
      .withMessage('Plan type must be BASIC or FAMILY'),
  ],
  register
);

/**
 * @route   POST /api/auth/login
 * @desc    Login user and return JWT token
 * @access  Public
 */
router.post(
  '/login',
  [
    // Validation rules
    body('email')
      .isEmail()
      .withMessage('Please provide a valid email address')
      .normalizeEmail(),
    body('password')
      .notEmpty()
      .withMessage('Password is required'),
  ],
  login
);

/**
 * @route   GET /api/auth/me
 * @desc    Get current authenticated user
 * @access  Private (requires valid JWT token)
 */
router.get('/me', authMiddleware, me);

/**
 * @route   POST /api/auth/forgot-password
 * @desc    Request password reset (sends reset token)
 * @access  Public
 */
router.post(
  '/forgot-password',
  [
    // Validation rules
    body('email')
      .isEmail()
      .withMessage('Please provide a valid email address')
      .normalizeEmail(),
  ],
  forgotPassword
);

/**
 * @route   POST /api/auth/reset-password
 * @desc    Reset password with token
 * @access  Public
 */
router.post(
  '/reset-password',
  [
    // Validation rules
    body('token')
      .notEmpty()
      .withMessage('Reset token is required'),
    body('newPassword')
      .isLength({ min: 6 })
      .withMessage('Password must be at least 6 characters long')
      .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
      .withMessage('Password must contain at least one uppercase letter, one lowercase letter, and one number'),
  ],
  resetPassword
);

export default router;
