// Script para listar usuários do banco
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function listarUsuarios() {
  try {
    console.log('Buscando usuários no banco...\n');

    const usuarios = await prisma.user.findMany({
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
        createdAt: true
      }
    });

    if (usuarios.length === 0) {
      console.log('❌ Nenhum usuário encontrado no banco!');
      console.log('\nVocê precisa criar um usuário primeiro.');
      console.log('Execute: node criar_usuario.js\n');
    } else {
      console.log(`✅ ${usuarios.length} usuário(s) encontrado(s):\n`);
      usuarios.forEach((user, index) => {
        console.log(`${index + 1}. ${user.name}`);
        console.log(`   Email: ${user.email}`);
        console.log(`   Role: ${user.role}`);
        console.log(`   ID: ${user.id}`);
        console.log(`   Criado em: ${user.createdAt}\n`);
      });

      console.log('💡 Use esses emails para fazer login!');
      console.log('⚠️  Se não souber a senha, crie um novo usuário com: node criar_usuario.js\n');
    }

  } catch (error) {
    console.error('❌ Erro ao listar usuários:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

listarUsuarios();
