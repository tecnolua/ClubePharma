import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import { uploadAvatar, handleUploadError } from '../middlewares/upload.js';
import {
  getFamilyMembers,
  getFamilyMemberById,
  createFamilyMember,
  updateFamilyMember,
  updateFamilyMemberAvatar,
  deleteFamilyMember
} from '../controllers/familyMemberController.js';

const router = express.Router();

// All routes require authentication
router.use(authenticateToken);

// Validation rules
const familyMemberValidation = [
  body('name').trim().notEmpty().withMessage('Name is required'),
  body('birthDate').isISO8601().withMessage('Valid birth date is required'),
  body('cpf').optional().matches(/^\d{11}$/).withMessage('CPF must be 11 digits')
];

const updateValidation = [
  body('name').optional().trim().notEmpty(),
  body('birthDate').optional().isISO8601(),
  body('cpf').optional().matches(/^\d{11}$/).withMessage('CPF must be 11 digits')
];

// Routes
router.get('/', getFamilyMembers);
router.get('/:id', getFamilyMemberById);
router.post('/', familyMemberValidation, createFamilyMember);
router.put('/:id', updateValidation, updateFamilyMember);
router.put('/:id/avatar', uploadAvatar, handleUploadError, updateFamilyMemberAvatar);
router.delete('/:id', deleteFamilyMember);

export default router;
