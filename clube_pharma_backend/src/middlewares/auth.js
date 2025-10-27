import { verifyToken } from '../utils/jwt.js';
import prisma from '../config/database.js';

/**
 * Authentication Middleware
 *
 * Verifies JWT token from Authorization header and attaches
 * the authenticated user to the request object.
 *
 * Expected header format: "Authorization: Bearer <token>"
 */
export const authMiddleware = async (req, res, next) => {
  try {
    // Get token from Authorization header
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      return res.status(401).json({
        success: false,
        message: 'Access denied. No token provided.',
      });
    }

    // Check if header starts with "Bearer "
    if (!authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token format. Use: Bearer <token>',
      });
    }

    // Extract token (remove "Bearer " prefix)
    const token = authHeader.substring(7);

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Access denied. Token is missing.',
      });
    }

    // Verify token
    let decoded;
    try {
      decoded = verifyToken(token);
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: error.message || 'Invalid or expired token.',
      });
    }

    // Get user from database
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: {
        id: true,
        email: true,
        name: true,
        cpf: true,
        phone: true,
        avatar: true,
        role: true,
        planType: true,
        createdAt: true,
        updatedAt: true,
        // Exclude password from the query
      },
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'User not found. Token may be invalid.',
      });
    }

    // Attach user to request object
    req.user = user;

    // Continue to next middleware/route handler
    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    return res.status(500).json({
      success: false,
      message: 'Authentication error occurred.',
    });
  }
};

/**
 * Optional Authentication Middleware
 *
 * Similar to authMiddleware but doesn't require authentication.
 * If a valid token is provided, the user is attached to req.user.
 * If not, the request continues without req.user.
 *
 * Useful for endpoints that have different behavior for authenticated users
 * but are also accessible to guests.
 */
// Export alias for compatibility
export const authenticateToken = authMiddleware;

export const optionalAuthMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    // If no auth header, continue without user
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return next();
    }

    const token = authHeader.substring(7);

    if (!token) {
      return next();
    }

    try {
      const decoded = verifyToken(token);

      const user = await prisma.user.findUnique({
        where: { id: decoded.userId },
        select: {
          id: true,
          email: true,
          name: true,
          cpf: true,
          phone: true,
          avatar: true,
          role: true,
          planType: true,
          createdAt: true,
          updatedAt: true,
        },
      });

      if (user) {
        req.user = user;
      }
    } catch (error) {
      // Invalid token, but continue without user
      console.log('Optional auth: Invalid token provided');
    }

    next();
  } catch (error) {
    console.error('Optional auth middleware error:', error);
    next();
  }
};/**
 * Admin Authorization Middleware
 *
 * Requires user to be authenticated and have admin privileges.
 * Must be used after authenticateToken middleware.
 */
export const requireAdmin = (req, res, next) => {
  try {
    // Check if user exists (should be set by authenticateToken)
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Authentication required'
      });
    }

    // Check if user is admin (using role field from schema)
    if (req.user.role !== 'ADMIN') {
      return res.status(403).json({
        success: false,
        message: 'Admin access required'
      });
    }

    next();
  } catch (error) {
    console.error('Admin auth middleware error:', error);
    return res.status(403).json({
      success: false,
      message: 'Authorization failed'
    });
  }
};


