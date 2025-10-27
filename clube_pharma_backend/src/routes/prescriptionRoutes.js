import express from 'express';
import {
  uploadPrescription,
  getPrescriptions,
  getPrescriptionById,
  downloadPrescription,
  updatePrescription,
  deletePrescription,
  getPrescriptionCategories
} from '../controllers/prescriptionController.js';
import { authenticateToken } from '../middlewares/auth.js';
import upload from '../config/multer.js';
import { body } from 'express-validator';

const router = express.Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Validações
const uploadValidation = [
  body('doctorName')
    .trim()
    .notEmpty()
    .withMessage('Doctor name is required')
    .isLength({ min: 3, max: 100 })
    .withMessage('Doctor name must be between 3 and 100 characters'),
  body('issuedAt')
    .optional()
    .isISO8601()
    .withMessage('Invalid date format'),
  body('notes')
    .optional()
    .isLength({ max: 500 })
    .withMessage('Notes cannot exceed 500 characters'),
  body('category')
    .optional()
    .isIn(['GERAL', 'CARDIOLOGIA', 'DERMATOLOGIA', 'ENDOCRINOLOGIA', 'GINECOLOGIA', 'NEUROLOGIA', 'OFTALMOLOGIA', 'ORTOPEDIA', 'PEDIATRIA', 'PSIQUIATRIA', 'OUTROS'])
    .withMessage('Invalid category')
];

const updateValidation = [
  body('doctorName')
    .optional()
    .trim()
    .isLength({ min: 3, max: 100 })
    .withMessage('Doctor name must be between 3 and 100 characters'),
  body('issuedAt')
    .optional()
    .isISO8601()
    .withMessage('Invalid date format'),
  body('notes')
    .optional()
    .isLength({ max: 500 })
    .withMessage('Notes cannot exceed 500 characters'),
  body('category')
    .optional()
    .isIn(['GERAL', 'CARDIOLOGIA', 'DERMATOLOGIA', 'ENDOCRINOLOGIA', 'GINECOLOGIA', 'NEUROLOGIA', 'OFTALMOLOGIA', 'ORTOPEDIA', 'PEDIATRIA', 'PSIQUIATRIA', 'OUTROS'])
    .withMessage('Invalid category')
];

// Rotas
router.post('/', upload.single('file'), uploadValidation, uploadPrescription);
router.get('/', getPrescriptions);
router.get('/categories', getPrescriptionCategories);
router.get('/:id', getPrescriptionById);
router.get('/:id/download', downloadPrescription);
router.put('/:id', updateValidation, updatePrescription);
router.delete('/:id', deletePrescription);

export default router;
