import { validationResult } from 'express-validator';
import prisma from '../config/database.js';

// Record a pill take
export const createPillTake = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { treatmentId } = req.params;
    const { notes } = req.body;

    // Check if treatment exists and belongs to user
    const treatment = await prisma.treatment.findUnique({
      where: { id: treatmentId }
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

    const pillTake = await prisma.pillTake.create({
      data: {
        treatmentId,
        notes
      }
    });

    res.status(201).json({
      success: true,
      message: 'Pill take recorded successfully',
      data: pillTake
    });
  } catch (error) {
    console.error('Create pill take error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get pill takes for a specific treatment
export const getPillTakesByTreatment = async (req, res) => {
  try {
    const { treatmentId } = req.params;

    // Check if treatment exists and belongs to user
    const treatment = await prisma.treatment.findUnique({
      where: { id: treatmentId }
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

    const pillTakes = await prisma.pillTake.findMany({
      where: { treatmentId },
      orderBy: {
        takenAt: 'desc'
      }
    });

    res.status(200).json({
      success: true,
      data: pillTakes
    });
  } catch (error) {
    console.error('Get pill takes error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get today's pill takes for the user
export const getTodayPillTakes = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    // Get all active treatments for the user
    const treatments = await prisma.treatment.findMany({
      where: {
        userId: req.user.id,
        status: 'ACTIVE'
      },
      include: {
        pillTakes: {
          where: {
            takenAt: {
              gte: today,
              lt: tomorrow
            }
          }
        }
      }
    });

    res.status(200).json({
      success: true,
      data: treatments
    });
  } catch (error) {
    console.error('Get today pill takes error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get upcoming pills (next 24 hours)
export const getUpcomingPills = async (req, res) => {
  try {
    const now = new Date();
    const tomorrow = new Date(now);
    tomorrow.setHours(tomorrow.getHours() + 24);

    // Get all active treatments for the user
    const treatments = await prisma.treatment.findMany({
      where: {
        userId: req.user.id,
        status: 'ACTIVE',
        endDate: {
          gte: now // Only treatments that haven't ended yet
        }
      },
      include: {
        pillTakes: {
          orderBy: {
            takenAt: 'desc'
          },
          take: 1
        }
      }
    });

    // Calculate upcoming reminders based on reminderTime and frequency
    const upcomingPills = treatments.map(treatment => {
      return {
        treatment: {
          id: treatment.id,
          medicationName: treatment.medicationName,
          dosage: treatment.dosage,
          frequency: treatment.frequency,
          reminderTime: treatment.reminderTime
        },
        lastTaken: treatment.pillTakes[0]?.takenAt || null,
        nextReminder: treatment.reminderTime // In a real app, calculate based on frequency
      };
    });

    res.status(200).json({
      success: true,
      data: upcomingPills
    });
  } catch (error) {
    console.error('Get upcoming pills error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get treatment adherence statistics
export const getAdherenceStats = async (req, res) => {
  try {
    const { treatmentId } = req.params;
    const { days = 7 } = req.query; // Default to last 7 days

    // Check if treatment exists and belongs to user
    const treatment = await prisma.treatment.findUnique({
      where: { id: treatmentId }
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

    const startDate = new Date();
    startDate.setDate(startDate.getDate() - parseInt(days));
    startDate.setHours(0, 0, 0, 0);

    // Get all pill takes in the period
    const pillTakes = await prisma.pillTake.findMany({
      where: {
        treatmentId,
        takenAt: {
          gte: startDate
        }
      },
      orderBy: {
        takenAt: 'asc'
      }
    });

    // Calculate statistics
    const totalDays = parseInt(days);
    const totalTaken = pillTakes.length;

    // Parse frequency to calculate expected takes
    // This is simplified - in production you'd parse "8 em 8 horas", "12 em 12 horas", etc.
    const expectedPerDay = 3; // Default assumption
    const expectedTotal = totalDays * expectedPerDay;

    const adherenceRate = expectedTotal > 0
      ? ((totalTaken / expectedTotal) * 100).toFixed(2)
      : 0;

    // Group by day
    const takesByDay = {};
    pillTakes.forEach(take => {
      const day = take.takenAt.toISOString().split('T')[0];
      takesByDay[day] = (takesByDay[day] || 0) + 1;
    });

    res.status(200).json({
      success: true,
      data: {
        treatmentId,
        period: {
          days: totalDays,
          startDate,
          endDate: new Date()
        },
        statistics: {
          totalTaken,
          expectedTotal,
          adherenceRate: parseFloat(adherenceRate),
          missedDoses: Math.max(0, expectedTotal - totalTaken)
        },
        takesByDay
      }
    });
  } catch (error) {
    console.error('Get adherence stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Get overall adherence dashboard
export const getAdherenceDashboard = async (req, res) => {
  try {
    const { days = 7 } = req.query;

    const startDate = new Date();
    startDate.setDate(startDate.getDate() - parseInt(days));
    startDate.setHours(0, 0, 0, 0);

    // Get all active treatments
    const treatments = await prisma.treatment.findMany({
      where: {
        userId: req.user.id,
        status: 'ACTIVE'
      },
      include: {
        pillTakes: {
          where: {
            takenAt: {
              gte: startDate
            }
          }
        }
      }
    });

    // Calculate overall stats
    let totalTaken = 0;
    let totalExpected = 0;

    const treatmentStats = treatments.map(treatment => {
      const taken = treatment.pillTakes.length;
      const expected = parseInt(days) * 3; // Simplified

      totalTaken += taken;
      totalExpected += expected;

      return {
        id: treatment.id,
        medicationName: treatment.medicationName,
        taken,
        expected,
        adherenceRate: expected > 0 ? ((taken / expected) * 100).toFixed(2) : 0
      };
    });

    const overallAdherence = totalExpected > 0
      ? ((totalTaken / totalExpected) * 100).toFixed(2)
      : 0;

    res.status(200).json({
      success: true,
      data: {
        period: {
          days: parseInt(days),
          startDate,
          endDate: new Date()
        },
        overall: {
          totalTreatments: treatments.length,
          totalTaken,
          totalExpected,
          adherenceRate: parseFloat(overallAdherence),
          missedDoses: Math.max(0, totalExpected - totalTaken)
        },
        treatments: treatmentStats
      }
    });
  } catch (error) {
    console.error('Get adherence dashboard error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};
