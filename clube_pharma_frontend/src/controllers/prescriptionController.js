import prisma from '../config/database.js';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Upload de receita médica (com arquivo)
export const uploadPrescription = async (req, res) => {
  try {
    const { doctorName, issuedAt, notes, category } = req.body;

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No file uploaded'
      });
    }

    const prescription = await prisma.prescription.create({
      data: {
        userId: req.user.id,
        doctorName,
        issuedAt: issuedAt ? new Date(issuedAt) : new Date(),
        notes: notes || null,
        category: category || 'GERAL',
        fileUrl: req.file.filename,
        fileType: req.file.mimetype,
        fileSize: req.file.size
      }
    });

    res.status(201).json({
      success: true,
      message: 'Prescription uploaded successfully',
      data: prescription
    });
  } catch (error) {
    // Se der erro, remove o arquivo que foi feito upload
    if (req.file) {
      const filePath = req.file.path;
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }

    console.error('Error uploading prescription:', error);
    res.status(500).json({
      success: false,
      message: 'Error uploading prescription',
      error: error.message
    });
  }
};

// Listar todas as receitas do usuário
export const getPrescriptions = async (req, res) => {
  try {
    const { category, startDate, endDate } = req.query;

    const where = { userId: req.user.id };

    if (category && category !== 'all') {
      where.category = category;
    }

    if (startDate || endDate) {
      where.issuedAt = {};
      if (startDate) where.issuedAt.gte = new Date(startDate);
      if (endDate) where.issuedAt.lte = new Date(endDate);
    }

    const prescriptions = await prisma.prescription.findMany({
      where,
      orderBy: { issuedAt: 'desc' }
    });

    res.status(200).json({
      success: true,
      data: prescriptions
    });
  } catch (error) {
    console.error('Error fetching prescriptions:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching prescriptions',
      error: error.message
    });
  }
};

// Buscar receita por ID
export const getPrescriptionById = async (req, res) => {
  try {
    const { id } = req.params;

    const prescription = await prisma.prescription.findUnique({
      where: { id }
    });

    if (!prescription) {
      return res.status(404).json({
        success: false,
        message: 'Prescription not found'
      });
    }

    // Verifica se o usuário é dono da receita
    if (prescription.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.status(200).json({
      success: true,
      data: prescription
    });
  } catch (error) {
    console.error('Error fetching prescription:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching prescription',
      error: error.message
    });
  }
};

// Download de arquivo de receita
export const downloadPrescription = async (req, res) => {
  try {
    const { id } = req.params;

    const prescription = await prisma.prescription.findUnique({
      where: { id }
    });

    if (!prescription) {
      return res.status(404).json({
        success: false,
        message: 'Prescription not found'
      });
    }

    // Verifica se o usuário é dono da receita
    if (prescription.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    const filePath = path.join(__dirname, '../../uploads/prescriptions', prescription.fileUrl);

    if (!fs.existsSync(filePath)) {
      return res.status(404).json({
        success: false,
        message: 'File not found'
      });
    }

    // Define o nome do arquivo para download
    const originalName = prescription.fileUrl.split('_').slice(2).join('_');

    res.download(filePath, originalName, (err) => {
      if (err) {
        console.error('Error downloading file:', err);
        res.status(500).json({
          success: false,
          message: 'Error downloading file'
        });
      }
    });
  } catch (error) {
    console.error('Error downloading prescription:', error);
    res.status(500).json({
      success: false,
      message: 'Error downloading prescription',
      error: error.message
    });
  }
};

// Atualizar receita (sem alterar arquivo)
export const updatePrescription = async (req, res) => {
  try {
    const { id } = req.params;
    const { doctorName, issuedAt, notes, category } = req.body;

    const prescription = await prisma.prescription.findUnique({
      where: { id }
    });

    if (!prescription) {
      return res.status(404).json({
        success: false,
        message: 'Prescription not found'
      });
    }

    if (prescription.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    const updatedPrescription = await prisma.prescription.update({
      where: { id },
      data: {
        doctorName: doctorName || prescription.doctorName,
        issuedAt: issuedAt ? new Date(issuedAt) : prescription.issuedAt,
        notes: notes !== undefined ? notes : prescription.notes,
        category: category || prescription.category
      }
    });

    res.status(200).json({
      success: true,
      message: 'Prescription updated successfully',
      data: updatedPrescription
    });
  } catch (error) {
    console.error('Error updating prescription:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating prescription',
      error: error.message
    });
  }
};

// Deletar receita
export const deletePrescription = async (req, res) => {
  try {
    const { id } = req.params;

    const prescription = await prisma.prescription.findUnique({
      where: { id }
    });

    if (!prescription) {
      return res.status(404).json({
        success: false,
        message: 'Prescription not found'
      });
    }

    if (prescription.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Remove o arquivo físico
    const filePath = path.join(__dirname, '../../uploads/prescriptions', prescription.fileUrl);
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }

    // Remove do banco
    await prisma.prescription.delete({
      where: { id }
    });

    res.status(200).json({
      success: true,
      message: 'Prescription deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting prescription:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting prescription',
      error: error.message
    });
  }
};

// Buscar categorias de receitas
export const getPrescriptionCategories = async (req, res) => {
  try {
    const categories = await prisma.prescription.groupBy({
      by: ['category'],
      where: { userId: req.user.id },
      _count: { category: true }
    });

    const formattedCategories = categories.map(cat => ({
      name: cat.category,
      count: cat._count.category
    }));

    res.status(200).json({
      success: true,
      data: formattedCategories
    });
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching categories',
      error: error.message
    });
  }
};
