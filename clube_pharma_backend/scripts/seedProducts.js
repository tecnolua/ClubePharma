import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const products = [
  {
    name: 'Dipirona 500mg',
    description: 'Analgésico e antitérmico eficaz para aliviar dores e febres. Embalagem com 20 comprimidos.',
    price: 8.90,
    discount: 20,
    category: 'Analgésicos',
    stock: 150,
    imageUrl: 'https://example.com/dipirona.jpg',
    sku: 'DIP-500-20'
  },
  {
    name: 'Paracetamol 750mg',
    description: 'Indicado para tratamento de febre e dor leve a moderada. Caixa com 16 comprimidos.',
    price: 12.50,
    discount: 25,
    category: 'Analgésicos',
    stock: 200,
    imageUrl: 'https://example.com/paracetamol.jpg',
    sku: 'PAR-750-16'
  },
  {
    name: 'Amoxicilina 500mg',
    description: 'Antibiótico de amplo espectro. Caixa com 21 cápsulas. *Venda sob prescrição médica.',
    price: 25.00,
    discount: 15,
    category: 'Antibióticos',
    stock: 80,
    imageUrl: 'https://example.com/amoxicilina.jpg',
    sku: 'AMO-500-21'
  },
  {
    name: 'Omeprazol 20mg',
    description: 'Inibidor da bomba de prótons para tratamento de acidez estomacal. 28 cápsulas.',
    price: 18.90,
    discount: 30,
    category: 'Gastrointestinais',
    stock: 120,
    imageUrl: 'https://example.com/omeprazol.jpg',
    sku: 'OME-20-28'
  },
  {
    name: 'Losartana Potássica 50mg',
    description: 'Anti-hipertensivo. Para controle da pressão arterial. Caixa com 30 comprimidos.',
    price: 22.00,
    discount: 20,
    category: 'Cardiovasculares',
    stock: 90,
    imageUrl: 'https://example.com/losartana.jpg',
    sku: 'LOS-50-30'
  },
  {
    name: 'Vitamina C 1g',
    description: 'Suplemento vitamínico que fortalece o sistema imunológico. 30 comprimidos efervescentes.',
    price: 15.50,
    discount: 10,
    category: 'Vitaminas',
    stock: 180,
    imageUrl: 'https://example.com/vitamina-c.jpg',
    sku: 'VIT-C-1G-30'
  },
  {
    name: 'Ibuprofeno 600mg',
    description: 'Anti-inflamatório e analgésico potente. Cartela com 10 comprimidos revestidos.',
    price: 14.90,
    discount: 20,
    category: 'Anti-inflamatórios',
    stock: 160,
    imageUrl: 'https://example.com/ibuprofeno.jpg',
    sku: 'IBU-600-10'
  },
  {
    name: 'Loratadina 10mg',
    description: 'Antialérgico de longa duração. Alivia sintomas de rinite e urticária. 12 comprimidos.',
    price: 11.50,
    discount: 15,
    category: 'Antialérgicos',
    stock: 140,
    imageUrl: 'https://example.com/loratadina.jpg',
    sku: 'LOR-10-12'
  },
  {
    name: 'Simeticona 40mg',
    description: 'Elimina gases intestinais e alivia cólicas. Frasco com 15ml de gotas.',
    price: 9.90,
    discount: 10,
    category: 'Gastrointestinais',
    stock: 100,
    imageUrl: 'https://example.com/simeticona.jpg',
    sku: 'SIM-40-15ML'
  },
  {
    name: 'Dorflex',
    description: 'Relaxante muscular e analgésico. Ideal para dores de cabeça tensionais. 20 comprimidos.',
    price: 16.50,
    discount: 25,
    category: 'Relaxantes Musculares',
    stock: 110,
    imageUrl: 'https://example.com/dorflex.jpg',
    sku: 'DOR-20'
  }
];

async function seedProducts() {
  try {
    console.log('🌱 Seeding products...');

    for (const product of products) {
      await prisma.product.create({
        data: product
      });
      console.log(`   ✅ Created: ${product.name}`);
    }

    console.log(`\n✅ Successfully seeded ${products.length} products!`);

    const total = await prisma.product.count();
    console.log(`📊 Total products in database: ${total}`);

  } catch (error) {
    console.error('❌ Error seeding products:', error);
  } finally {
    await prisma.$disconnect();
  }
}

seedProducts();
