import { Payment } from 'mercadopago';
import prisma from '../config/database.js';
import mercadoPagoClient from '../config/mercadopago.js';
import { sendPaymentConfirmation } from '../services/emailService.js';

/**
 * Webhook Controller
 *
 * Handles webhook notifications from Mercado Pago.
 * Updates payment and order status based on payment events.
 */

/**
 * Handle Mercado Pago Webhook
 * POST /api/webhooks/mercadopago
 *
 * Receives and processes webhook notifications from Mercado Pago.
 */
export const handleMercadoPagoWebhook = async (req, res) => {
  try {
    console.log('Received Mercado Pago webhook:', JSON.stringify(req.body, null, 2));

    const { type, data } = req.body;

    // Only process payment notifications
    if (type !== 'payment') {
      console.log(`Ignoring webhook type: ${type}`);
      return res.status(200).json({ success: true, message: 'Webhook received but not processed' });
    }

    // Get payment ID from webhook data
    const paymentId = data.id;

    if (!paymentId) {
      console.log('No payment ID in webhook data');
      return res.status(400).json({ success: false, message: 'No payment ID provided' });
    }

    // Get payment details from Mercado Pago
    const paymentClient = new Payment(mercadoPagoClient);
    const mpPayment = await paymentClient.get({ id: paymentId });

    console.log('Mercado Pago payment details:', JSON.stringify(mpPayment, null, 2));

    // Get order ID from external_reference
    const orderId = mpPayment.external_reference;

    if (!orderId) {
      console.log('No order ID in payment external_reference');
      return res.status(400).json({ success: false, message: 'No order ID in payment' });
    }

    // Find payment in database by orderId or preferenceId
    let payment = await prisma.payment.findFirst({
      where: {
        OR: [
          { orderId },
          { mercadoPagoId: paymentId.toString() }
        ]
      },
      include: {
        order: {
          include: {
            items: {
              include: {
                product: true
              }
            },
            user: true
          }
        }
      }
    });

    if (!payment) {
      console.log(`No payment found for order ${orderId}`);
      return res.status(404).json({ success: false, message: 'Payment not found' });
    }

    // Map Mercado Pago status to our status
    let paymentStatus = 'PENDING';
    let orderStatus = payment.order.status;

    switch (mpPayment.status) {
      case 'approved':
        paymentStatus = 'APPROVED';
        orderStatus = 'PROCESSING';
        break;
      case 'rejected':
      case 'cancelled':
        paymentStatus = 'REJECTED';
        orderStatus = 'CANCELLED';
        break;
      case 'refunded':
        paymentStatus = 'REFUNDED';
        orderStatus = 'CANCELLED';
        break;
      case 'in_process':
      case 'pending':
        paymentStatus = 'PENDING';
        break;
      default:
        paymentStatus = 'PENDING';
    }

    // Update payment in database
    const updatedPayment = await prisma.$transaction(async (tx) => {
      // Update payment
      const updated = await tx.payment.update({
        where: { id: payment.id },
        data: {
          status: paymentStatus,
          mercadoPagoId: paymentId.toString(),
          paidAt: paymentStatus === 'APPROVED' ? new Date() : null
        },
        include: {
          order: {
            include: {
              items: {
                include: {
                  product: true
                }
              },
              user: true
            }
          }
        }
      });

      // Update order status
      await tx.order.update({
        where: { id: orderId },
        data: { status: orderStatus }
      });

      return updated;
    });

    console.log(`Payment ${payment.id} updated to status: ${paymentStatus}`);

    // Send confirmation email if payment was approved
    if (paymentStatus === 'APPROVED') {
      try {
        await sendPaymentConfirmation(
          updatedPayment,
          updatedPayment.order,
          updatedPayment.order.user
        );
      } catch (emailError) {
        console.error('Error sending payment confirmation email:', emailError);
        // Don't fail the webhook if email fails
      }
    }

    res.status(200).json({
      success: true,
      message: 'Webhook processed successfully',
      data: {
        paymentId: payment.id,
        status: paymentStatus
      }
    });
  } catch (error) {
    console.error('Webhook error:', error);
    // Return 200 to avoid Mercado Pago retrying
    res.status(200).json({
      success: false,
      message: 'Webhook processing failed',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};
