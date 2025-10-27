import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import {
  createTreatment,
  getTreatments,
  getTreatmentById,
  updateTreatment,
  deleteTreatment,
  getActiveTreatments
} from '../controllers/treatmentController.js';

const router = express.Router();

// All routes require authentication
router.use(authenticateToken);

// Validation rules
const treatmentValidation = [
  body('medicationName').trim().notEmpty().withMessage('Medication name is required'),
  body('dosage').trim().notEmpty().withMessage('Dosage is required'),
  body('frequency').trim().notEmpty().withMessage('Frequency is required'),
  body('startDate').isISO8601().withMessage('Valid start date is required'),
  body('endDate').isISO8601().withMessage('Valid end date is required'),
  body('reminderTime').optional().trim(),
  body('notes').optional().trim()
];

const updateValidation = [
  body('medicationName').optional().trim().notEmpty(),
  body('dosage').optional().trim().notEmpty(),
  body('frequency').optional().trim().notEmpty(),
  body('startDate').optional().isISO8601(),
  body('endDate').optional().isISO8601(),
  body('reminderTime').optional().trim(),
  body('status').optional().isIn(['ACTIVE', 'COMPLETED', 'CANCELLED']),
  body('notes').optional().trim()
];

// Routes
router.post('/', treatmentValidation, createTreatment);
router.get('/', getTreatments);
router.get('/active', getActiveTreatments);
router.get('/:id', getTreatmentById);
router.put('/:id', updateValidation, updateTreatment);
router.delete('/:id', deleteTreatment);

export default router;
