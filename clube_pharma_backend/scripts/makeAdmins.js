import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function makeAdmins() {
  try {
    const adminEmails = ['luana@clubepharma.com', 'eliudem@clubepharma.com'];

    const result = await prisma.user.updateMany({
      where: {
        email: {
          in: adminEmails
        }
      },
      data: {
        role: 'ADMIN'
      }
    });

    console.log(`✅ Updated ${result.count} users to ADMIN role`);

    // Verify the changes
    const admins = await prisma.user.findMany({
      where: {
        email: {
          in: adminEmails
        }
      },
      select: {
        email: true,
        name: true,
        role: true
      }
    });

    console.log('\n📋 Admin Users:');
    admins.forEach(admin => {
      console.log(`   - ${admin.name} (${admin.email}) - Role: ${admin.role}`);
    });

  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

makeAdmins();
