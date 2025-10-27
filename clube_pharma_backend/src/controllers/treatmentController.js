import { validationResult } from 'express-validator';
import prisma from '../config/database.js';

// Create a new treatment
export const createTreatment = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const {
      medicationName,
      dosage,
      frequency,
      startDate,
      endDate,
      reminderTime,
      notes
    } = req.body;

    const treatment = await prisma.treatment.create({
      data: {
        userId: req.user.id,
        medicationName,
        dosage,
        frequency,
        startDate: new Date(startDate),
        endDate: new Date(endDate),
        reminderTime,
        notes,
        status: 'ACTIVE'
      }
    });

    res.status(201).json({
      success: true,
      message: 'Treatment created successfully',
      data: treatment
    });
  } catch (error) {
    console.error('Create treatment error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get all treatments for the logged-in user
export const getTreatments = async (req, res) => {
  try {
    const { status } = req.query;

    const where = {
      userId: req.user.id
    };

    if (status) {
      where.status = status.toUpperCase();
    }

    const treatments = await prisma.treatment.findMany({
      where,
      include: {
        pillTakes: {
          orderBy: {
            takenAt: 'desc'
          },
          take: 5
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    res.status(200).json({
      success: true,
      data: treatments
    });
  } catch (error) {
    console.error('Get treatments error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get a single treatment by ID
export const getTreatmentById = async (req, res) => {
  try {
    const { id } = req.params;

    const treatment = await prisma.treatment.findUnique({
      where: { id },
      include: {
        pillTakes: {
          orderBy: {
            takenAt: 'desc'
          }
        }
      }
    });

    if (!treatment) {
      return res.status(404).json({
        success: false,
        message: 'Treatment not found'
      });
    }

    // Check if the treatment belongs to the user
    if (treatment.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.status(200).json({
      success: true,
      data: treatment
    });
  } catch (error) {
    console.error('Get treatment error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Update a treatment
export const updateTreatment = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { id } = req.params;
    const {
      medicationName,
      dosage,
      frequency,
      startDate,
      endDate,
      reminderTime,
      status,
      notes
    } = req.body;

    // Check if treatment exists and belongs to user
    const existingTreatment = await prisma.treatment.findUnique({
      where: { id }
    });

    if (!existingTreatment) {
      return res.status(404).json({
        success: false,
        message: 'Treatment not found'
      });
    }

    if (existingTreatment.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    const updateData = {};
    if (medicationName) updateData.medicationName = medicationName;
    if (dosage) updateData.dosage = dosage;
    if (frequency) updateData.frequency = frequency;
    if (startDate) updateData.startDate = new Date(startDate);
    if (endDate) updateData.endDate = new Date(endDate);
    if (reminderTime !== undefined) updateData.reminderTime = reminderTime;
    if (status) updateData.status = status.toUpperCase();
    if (notes !== undefined) updateData.notes = notes;

    const treatment = await prisma.treatment.update({
      where: { id },
      data: updateData
    });

    res.status(200).json({
      success: true,
      message: 'Treatment updated successfully',
      data: treatment
    });
  } catch (error) {
    console.error('Update treatment error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Delete a treatment
export const deleteTreatment = async (req, res) => {
  try {
    const { id } = req.params;

    // Check if treatment exists and belongs to user
    const treatment = await prisma.treatment.findUnique({
      where: { id }
    });

    if (!treatment) {
      return res.status(404).json({
        success: false,
        message: 'Treatment not found'
      });
    }

    if (treatment.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    await prisma.treatment.delete({
      where: { id }
    });

    res.status(200).json({
      success: true,
      message: 'Treatment deleted successfully'
    });
  } catch (error) {
    console.error('Delete treatment error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get only active treatments
export const getActiveTreatments = async (req, res) => {
  try {
    const now = new Date();

    const treatments = await prisma.treatment.findMany({
      where: {
        userId: req.user.id,
        status: "ACTIVE",
        endDate: {
          gte: now
        }
      },
      include: {
        pillTakes: {
          orderBy: {
            takenAt: "desc"
          },
          take: 5
        }
      },
      orderBy: {
        startDate: "asc"
      }
    });

    res.status(200).json({
      success: true,
      data: treatments
    });
  } catch (error) {
    console.error("Get active treatments error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};
