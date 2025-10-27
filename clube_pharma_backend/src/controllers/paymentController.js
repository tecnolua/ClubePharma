import { validationResult } from 'express-validator';
import { Preference } from 'mercadopago';
import prisma from '../config/database.js';
import mercadoPagoClient from '../config/mercadopago.js';

/**
 * Payment Controller
 *
 * Handles payment operations with Mercado Pago integration.
 * Creates payment preferences, retrieves payment status, and manages user payments.
 */

/**
 * Create Mercado Pago Payment Preference
 * POST /api/payments/create
 *
 * Creates a payment preference for an order and returns the payment link.
 */
export const createPaymentPreference = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { orderId } = req.body;

    // Get order with items and products
    const order = await prisma.order.findUnique({
      where: { id: orderId },
      include: {
        items: {
          include: {
            product: true
          }
        },
        user: true
      }
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    // Check if order belongs to user
    if (order.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Check if order already has a payment
    const existingPayment = await prisma.payment.findFirst({
      where: { orderId }
    });

    if (existingPayment && existingPayment.status === 'APPROVED') {
      return res.status(400).json({
        success: false,
        message: 'Order already has an approved payment'
      });
    }

    // Prepare items for Mercado Pago
    const items = order.items.map(item => ({
      id: item.productId,
      title: item.product.name,
      description: item.product.description || item.product.name,
      quantity: item.quantity,
      unit_price: parseFloat(item.price),
      currency_id: 'BRL'
    }));

    // Create payment preference
    const preference = new Preference(mercadoPagoClient);

    const preferenceData = {
      items,
      external_reference: orderId,
      payer: {
        name: order.user.name,
        email: order.user.email
      },
      back_urls: {
        success: `${process.env.FRONTEND_URL || 'http://localhost:5173'}/payment/success`,
        failure: `${process.env.FRONTEND_URL || 'http://localhost:5173'}/payment/failure`,
        pending: `${process.env.FRONTEND_URL || 'http://localhost:5173'}/payment/pending`
      },
      auto_return: 'approved',
      notification_url: `${process.env.BACKEND_URL || 'http://localhost:3000'}/api/webhooks/mercadopago`,
      statement_descriptor: 'CLUBEPHARMA',
      expires: true,
      expiration_date_from: new Date().toISOString(),
      expiration_date_to: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString() // 24 hours
    };

    const response = await preference.create({ body: preferenceData });

    // Save payment in database
    const payment = await prisma.payment.create({
      data: {
        orderId,
        amount: order.total,
        method: 'MERCADO_PAGO',
        status: 'PENDING',
        preferenceId: response.id,
        paymentLink: response.init_point // sandbox link
      }
    });

    res.status(201).json({
      success: true,
      message: 'Payment preference created successfully',
      data: {
        paymentLink: response.init_point,
        preferenceId: response.id,
        payment
      }
    });
  } catch (error) {
    console.error('Create payment preference error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

/**
 * Get Payment Status by ID
 * GET /api/payments/:id
 *
 * Retrieves payment details for the authenticated user.
 */
export const getPaymentStatus = async (req, res) => {
  try {
    const { id } = req.params;

    const payment = await prisma.payment.findUnique({
      where: { id },
      include: {
        order: {
          include: {
            items: {
              include: {
                product: true
              }
            }
          }
        }
      }
    });

    if (!payment) {
      return res.status(404).json({
        success: false,
        message: 'Payment not found'
      });
    }

    // Check if payment belongs to user's order
    if (payment.order.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.status(200).json({
      success: true,
      data: payment
    });
  } catch (error) {
    console.error('Get payment status error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Get All Payments by User
 * GET /api/payments
 *
 * Lists all payments for the authenticated user.
 */
export const getPaymentsByUser = async (req, res) => {
  try {
    const payments = await prisma.payment.findMany({
      where: {
        order: {
          userId: req.user.id
        }
      },
      include: {
        order: {
          include: {
            items: {
              include: {
                product: true
              }
            }
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    res.status(200).json({
      success: true,
      data: payments
    });
  } catch (error) {
    console.error('Get payments by user error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};
