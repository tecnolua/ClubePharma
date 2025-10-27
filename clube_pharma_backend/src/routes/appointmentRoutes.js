import express from 'express';
import { authenticateToken, requireAdmin } from '../middlewares/auth.js';
import {
  getAvailableSlots,
  createAppointment,
  getAppointments,
  getAppointmentById,
  confirmAppointment,
  cancelAppointment,
  completeAppointment
} from '../controllers/appointmentController.js';

const router = express.Router();

/**
 * Appointment Routes
 *
 * All routes require authentication
 *
 * User routes:
 * - GET /available-slots - Get available time slots for a doctor on a specific date
 * - POST / - Create new appointment
 * - GET / - Get all appointments for authenticated user
 * - GET /:id - Get appointment by ID
 * - PUT /:id/confirm - Confirm appointment
 * - PUT /:id/cancel - Cancel appointment
 *
 * Admin routes:
 * - PUT /:id/complete - Complete appointment
 */

// All routes require authentication
router.use(authenticateToken);

// User routes
router.get('/available-slots', getAvailableSlots);
router.post('/', createAppointment);
router.get('/', getAppointments);
router.get('/:id', getAppointmentById);
router.put('/:id/confirm', confirmAppointment);
router.put('/:id/cancel', cancelAppointment);

// Admin routes
router.put('/:id/complete', requireAdmin, completeAppointment);

export default router;
