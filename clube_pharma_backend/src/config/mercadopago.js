import { MercadoPagoConfig } from 'mercadopago';

/**
 * Mercado Pago Configuration
 *
 * Initializes Mercado Pago SDK with access token from environment variables.
 * In development, uses TEST access token for sandbox environment.
 * In production, uses production access token.
 */

const client = new MercadoPagoConfig({
  accessToken: process.env.MERCADOPAGO_ACCESS_TOKEN || 'TEST-ACCESS-TOKEN'
});

export default client;
