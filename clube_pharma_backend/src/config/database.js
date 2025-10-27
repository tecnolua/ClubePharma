import { PrismaClient } from '@prisma/client';

/**
 * Prisma Client Singleton
 *
 * This ensures we only have one instance of PrismaClient
 * throughout the application lifecycle, which prevents
 * connection pool exhaustion in development with hot reloading.
 */

let prisma;

// Use global variable in development to prevent multiple instances
if (process.env.NODE_ENV === 'production') {
  prisma = new PrismaClient();
} else {
  // In development, use a global variable to preserve the client across hot reloads
  if (!global.prisma) {
    global.prisma = new PrismaClient({
      log: ['query', 'error', 'warn'],
    });
  }
  prisma = global.prisma;
}

// Graceful shutdown
process.on('beforeExit', async () => {
  await prisma.$disconnect();
});

export default prisma;
