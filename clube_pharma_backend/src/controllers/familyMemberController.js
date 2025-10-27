import { validationResult } from 'express-validator';
import prisma from '../config/database.js';

// Get all family members
export const getFamilyMembers = async (req, res) => {
  try {
    const familyMembers = await prisma.familyMember.findMany({
      where: { userId: req.user.id },
      orderBy: { createdAt: 'desc' }
    });

    res.status(200).json({
      success: true,
      data: familyMembers
    });
  } catch (error) {
    console.error('Get family members error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get single family member
export const getFamilyMemberById = async (req, res) => {
  try {
    const { id } = req.params;

    const familyMember = await prisma.familyMember.findUnique({
      where: { id }
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: 'Family member not found'
      });
    }

    // Check if the family member belongs to the user
    if (familyMember.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.status(200).json({
      success: true,
      data: familyMember
    });
  } catch (error) {
    console.error('Get family member error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Create family member
export const createFamilyMember = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    // Check if user has FAMILY plan
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: { planType: true }
    });

    if (user.planType !== 'FAMILY') {
      return res.status(403).json({
        success: false,
        message: 'You need a FAMILY plan to add family members. Please upgrade your plan.'
      });
    }

    const { name, birthDate, cpf } = req.body;

    // Check if CPF is already in use (if provided)
    if (cpf) {
      const existingMember = await prisma.familyMember.findFirst({
        where: {
          cpf,
          userId: req.user.id
        }
      });

      if (existingMember) {
        return res.status(400).json({
          success: false,
          message: 'A family member with this CPF already exists'
        });
      }
    }

    const familyMember = await prisma.familyMember.create({
      data: {
        userId: req.user.id,
        name,
        birthDate: new Date(birthDate),
        cpf
      }
    });

    res.status(201).json({
      success: true,
      message: 'Family member added successfully',
      data: familyMember
    });
  } catch (error) {
    console.error('Create family member error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Update family member
export const updateFamilyMember = async (req, res) => {
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
    const { name, birthDate, cpf } = req.body;

    // Check if family member exists and belongs to user
    const existingMember = await prisma.familyMember.findUnique({
      where: { id }
    });

    if (!existingMember) {
      return res.status(404).json({
        success: false,
        message: 'Family member not found'
      });
    }

    if (existingMember.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Check if new CPF is already in use (if provided and different)
    if (cpf && cpf !== existingMember.cpf) {
      const duplicateCpf = await prisma.familyMember.findFirst({
        where: {
          cpf,
          userId: req.user.id,
          id: { not: id }
        }
      });

      if (duplicateCpf) {
        return res.status(400).json({
          success: false,
          message: 'A family member with this CPF already exists'
        });
      }
    }

    const updateData = {};
    if (name) updateData.name = name;
    if (birthDate) updateData.birthDate = new Date(birthDate);
    if (cpf !== undefined) updateData.cpf = cpf;

    const familyMember = await prisma.familyMember.update({
      where: { id },
      data: updateData
    });

    res.status(200).json({
      success: true,
      message: 'Family member updated successfully',
      data: familyMember
    });
  } catch (error) {
    console.error('Update family member error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Update family member avatar
export const updateFamilyMemberAvatar = async (req, res) => {
  try {
    const { id } = req.params;

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No file uploaded'
      });
    }

    // Check if family member exists and belongs to user
    const existingMember = await prisma.familyMember.findUnique({
      where: { id }
    });

    if (!existingMember) {
      return res.status(404).json({
        success: false,
        message: 'Family member not found'
      });
    }

    if (existingMember.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    const avatarUrl = `/uploads/avatars/${req.file.filename}`;

    const familyMember = await prisma.familyMember.update({
      where: { id },
      data: { avatar: avatarUrl }
    });

    res.status(200).json({
      success: true,
      message: 'Avatar uploaded successfully',
      data: familyMember
    });
  } catch (error) {
    console.error('Update family member avatar error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Delete family member
export const deleteFamilyMember = async (req, res) => {
  try {
    const { id } = req.params;

    // Check if family member exists and belongs to user
    const familyMember = await prisma.familyMember.findUnique({
      where: { id }
    });

    if (!familyMember) {
      return res.status(404).json({
        success: false,
        message: 'Family member not found'
      });
    }

    if (familyMember.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    await prisma.familyMember.delete({
      where: { id }
    });

    res.status(200).json({
      success: true,
      message: 'Family member removed successfully'
    });
  } catch (error) {
    console.error('Delete family member error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};
