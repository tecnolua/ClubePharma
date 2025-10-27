import { validationResult } from 'express-validator';
import prisma from '../config/database.js';

/**
 * Coupon Controller
 *
 * Handles CRUD operations for discount coupons.
 * Includes validation and application of coupons to orders.
 */

/**
 * Create Coupon (Admin only)
 * POST /api/coupons
 *
 * Creates a new discount coupon.
 */
export const createCoupon = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { code, type, value, minPurchase, maxUses, validUntil } = req.body;

    // Check if coupon code already exists
    const existingCoupon = await prisma.coupon.findUnique({
      where: { code: code.toUpperCase() }
    });

    if (existingCoupon) {
      return res.status(400).json({
        success: false,
        message: 'Coupon code already exists'
      });
    }

    const coupon = await prisma.coupon.create({
      data: {
        code: code.toUpperCase(),
        type,
        value,
        minPurchase: minPurchase || null,
        maxUses: maxUses || null,
        validUntil: validUntil ? new Date(validUntil) : null,
        isActive: true,
        usedCount: 0
      }
    });

    res.status(201).json({
      success: true,
      message: 'Coupon created successfully',
      data: coupon
    });
  } catch (error) {
    console.error('Create coupon error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Get All Coupons (Admin only)
 * GET /api/coupons
 *
 * Lists all coupons with optional filters.
 */
export const getCoupons = async (req, res) => {
  try {
    const { isActive, page = 1, limit = 20 } = req.query;

    const where = {};

    if (isActive !== undefined) {
      where.isActive = isActive === 'true';
    }

    const skip = (parseInt(page) - 1) * parseInt(limit);

    const [coupons, total] = await Promise.all([
      prisma.coupon.findMany({
        where,
        skip,
        take: parseInt(limit),
        orderBy: {
          createdAt: 'desc'
        }
      }),
      prisma.coupon.count({ where })
    ]);

    res.status(200).json({
      success: true,
      data: coupons,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });
  } catch (error) {
    console.error('Get coupons error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Get Coupon by ID (Admin only)
 * GET /api/coupons/:id
 *
 * Retrieves a specific coupon by ID.
 */
export const getCouponById = async (req, res) => {
  try {
    const { id } = req.params;

    const coupon = await prisma.coupon.findUnique({
      where: { id }
    });

    if (!coupon) {
      return res.status(404).json({
        success: false,
        message: 'Coupon not found'
      });
    }

    res.status(200).json({
      success: true,
      data: coupon
    });
  } catch (error) {
    console.error('Get coupon error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Validate Coupon
 * POST /api/coupons/validate
 *
 * Validates a coupon code and returns discount information.
 */
export const validateCoupon = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { code, totalAmount } = req.body;

    // Find coupon by code
    const coupon = await prisma.coupon.findUnique({
      where: { code: code.toUpperCase() }
    });

    if (!coupon) {
      return res.status(404).json({
        success: false,
        message: 'Coupon not found'
      });
    }

    // Check if coupon is active
    if (!coupon.isActive) {
      return res.status(400).json({
        success: false,
        message: 'Coupon is not active'
      });
    }

    // Check if coupon has expired
    if (coupon.validUntil && new Date(coupon.validUntil) < new Date()) {
      return res.status(400).json({
        success: false,
        message: 'Coupon has expired'
      });
    }

    // Check minimum purchase amount
    if (coupon.minPurchase && totalAmount < parseFloat(coupon.minPurchase)) {
      return res.status(400).json({
        success: false,
        message: `Minimum purchase amount is R$ ${parseFloat(coupon.minPurchase).toFixed(2)}`
      });
    }

    // Check max uses
    if (coupon.maxUses && coupon.usedCount >= coupon.maxUses) {
      return res.status(400).json({
        success: false,
        message: 'Coupon has reached maximum usage limit'
      });
    }

    // Calculate discount
    let discountAmount = 0;
    if (coupon.type === 'PERCENTAGE') {
      discountAmount = (totalAmount * parseFloat(coupon.value)) / 100;
    } else if (coupon.type === 'FIXED') {
      discountAmount = parseFloat(coupon.value);
    }

    res.status(200).json({
      success: true,
      message: 'Coupon is valid',
      data: {
        coupon,
        discountAmount,
        finalAmount: totalAmount - discountAmount
      }
    });
  } catch (error) {
    console.error('Validate coupon error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Apply Coupon
 * POST /api/coupons/apply
 *
 * Applies a coupon and increments its usage count.
 */
export const applyCoupon = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { code } = req.body;

    // Find and validate coupon
    const coupon = await prisma.coupon.findUnique({
      where: { code: code.toUpperCase() }
    });

    if (!coupon) {
      return res.status(404).json({
        success: false,
        message: 'Coupon not found'
      });
    }

    if (!coupon.isActive) {
      return res.status(400).json({
        success: false,
        message: 'Coupon is not active'
      });
    }

    if (coupon.validUntil && new Date(coupon.validUntil) < new Date()) {
      return res.status(400).json({
        success: false,
        message: 'Coupon has expired'
      });
    }

    if (coupon.maxUses && coupon.usedCount >= coupon.maxUses) {
      return res.status(400).json({
        success: false,
        message: 'Coupon has reached maximum usage limit'
      });
    }

    // Increment usage count
    const updatedCoupon = await prisma.coupon.update({
      where: { id: coupon.id },
      data: {
        usedCount: {
          increment: 1
        }
      }
    });

    res.status(200).json({
      success: true,
      message: 'Coupon applied successfully',
      data: updatedCoupon
    });
  } catch (error) {
    console.error('Apply coupon error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Update Coupon (Admin only)
 * PUT /api/coupons/:id
 *
 * Updates an existing coupon.
 */
export const updateCoupon = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { id } = req.params;
    const { code, type, value, minPurchase, maxUses, validUntil, isActive } = req.body;

    const coupon = await prisma.coupon.findUnique({
      where: { id }
    });

    if (!coupon) {
      return res.status(404).json({
        success: false,
        message: 'Coupon not found'
      });
    }

    // If code is being changed, check if new code already exists
    if (code && code.toUpperCase() !== coupon.code) {
      const existingCoupon = await prisma.coupon.findUnique({
        where: { code: code.toUpperCase() }
      });

      if (existingCoupon) {
        return res.status(400).json({
          success: false,
          message: 'Coupon code already exists'
        });
      }
    }

    const updateData = {};
    if (code !== undefined) updateData.code = code.toUpperCase();
    if (type !== undefined) updateData.type = type;
    if (value !== undefined) updateData.value = value;
    if (minPurchase !== undefined) updateData.minPurchase = minPurchase;
    if (maxUses !== undefined) updateData.maxUses = maxUses;
    if (validUntil !== undefined) updateData.validUntil = validUntil ? new Date(validUntil) : null;
    if (isActive !== undefined) updateData.isActive = isActive;

    const updated = await prisma.coupon.update({
      where: { id },
      data: updateData
    });

    res.status(200).json({
      success: true,
      message: 'Coupon updated successfully',
      data: updated
    });
  } catch (error) {
    console.error('Update coupon error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Delete Coupon (Admin only - soft delete)
 * DELETE /api/coupons/:id
 *
 * Deactivates a coupon (soft delete).
 */
export const deleteCoupon = async (req, res) => {
  try {
    const { id } = req.params;

    const coupon = await prisma.coupon.findUnique({
      where: { id }
    });

    if (!coupon) {
      return res.status(404).json({
        success: false,
        message: 'Coupon not found'
      });
    }

    // Soft delete - set isActive to false
    const deleted = await prisma.coupon.update({
      where: { id },
      data: { isActive: false }
    });

    res.status(200).json({
      success: true,
      message: 'Coupon deleted successfully',
      data: deleted
    });
  } catch (error) {
    console.error('Delete coupon error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};
