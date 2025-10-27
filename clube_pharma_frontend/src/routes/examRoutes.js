import express from 'express';
import {
  uploadExam,
  getExams,
  getExamById,
  downloadExam,
  updateExam,
  deleteExam,
  getExamCategories,
  getExamTypes
} from '../controllers/examController.js';
import { authenticateToken } from '../middleware/auth.js';
import upload from '../config/multer.js';
import { body } from 'express-validator';

const router = express.Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Validações
const uploadValidation = [
  body('examType')
    .trim()
    .notEmpty()
    .withMessage('Exam type is required')
    .isLength({ min: 3, max: 100 })
    .withMessage('Exam type must be between 3 and 100 characters'),
  body('examDate')
    .optional()
    .isISO8601()
    .withMessage('Invalid date format'),
  body('doctorName')
    .optional()
    .trim()
    .isLength({ min: 3, max: 100 })
    .withMessage('Doctor name must be between 3 and 100 characters'),
  body('notes')
    .optional()
    .isLength({ max: 500 })
    .withMessage('Notes cannot exceed 500 characters'),
  body('category')
    .optional()
    .isIn(['GERAL', 'SANGUE', 'URINA', 'IMAGEM', 'CARDIOLOGIA', 'ENDOCRINOLOGIA', 'NEUROLOGIA', 'OFTALMOLOGIA', 'OUTROS'])
    .withMessage('Invalid category')
];

const updateValidation = [
  body('examType')
    .optional()
    .trim()
    .isLength({ min: 3, max: 100 })
    .withMessage('Exam type must be between 3 and 100 characters'),
  body('examDate')
    .optional()
    .isISO8601()
    .withMessage('Invalid date format'),
  body('doctorName')
    .optional()
    .trim()
    .isLength({ min: 3, max: 100 })
    .withMessage('Doctor name must be between 3 and 100 characters'),
  body('notes')
    .optional()
    .isLength({ max: 500 })
    .withMessage('Notes cannot exceed 500 characters'),
  body('category')
    .optional()
    .isIn(['GERAL', 'SANGUE', 'URINA', 'IMAGEM', 'CARDIOLOGIA', 'ENDOCRINOLOGIA', 'NEUROLOGIA', 'OFTALMOLOGIA', 'OUTROS'])
    .withMessage('Invalid category')
];

// Rotas
router.post('/', upload.single('file'), uploadValidation, uploadExam);
router.get('/', getExams);
router.get('/categories', getExamCategories);
router.get('/types', getExamTypes);
router.get('/:id', getExamById);
router.get('/:id/download', downloadExam);
router.put('/:id', updateValidation, updateExam);
router.delete('/:id', deleteExam);

export default router;
