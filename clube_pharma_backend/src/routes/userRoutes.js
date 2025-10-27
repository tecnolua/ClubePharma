import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import { uploadAvatar, handleUploadError } from '../middlewares/upload.js';
import {
  getProfile,
  updateProfile,
  updatePassword,
  updatePlan,
  updateAvatar,
  deleteAccount
} from '../controllers/userController.js';

const router = express.Router();

// All routes require authentication
router.use(authenticateToken);

// Validation rules
const profileValidation = [
  body('name').optional().trim().notEmpty().withMessage('Name cannot be empty'),
  body('phone').optional().matches(/^\d{10,11}$/).withMessage('Phone must be 10 or 11 digits'),
  body('cpf').optional().matches(/^\d{11}$/).withMessage('CPF must be 11 digits')
];

const passwordValidation = [
  body('currentPassword').notEmpty().withMessage('Current password is required'),
  body('newPassword')
    .isLength({ min: 6 })
    .withMessage('New password must be at least 6 characters long')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .withMessage('New password must contain at least one uppercase letter, one lowercase letter, and one number')
];

const planValidation = [
  body('planType').isIn(['BASIC', 'FAMILY']).withMessage('Plan type must be BASIC or FAMILY')
];

const deleteValidation = [
  body('password').notEmpty().withMessage('Password is required to delete account')
];

// Routes
router.get('/profile', getProfile);
router.put('/profile', profileValidation, updateProfile);
router.put('/password', passwordValidation, updatePassword);
router.put('/plan', planValidation, updatePlan);
router.put('/avatar', uploadAvatar, handleUploadError, updateAvatar);
router.delete('/account', deleteValidation, deleteAccount);

export default router;
