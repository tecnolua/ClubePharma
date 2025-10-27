import express from 'express';
import { authenticateToken, requireAdmin } from '../middlewares/auth.js';
import {
  getOverviewStats,
  getSalesStats,
  getUserStats
} from '../controllers/dashboardController.js';

const router = express.Router();

/**
 * Dashboard Routes (Admin Only)
 *
 * All routes require authentication and admin privileges.
 * These endpoints provide analytics and statistics for the admin dashboard.
 */

// Apply authentication and admin middleware to all routes
router.use(authenticateToken);
router.use(requireAdmin);

/**
 * Routes
 */

// Get overview statistics (total users, orders, revenue, etc.)
router.get('/overview', getOverviewStats);

// Get sales statistics (sales trends, top products, categories)
router.get('/sales', getSalesStats);

// Get user statistics (users by plan, active/inactive, growth)
router.get('/users', getUserStats);

export default router;
