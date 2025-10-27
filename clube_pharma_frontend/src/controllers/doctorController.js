import prisma from '../config/database.js';

// Listar todos os médicos (com filtros)
export const getDoctors = async (req, res) => {
  try {
    const { specialty, city, telemedicine, search, page = 1, limit = 20 } = req.query;

    const where = { isActive: true };

    if (specialty) where.specialty = specialty;
    if (city) where.city = { contains: city, mode: 'insensitive' };
    if (telemedicine === 'true') where.telemedicine = true;
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { specialty: { contains: search, mode: 'insensitive' } },
        { clinicName: { contains: search, mode: 'insensitive' } }
      ];
    }

    const skip = (parseInt(page) - 1) * parseInt(limit);

    const [doctors, total] = await Promise.all([
      prisma.doctor.findMany({
        where,
        skip,
        take: parseInt(limit),
        orderBy: { rating: 'desc' }
      }),
      prisma.doctor.count({ where })
    ]);

    res.status(200).json({
      success: true,
      data: doctors,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });
  } catch (error) {
    console.error('Error fetching doctors:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching doctors',
      error: error.message
    });
  }
};

// Buscar médico por ID
export const getDoctorById = async (req, res) => {
  try {
    const { id } = req.params;

    const doctor = await prisma.doctor.findUnique({
      where: { id },
      include: {
        appointments: {
          where: { status: { in: ['SCHEDULED', 'CONFIRMED'] } },
          select: { date: true, time: true }
        }
      }
    });

    if (!doctor || !doctor.isActive) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    res.status(200).json({
      success: true,
      data: doctor
    });
  } catch (error) {
    console.error('Error fetching doctor:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching doctor',
      error: error.message
    });
  }
};

// Listar especialidades
export const getSpecialties = async (req, res) => {
  try {
    const specialties = await prisma.doctor.groupBy({
      by: ['specialty'],
      where: { isActive: true },
      _count: { specialty: true }
    });

    const formattedSpecialties = specialties.map(s => ({
      name: s.specialty,
      count: s._count.specialty
    }));

    res.status(200).json({
      success: true,
      data: formattedSpecialties
    });
  } catch (error) {
    console.error('Error fetching specialties:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching specialties',
      error: error.message
    });
  }
};

// Criar médico (ADMIN)
export const createDoctor = async (req, res) => {
  try {
    const {
      name, specialty, crm, clinicName, address, city, state,
      zipCode, phone, email, price, discount, telemedicine
    } = req.body;

    const existingDoctor = await prisma.doctor.findUnique({
      where: { crm }
    });

    if (existingDoctor) {
      return res.status(400).json({
        success: false,
        message: 'Doctor with this CRM already exists'
      });
    }

    const doctor = await prisma.doctor.create({
      data: {
        name, specialty, crm, clinicName, address, city, state,
        zipCode, phone, email,
        price: parseFloat(price),
        discount: discount ? parseInt(discount) : 20,
        telemedicine: telemedicine === true || telemedicine === 'true'
      }
    });

    res.status(201).json({
      success: true,
      message: 'Doctor created successfully',
      data: doctor
    });
  } catch (error) {
    console.error('Error creating doctor:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating doctor',
      error: error.message
    });
  }
};

// Atualizar médico (ADMIN)
export const updateDoctor = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = { ...req.body };

    if (updateData.price) updateData.price = parseFloat(updateData.price);
    if (updateData.discount) updateData.discount = parseInt(updateData.discount);
    if (updateData.telemedicine !== undefined) {
      updateData.telemedicine = updateData.telemedicine === true || updateData.telemedicine === 'true';
    }

    const doctor = await prisma.doctor.update({
      where: { id },
      data: updateData
    });

    res.status(200).json({
      success: true,
      message: 'Doctor updated successfully',
      data: doctor
    });
  } catch (error) {
    console.error('Error updating doctor:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating doctor',
      error: error.message
    });
  }
};

// Deletar médico (ADMIN)
export const deleteDoctor = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.doctor.update({
      where: { id },
      data: { isActive: false }
    });

    res.status(200).json({
      success: true,
      message: 'Doctor deactivated successfully'
    });
  } catch (error) {
    console.error('Error deleting doctor:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting doctor',
      error: error.message
    });
  }
};
