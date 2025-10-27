import prisma from '../config/database.js';

/**
 * Doctor Controller
 * Handles all doctor-related operations
 */

/**
 * GET /api/doctors
 * Get all doctors with optional filters
 * Query params: specialty, city, telemedicine, search, page, limit
 */
export const getDoctors = async (req, res) => {
  try {
    const {
      specialty,
      city,
      telemedicine,
      search,
      page = 1,
      limit = 10
    } = req.query;

    // Build where clause
    const where = {
      isActive: true
    };

    if (specialty) {
      where.specialty = specialty;
    }

    if (city) {
      where.city = {
        contains: city,
        mode: 'insensitive'
      };
    }

    if (telemedicine !== undefined) {
      where.telemedicine = telemedicine === 'true';
    }

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { specialty: { contains: search, mode: 'insensitive' } },
        { bio: { contains: search, mode: 'insensitive' } }
      ];
    }

    // Pagination
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const take = parseInt(limit);

    // Get doctors and total count
    const [doctors, total] = await Promise.all([
      prisma.doctor.findMany({
        where,
        skip,
        take,
        orderBy: { name: 'asc' }
      }),
      prisma.doctor.count({ where })
    ]);

    res.status(200).json({
      success: true,
      message: 'Doctors retrieved successfully',
      data: {
        doctors,
        pagination: {
          total,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(total / parseInt(limit))
        }
      }
    });
  } catch (error) {
    console.error('Error getting doctors:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve doctors',
      error: error.message
    });
  }
};

/**
 * GET /api/doctors/specialties
 * Get all unique specialties
 */
export const getSpecialties = async (req, res) => {
  try {
    const doctors = await prisma.doctor.findMany({
      where: { isActive: true },
      select: { specialty: true },
      distinct: ['specialty']
    });

    const specialties = doctors.map(d => d.specialty).sort();

    res.status(200).json({
      success: true,
      message: 'Specialties retrieved successfully',
      data: { specialties }
    });
  } catch (error) {
    console.error('Error getting specialties:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve specialties',
      error: error.message
    });
  }
};

/**
 * GET /api/doctors/:id
 * Get doctor by ID
 */
export const getDoctorById = async (req, res) => {
  try {
    const { id } = req.params;

    const doctor = await prisma.doctor.findUnique({
      where: { id }
    });

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Doctor retrieved successfully',
      data: { doctor }
    });
  } catch (error) {
    console.error('Error getting doctor by ID:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve doctor',
      error: error.message
    });
  }
};

/**
 * POST /api/doctors
 * Create new doctor (Admin only)
 */
export const createDoctor = async (req, res) => {
  try {
    const {
      name,
      specialty,
      crm,
      phone,
      email,
      city,
      state,
      address,
      bio,
      photo,
      consultationPrice,
      telemedicine
    } = req.body;

    // Validation
    if (!name || !specialty || !crm) {
      return res.status(400).json({
        success: false,
        message: 'Name, specialty, and CRM are required'
      });
    }

    // Check if CRM already exists
    const existingDoctor = await prisma.doctor.findUnique({
      where: { crm }
    });

    if (existingDoctor) {
      return res.status(400).json({
        success: false,
        message: 'Doctor with this CRM already exists'
      });
    }

    // Create doctor
    const doctor = await prisma.doctor.create({
      data: {
        name,
        specialty,
        crm,
        phone,
        email,
        city,
        state,
        address,
        bio,
        photo,
        consultationPrice: consultationPrice ? parseFloat(consultationPrice) : null,
        telemedicine: telemedicine || false,
        isActive: true
      }
    });

    res.status(201).json({
      success: true,
      message: 'Doctor created successfully',
      data: { doctor }
    });
  } catch (error) {
    console.error('Error creating doctor:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create doctor',
      error: error.message
    });
  }
};

/**
 * PUT /api/doctors/:id
 * Update doctor (Admin only)
 */
export const updateDoctor = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      name,
      specialty,
      crm,
      phone,
      email,
      city,
      state,
      address,
      bio,
      photo,
      consultationPrice,
      telemedicine,
      isActive
    } = req.body;

    // Check if doctor exists
    const existingDoctor = await prisma.doctor.findUnique({
      where: { id }
    });

    if (!existingDoctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    // If updating CRM, check if it's already in use by another doctor
    if (crm && crm !== existingDoctor.crm) {
      const crmInUse = await prisma.doctor.findUnique({
        where: { crm }
      });

      if (crmInUse) {
        return res.status(400).json({
          success: false,
          message: 'CRM already in use by another doctor'
        });
      }
    }

    // Update doctor
    const updateData = {};
    if (name !== undefined) updateData.name = name;
    if (specialty !== undefined) updateData.specialty = specialty;
    if (crm !== undefined) updateData.crm = crm;
    if (phone !== undefined) updateData.phone = phone;
    if (email !== undefined) updateData.email = email;
    if (city !== undefined) updateData.city = city;
    if (state !== undefined) updateData.state = state;
    if (address !== undefined) updateData.address = address;
    if (bio !== undefined) updateData.bio = bio;
    if (photo !== undefined) updateData.photo = photo;
    if (consultationPrice !== undefined) updateData.consultationPrice = parseFloat(consultationPrice);
    if (telemedicine !== undefined) updateData.telemedicine = telemedicine;
    if (isActive !== undefined) updateData.isActive = isActive;

    const doctor = await prisma.doctor.update({
      where: { id },
      data: updateData
    });

    res.status(200).json({
      success: true,
      message: 'Doctor updated successfully',
      data: { doctor }
    });
  } catch (error) {
    console.error('Error updating doctor:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update doctor',
      error: error.message
    });
  }
};

/**
 * DELETE /api/doctors/:id
 * Delete doctor (Admin only) - Soft delete by setting isActive to false
 */
export const deleteDoctor = async (req, res) => {
  try {
    const { id } = req.params;

    // Check if doctor exists
    const existingDoctor = await prisma.doctor.findUnique({
      where: { id }
    });

    if (!existingDoctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    // Soft delete - set isActive to false
    const doctor = await prisma.doctor.update({
      where: { id },
      data: { isActive: false }
    });

    res.status(200).json({
      success: true,
      message: 'Doctor deleted successfully',
      data: { doctor }
    });
  } catch (error) {
    console.error('Error deleting doctor:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete doctor',
      error: error.message
    });
  }
};
