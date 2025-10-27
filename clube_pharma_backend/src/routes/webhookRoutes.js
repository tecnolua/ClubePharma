import express from 'express';
import { handleMercadoPagoWebhook } from '../controllers/webhookController.js';

const router = express.Router();

/**
 * Webhook Routes
 *
 * These routes handle incoming webhooks from external services.
 * Webhooks do NOT require authentication as they come from external services.
 */

/**
 * Mercado Pago Webhook
 * POST /api/webhooks/mercadopago
 *
 * Receives payment notifications from Mercado Pago.
 * No authentication required - validated by Mercado Pago signature.
 */
router.post('/mercadopago', handleMercadoPagoWebhook);

export default router;
