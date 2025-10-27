import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('Iniciando seed completo do banco de dados...\n');

  // Limpar dados existentes (ordem importante por causa de foreign keys)
  console.log('Limpando dados existentes...');
  await prisma.pillTake.deleteMany({});
  console.log('- PillTakes removidos');

  await prisma.treatment.deleteMany({});
  console.log('- Treatments removidos');

  await prisma.familyMember.deleteMany({});
  console.log('- FamilyMembers removidos');

  await prisma.appointment.deleteMany({});
  console.log('- Appointments removidos');

  await prisma.product.deleteMany({});
  console.log('- Products removidos');

  await prisma.doctor.deleteMany({});
  console.log('- Doctors removidos');

  await prisma.user.deleteMany({});
  console.log('- Users removidos\n');

  // Hash da senha padrão
  const hashedPassword = await bcrypt.hash('senha123', 10);

  // CRIAR USUÁRIOS
  console.log('Criando usuários...');
  const luana = await prisma.user.create({
    data: {
      email: 'luana@clubepharma.com',
      password: hashedPassword,
      name: 'Luana Galvão',
      cpf: '12345678901',
      planType: 'FAMILY',
      role: 'ADMIN',
    },
  });
  console.log(`- Criado: ${luana.name} (${luana.email})`);

  const eliudem = await prisma.user.create({
    data: {
      email: 'eliudem@clubepharma.com',
      password: hashedPassword,
      name: 'Eliudem Galvão',
      cpf: '98765432109',
      planType: 'FAMILY',
      role: 'ADMIN',
    },
  });
  console.log(`- Criado: ${eliudem.name} (${eliudem.email})`);

  const joao = await prisma.user.create({
    data: {
      email: 'joao@example.com',
      password: hashedPassword,
      name: 'João Silva',
      planType: 'BASIC',
      role: 'USER',
    },
  });
  console.log(`- Criado: ${joao.name} (${joao.email})\n`);

  // CRIAR FAMILY MEMBERS
  console.log('Criando membros da família...');
  const maria = await prisma.familyMember.create({
    data: {
      userId: luana.id,
      name: 'Maria Galvão',
      birthDate: new Date('1995-06-15'),
    },
  });
  console.log(`- Criado: ${maria.name} (filha da Luana)`);

  const pedro = await prisma.familyMember.create({
    data: {
      userId: eliudem.id,
      name: 'Pedro Galvão',
      birthDate: new Date('2010-03-20'),
    },
  });
  console.log(`- Criado: ${pedro.name} (filho do Eliudem)\n`);

  // CRIAR TREATMENT
  console.log('Criando tratamentos...');
  const treatment = await prisma.treatment.create({
    data: {
      userId: luana.id,
      medicationName: 'Losartana 50mg',
      dosage: '1x ao dia',
      frequency: 'DAILY',
      startDate: new Date('2024-01-01'),
      endDate: new Date('2024-12-31'),
      status: 'ACTIVE',
      reminderTime: '08:00',
    },
  });
  console.log(`- Criado: ${treatment.medicationName} (Luana)\n`);

  // CRIAR PILL TAKES
  console.log('Criando registros de tomadas...');

  const pillTake1 = await prisma.pillTake.create({
    data: {
      treatmentId: treatment.id,
      takenAt: new Date('2024-10-25T08:00:00'),
    },
  });
  console.log(`- Criado: Tomada do dia 25/10/2024`);

  const pillTake2 = await prisma.pillTake.create({
    data: {
      treatmentId: treatment.id,
      takenAt: new Date('2024-10-24T08:00:00'),
    },
  });
  console.log(`- Criado: Tomada do dia 24/10/2024`);

  const pillTake3 = await prisma.pillTake.create({
    data: {
      treatmentId: treatment.id,
      takenAt: new Date('2024-10-23T08:00:00'),
    },
  });
  console.log(`- Criado: Tomada do dia 23/10/2024\n`);


  // CRIAR DOCTORS
  console.log('Criando médicos...');
  const drCarlos = await prisma.doctor.create({
    data: {
      name: 'Dr. Carlos Silva',
      specialty: 'Cardiologia',
      crm: '12345-SP',
      clinicName: 'Clínica Coração Saudável',
      state: 'SP',
      address: 'Av. Paulista, 1000',
      city: 'São Paulo',
      price: 250.0,
      discount: 20.0,
      telemedicine: true,
      rating: 4.8,
    },
  });
  console.log(`- Criado: ${drCarlos.name} (${drCarlos.specialty})`);

  const draAna = await prisma.doctor.create({
    data: {
      name: 'Dra. Ana Santos',
      specialty: 'Dermatologia',
      crm: '54321-SP',
      clinicName: 'Dermato Clinic',
      state: 'SP',
      address: 'Rua Augusta, 500',
      city: 'São Paulo',
      price: 300.0,
      discount: 15.0,
      telemedicine: false,
      rating: 4.9,
    },
  });
  console.log(`- Criado: ${draAna.name} (${draAna.specialty})`);

  const drRoberto = await prisma.doctor.create({
    data: {
      name: 'Dr. Roberto Oliveira',
      specialty: 'Ortopedia',
      crm: '98765-RJ',
      clinicName: 'Ortopedia Total',
      state: 'RJ',
      price: 280.0,
      discount: 25.0,
      address: 'Av. Atlântica, 2000',
      city: 'Rio de Janeiro',
      telemedicine: true,
      rating: 4.7,
    },
  });
  console.log(`- Criado: ${drRoberto.name} (${drRoberto.specialty})\n`);

  // CRIAR APPOINTMENTS
  console.log('Criando consultas...');
  const appointment1 = await prisma.appointment.create({
    data: {
      userId: luana.id,
      doctorId: drCarlos.id,
      date: new Date('2024-10-28'),
      time: '10:00',
      status: 'SCHEDULED',
    },
  });
  console.log(`- Criado: Luana com ${drCarlos.name} em 28/10/2024 às 10:00 (${appointment1.status})`);

  const appointment2 = await prisma.appointment.create({
    data: {
      userId: eliudem.id,
      doctorId: draAna.id,
      date: new Date('2024-10-30'),
      time: '14:30',
      status: 'CONFIRMED',
    },
  });
  console.log(`- Criado: Eliudem com ${draAna.name} em 30/10/2024 às 14:30 (${appointment2.status})`);

  const appointment3 = await prisma.appointment.create({
    data: {
      userId: luana.id,
      doctorId: drRoberto.id,
      date: new Date('2024-10-20'),
      time: '09:00',
      status: 'COMPLETED',
    },
  });
  console.log(`- Criado: Luana com ${drRoberto.name} em 20/10/2024 às 09:00 (${appointment3.status})
`);

  // CRIAR PRODUCTS
  console.log('Criando produtos...');
  const products = [
    {
      name: 'Dipirona 500mg',
      description: 'Analgésico e antitérmico - 20 comprimidos',
      price: 8.90,
      discount: 20.0,
      category: 'Analgésicos',
      stock: 150,
    },
    {
      name: 'Paracetamol 750mg',
      description: 'Analgésico e antitérmico - 10 comprimidos',
      price: 5.50,
      discount: 15.0,
      category: 'Analgésicos',
      stock: 200,
    },
    {
      name: 'Amoxicilina 500mg',
      description: 'Antibiótico de amplo espectro - 21 cápsulas',
      price: 25.00,
      discount: 10.0,
      category: 'Antibióticos',
      stock: 80,
    },
    {
      name: 'Omeprazol 20mg',
      description: 'Protetor gástrico - 30 cápsulas',
      price: 12.90,
      discount: 25.0,
      category: 'Gastro',
      stock: 120,
    },
    {
      name: 'Losartana 50mg',
      description: 'Anti-hipertensivo - 30 comprimidos',
      price: 15.00,
      discount: 20.0,
      category: 'Cardiovascular',
      stock: 100,
    },
    {
      name: 'Dorflex',
      description: 'Relaxante muscular e analgésico - 10 comprimidos',
      price: 16.50,
      discount: 25.0,
      category: 'Relaxantes',
      stock: 110,
    },
    {
      name: 'Vitamina C 1g',
      description: 'Suplemento vitamínico - 30 comprimidos efervescentes',
      price: 18.90,
      discount: 0.0,
      category: 'Vitaminas',
      stock: 150,
    },
    {
      name: 'Ibuprofeno 600mg',
      description: 'Anti-inflamatório e analgésico - 20 comprimidos',
      price: 14.50,
      discount: 15.0,
      category: 'Anti-inflamatórios',
      stock: 90,
    },
    {
      name: 'Loratadina 10mg',
      description: 'Antialérgico - 12 comprimidos',
      price: 9.90,
      discount: 20.0,
      category: 'Antialérgicos',
      stock: 130,
    },
    {
      name: 'Soro Fisiológico 500ml',
      description: 'Solução fisiológica estéril - 500ml',
      price: 6.50,
      discount: 10.0,
      category: 'Outros',
      stock: 75,
    },
  ];

  for (const productData of products) {
    const product = await prisma.product.create({
      data: productData,
    });
    console.log(`- Criado: ${product.name} (R$ ${product.price})`);
  }

  console.log('\n' + '='.repeat(60));
  console.log('SEED COMPLETO COM SUCESSO!');
  console.log('='.repeat(60));
  console.log('\nRESUMO DOS DADOS CRIADOS:');
  console.log(`- ${3} usuários`);
  console.log(`- ${2} membros da família`);
  console.log(`- ${1} tratamento ativo`);
  console.log(`- ${3} registros de tomadas`);
  console.log(`- ${3} médicos`);
  console.log(`- ${3} consultas`);
  console.log(`- ${10} produtos`);

  console.log('\n' + '='.repeat(60));
  console.log('CREDENCIAIS DE LOGIN:');
  console.log('='.repeat(60));
  console.log('\nADMIN 1:');
  console.log('  Email: luana@clubepharma.com');
  console.log('  Senha: senha123');
  console.log('  Plano: FAMILY');
  console.log('  Role: ADMIN');

  console.log('\nADMIN 2:');
  console.log('  Email: eliudem@clubepharma.com');
  console.log('  Senha: senha123');
  console.log('  Plano: FAMILY');
  console.log('  Role: ADMIN');

  console.log('\nUSUÁRIO:');
  console.log('  Email: joao@example.com');
  console.log('  Senha: senha123');
  console.log('  Plano: BASIC');
  console.log('  Role: USER');
  console.log('\n' + '='.repeat(60));
}

main()
  .catch((e) => {
    console.error('Erro durante seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
