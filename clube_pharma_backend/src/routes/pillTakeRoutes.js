import express from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middlewares/auth.js';
import {
  createPillTake,
  getPillTakesByTreatment,
  getTodayPillTakes,
  getUpcomingPills,
  getAdherenceStats,
  getAdherenceDashboard
} from '../controllers/pillTakeController.js';

const router = express.Router();

// All routes require authentication
router.use(authenticateToken);

// Validation rules
const pillTakeValidation = [
  body('notes').optional().trim()
];

// Routes
router.get('/today', getTodayPillTakes);
router.get('/upcoming', getUpcomingPills);
router.get('/dashboard', getAdherenceDashboard);
router.get('/treatments/:treatmentId/adherence', getAdherenceStats);
router.post('/treatments/:treatmentId/pill-takes', pillTakeValidation, createPillTake);
router.get('/treatments/:treatmentId/pill-takes', getPillTakesByTreatment);

export default router;
