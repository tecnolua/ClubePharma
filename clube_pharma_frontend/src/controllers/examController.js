import prisma from '../config/database.js';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Upload de exame (com arquivo)
export const uploadExam = async (req, res) => {
  try {
    const { examType, examDate, doctorName, notes, category } = req.body;

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No file uploaded'
      });
    }

    if (!examType) {
      // Remove o arquivo se dados obrigatórios faltarem
      if (req.file && fs.existsSync(req.file.path)) {
        fs.unlinkSync(req.file.path);
      }
      return res.status(400).json({
        success: false,
        message: 'Exam type is required'
      });
    }

    const exam = await prisma.exam.create({
      data: {
        userId: req.user.id,
        examType,
        examDate: examDate ? new Date(examDate) : new Date(),
        doctorName: doctorName || null,
        notes: notes || null,
        category: category || 'GERAL',
        fileUrl: req.file.filename,
        fileType: req.file.mimetype,
        fileSize: req.file.size
      }
    });

    res.status(201).json({
      success: true,
      message: 'Exam uploaded successfully',
      data: exam
    });
  } catch (error) {
    // Se der erro, remove o arquivo que foi feito upload
    if (req.file) {
      const filePath = req.file.path;
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }

    console.error('Error uploading exam:', error);
    res.status(500).json({
      success: false,
      message: 'Error uploading exam',
      error: error.message
    });
  }
};

// Listar todos os exames do usuário
export const getExams = async (req, res) => {
  try {
    const { category, examType, startDate, endDate } = req.query;

    const where = { userId: req.user.id };

    if (category && category !== 'all') {
      where.category = category;
    }

    if (examType) {
      where.examType = { contains: examType, mode: 'insensitive' };
    }

    if (startDate || endDate) {
      where.examDate = {};
      if (startDate) where.examDate.gte = new Date(startDate);
      if (endDate) where.examDate.lte = new Date(endDate);
    }

    const exams = await prisma.exam.findMany({
      where,
      orderBy: { examDate: 'desc' }
    });

    res.status(200).json({
      success: true,
      data: exams
    });
  } catch (error) {
    console.error('Error fetching exams:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching exams',
      error: error.message
    });
  }
};

// Buscar exame por ID
export const getExamById = async (req, res) => {
  try {
    const { id } = req.params;

    const exam = await prisma.exam.findUnique({
      where: { id }
    });

    if (!exam) {
      return res.status(404).json({
        success: false,
        message: 'Exam not found'
      });
    }

    // Verifica se o usuário é dono do exame
    if (exam.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.status(200).json({
      success: true,
      data: exam
    });
  } catch (error) {
    console.error('Error fetching exam:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching exam',
      error: error.message
    });
  }
};

// Download de arquivo de exame
export const downloadExam = async (req, res) => {
  try {
    const { id } = req.params;

    const exam = await prisma.exam.findUnique({
      where: { id }
    });

    if (!exam) {
      return res.status(404).json({
        success: false,
        message: 'Exam not found'
      });
    }

    // Verifica se o usuário é dono do exame
    if (exam.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    const filePath = path.join(__dirname, '../../uploads/exams', exam.fileUrl);

    if (!fs.existsSync(filePath)) {
      return res.status(404).json({
        success: false,
        message: 'File not found'
      });
    }

    // Define o nome do arquivo para download
    const originalName = exam.fileUrl.split('_').slice(2).join('_');

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
    console.error('Error downloading exam:', error);
    res.status(500).json({
      success: false,
      message: 'Error downloading exam',
      error: error.message
    });
  }
};

// Atualizar exame (sem alterar arquivo)
export const updateExam = async (req, res) => {
  try {
    const { id } = req.params;
    const { examType, examDate, doctorName, notes, category } = req.body;

    const exam = await prisma.exam.findUnique({
      where: { id }
    });

    if (!exam) {
      return res.status(404).json({
        success: false,
        message: 'Exam not found'
      });
    }

    if (exam.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    const updatedExam = await prisma.exam.update({
      where: { id },
      data: {
        examType: examType || exam.examType,
        examDate: examDate ? new Date(examDate) : exam.examDate,
        doctorName: doctorName !== undefined ? doctorName : exam.doctorName,
        notes: notes !== undefined ? notes : exam.notes,
        category: category || exam.category
      }
    });

    res.status(200).json({
      success: true,
      message: 'Exam updated successfully',
      data: updatedExam
    });
  } catch (error) {
    console.error('Error updating exam:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating exam',
      error: error.message
    });
  }
};

// Deletar exame
export const deleteExam = async (req, res) => {
  try {
    const { id } = req.params;

    const exam = await prisma.exam.findUnique({
      where: { id }
    });

    if (!exam) {
      return res.status(404).json({
        success: false,
        message: 'Exam not found'
      });
    }

    if (exam.userId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Remove o arquivo físico
    const filePath = path.join(__dirname, '../../uploads/exams', exam.fileUrl);
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }

    // Remove do banco
    await prisma.exam.delete({
      where: { id }
    });

    res.status(200).json({
      success: true,
      message: 'Exam deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting exam:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting exam',
      error: error.message
    });
  }
};

// Buscar categorias de exames
export const getExamCategories = async (req, res) => {
  try {
    const categories = await prisma.exam.groupBy({
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

// Buscar tipos de exames (agrupados)
export const getExamTypes = async (req, res) => {
  try {
    const types = await prisma.exam.groupBy({
      by: ['examType'],
      where: { userId: req.user.id },
      _count: { examType: true }
    });

    const formattedTypes = types.map(type => ({
      name: type.examType,
      count: type._count.examType
    }));

    res.status(200).json({
      success: true,
      data: formattedTypes
    });
  } catch (error) {
    console.error('Error fetching exam types:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching exam types',
      error: error.message
    });
  }
};
