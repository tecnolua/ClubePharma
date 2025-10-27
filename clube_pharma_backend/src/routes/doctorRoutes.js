import express from 'express';
import { authenticateToken, requireAdmin } from '../middlewares/auth.js';
import {
  getDoctors,
  getDoctorById,
  getSpecialties,
  createDoctor,
  updateDoctor,
  deleteDoctor
} from '../controllers/doctorController.js';

const router = express.Router();

/**
 * Doctor Routes
 *
 * Public routes:
 * - GET / - Get all doctors with filters
 * - GET /specialties - Get all specialties
 * - GET /:id - Get doctor by ID
 *
 * Admin routes (require authentication + admin role):
 * - POST / - Create new doctor
 * - PUT /:id - Update doctor
 * - DELETE /:id - Delete doctor (soft delete)
 */

// Public routes
router.get('/', getDoctors);
router.get('/specialties', getSpecialties);
router.get('/:id', getDoctorById);

// Admin routes
router.post('/', authenticateToken, requireAdmin, createDoctor);
router.put('/:id', authenticateToken, requireAdmin, updateDoctor);
router.delete('/:id', authenticateToken, requireAdmin, deleteDoctor);

export default router;
