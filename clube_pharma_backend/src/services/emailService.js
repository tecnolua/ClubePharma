import nodemailer from 'nodemailer';

/**
 * Email Service
 *
 * Handles all email notifications using Nodemailer.
 * Supports welcome emails, order confirmations, payment confirmations,
 * and appointment reminders.
 */

// Create reusable transporter
let transporter = null;

const getTransporter = () => {
  if (!transporter) {
    // Check if email credentials are configured
    if (!process.env.EMAIL_HOST || !process.env.EMAIL_USER || !process.env.EMAIL_PASSWORD) {
      console.warn('Email service not configured. Emails will not be sent.');
      return null;
    }

    transporter = nodemailer.createTransport({
      host: process.env.EMAIL_HOST,
      port: parseInt(process.env.EMAIL_PORT) || 587,
      secure: process.env.EMAIL_SECURE === 'true', // true for 465, false for other ports
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD
      }
    });
  }

  return transporter;
};

/**
 * Send Welcome Email to new user
 * @param {Object} user - User object with name and email
 */
export const sendWelcomeEmail = async (user) => {
  try {
    const transport = getTransporter();
    if (!transport) return;

    const mailOptions = {
      from: `"ClubePharma" <${process.env.EMAIL_USER}>`,
      to: user.email,
      subject: 'Bem-vindo ao ClubePharma!',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h1 style="color: #4CAF50;">Bem-vindo ao ClubePharma, ${user.name}!</h1>
          <p>Estamos felizes em ter você conosco.</p>
          <p>Com o ClubePharma, você pode:</p>
          <ul>
            <li>Gerenciar seus medicamentos e tratamentos</li>
            <li>Comprar produtos com desconto</li>
            <li>Agendar consultas com médicos</li>
            <li>Acompanhar seus exames e receitas</li>
          </ul>
          <p>Aproveite todos os benefícios da plataforma!</p>
          <br>
          <p>Atenciosamente,<br>Equipe ClubePharma</p>
        </div>
      `
    };

    await transport.sendMail(mailOptions);
    console.log(`Welcome email sent to ${user.email}`);
  } catch (error) {
    console.error('Error sending welcome email:', error);
  }
};

/**
 * Send Order Confirmation Email
 * @param {Object} order - Order object with items
 * @param {Object} user - User object
 */
export const sendOrderConfirmation = async (order, user) => {
  try {
    const transport = getTransporter();
    if (!transport) return;

    const itemsHtml = order.items.map(item => `
      <tr>
        <td>${item.product.name}</td>
        <td style="text-align: center;">${item.quantity}</td>
        <td style="text-align: right;">R$ ${parseFloat(item.price).toFixed(2)}</td>
      </tr>
    `).join('');

    const mailOptions = {
      from: `"ClubePharma" <${process.env.EMAIL_USER}>`,
      to: user.email,
      subject: `Pedido Confirmado #${order.id.substring(0, 8)}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h1 style="color: #4CAF50;">Pedido Confirmado!</h1>
          <p>Olá ${user.name},</p>
          <p>Seu pedido foi recebido com sucesso.</p>

          <h2>Detalhes do Pedido</h2>
          <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
            <thead>
              <tr style="background-color: #f5f5f5;">
                <th style="padding: 10px; text-align: left; border: 1px solid #ddd;">Produto</th>
                <th style="padding: 10px; text-align: center; border: 1px solid #ddd;">Qtd</th>
                <th style="padding: 10px; text-align: right; border: 1px solid #ddd;">Preço</th>
              </tr>
            </thead>
            <tbody>
              ${itemsHtml}
            </tbody>
          </table>

          <div style="text-align: right; margin: 20px 0;">
            <p><strong>Subtotal:</strong> R$ ${parseFloat(order.subtotal).toFixed(2)}</p>
            ${order.discount > 0 ? `<p style="color: #4CAF50;"><strong>Desconto:</strong> -R$ ${parseFloat(order.discount).toFixed(2)}</p>` : ''}
            <p style="font-size: 18px;"><strong>Total:</strong> R$ ${parseFloat(order.total).toFixed(2)}</p>
          </div>

          <p>Status: <strong>${order.status}</strong></p>
          <p>Você receberá um email assim que o pagamento for confirmado.</p>

          <br>
          <p>Atenciosamente,<br>Equipe ClubePharma</p>
        </div>
      `
    };

    await transport.sendMail(mailOptions);
    console.log(`Order confirmation email sent to ${user.email}`);
  } catch (error) {
    console.error('Error sending order confirmation email:', error);
  }
};

/**
 * Send Payment Confirmation Email
 * @param {Object} payment - Payment object
 * @param {Object} order - Order object with items
 * @param {Object} user - User object
 */
export const sendPaymentConfirmation = async (payment, order, user) => {
  try {
    const transport = getTransporter();
    if (!transport) return;

    const mailOptions = {
      from: `"ClubePharma" <${process.env.EMAIL_USER}>`,
      to: user.email,
      subject: `Pagamento Aprovado - Pedido #${order.id.substring(0, 8)}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h1 style="color: #4CAF50;">Pagamento Aprovado!</h1>
          <p>Olá ${user.name},</p>
          <p>Seu pagamento foi aprovado com sucesso.</p>

          <h2>Detalhes do Pagamento</h2>
          <p><strong>Pedido:</strong> #${order.id.substring(0, 8)}</p>
          <p><strong>Valor:</strong> R$ ${parseFloat(payment.amount).toFixed(2)}</p>
          <p><strong>Status:</strong> ${payment.status}</p>
          <p><strong>Data:</strong> ${new Date(payment.paidAt).toLocaleString('pt-BR')}</p>

          <p>Seu pedido está sendo processado e em breve será enviado.</p>
          <p>Você pode acompanhar o status do pedido em sua conta.</p>

          <br>
          <p>Atenciosamente,<br>Equipe ClubePharma</p>
        </div>
      `
    };

    await transport.sendMail(mailOptions);
    console.log(`Payment confirmation email sent to ${user.email}`);
  } catch (error) {
    console.error('Error sending payment confirmation email:', error);
  }
};

/**
 * Send Appointment Reminder Email
 * @param {Object} appointment - Appointment object
 * @param {Object} user - User object
 * @param {Object} doctor - Doctor object
 */
export const sendAppointmentReminder = async (appointment, user, doctor) => {
  try {
    const transport = getTransporter();
    if (!transport) return;

    const appointmentDate = new Date(appointment.scheduledFor);
    const formattedDate = appointmentDate.toLocaleDateString('pt-BR', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
    const formattedTime = appointmentDate.toLocaleTimeString('pt-BR', {
      hour: '2-digit',
      minute: '2-digit'
    });

    const mailOptions = {
      from: `"ClubePharma" <${process.env.EMAIL_USER}>`,
      to: user.email,
      subject: 'Lembrete de Consulta - ClubePharma',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h1 style="color: #4CAF50;">Lembrete de Consulta</h1>
          <p>Olá ${user.name},</p>
          <p>Este é um lembrete sobre sua consulta agendada.</p>

          <div style="background-color: #f5f5f5; padding: 20px; border-radius: 5px; margin: 20px 0;">
            <h2 style="margin-top: 0;">Detalhes da Consulta</h2>
            <p><strong>Médico:</strong> ${doctor.name}</p>
            <p><strong>Especialidade:</strong> ${doctor.specialty}</p>
            <p><strong>Data:</strong> ${formattedDate}</p>
            <p><strong>Horário:</strong> ${formattedTime}</p>
            ${appointment.notes ? `<p><strong>Observações:</strong> ${appointment.notes}</p>` : ''}
          </div>

          <p>Por favor, chegue com 10 minutos de antecedência.</p>
          <p>Traga seus documentos e exames anteriores, se houver.</p>

          <br>
          <p>Atenciosamente,<br>Equipe ClubePharma</p>
        </div>
      `
    };

    await transport.sendMail(mailOptions);
    console.log(`Appointment reminder email sent to ${user.email}`);
  } catch (error) {
    console.error('Error sending appointment reminder email:', error);
  }
};

export default {
  sendWelcomeEmail,
  sendOrderConfirmation,
  sendPaymentConfirmation,
  sendAppointmentReminder
};
