import prisma from '../config/database.js';

/**
 * Appointment Controller
 * Handles all appointment-related operations
 */

/**
 * Helper function to generate time slots
 * Returns array of time strings from 08:00 to 18:00 in 30-minute intervals
 */
const generateTimeSlots = () => {
  const slots = [];
  for (let hour = 8; hour < 18; hour++) {
    slots.push(`${hour.toString().padStart(2, '0')}:00`);
    slots.push(`${hour.toString().padStart(2, '0')}:30`);
  }
  return slots;
};

/**
 * GET /api/appointments/available-slots
 * Get available time slots for a doctor on a specific date
 * Query params: doctorId (required), date (required, format: YYYY-MM-DD)
 */
export const getAvailableSlots = async (req, res) => {
  try {
    const { doctorId, date } = req.query;

    // Validation
    if (!doctorId || !date) {
      return res.status(400).json({
        success: false,
        message: 'Doctor ID and date are required'
      });
    }

    // Validate date format
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(date)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid date format. Use YYYY-MM-DD'
      });
    }

    // Check if doctor exists and is active
    const doctor = await prisma.doctor.findUnique({
      where: { id: doctorId }
    });

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    if (!doctor.isActive) {
      return res.status(400).json({
        success: false,
        message: 'Doctor is not active'
      });
    }

    // Get all booked appointments for this doctor on this date
    const bookedAppointments = await prisma.appointment.findMany({
      where: {
        doctorId,
        date: new Date(date),
        status: {
          in: ['SCHEDULED', 'CONFIRMED']
        }
      },
      select: {
        time: true
      }
    });

    // Extract booked time slots
    const bookedSlots = bookedAppointments.map(apt => apt.time);

    // Generate all possible slots
    const allSlots = generateTimeSlots();

    // Filter out booked slots
    const availableSlots = allSlots.filter(slot => !bookedSlots.includes(slot));

    res.status(200).json({
      success: true,
      message: 'Available slots retrieved successfully',
      data: {
        date,
        doctor: {
          id: doctor.id,
          name: doctor.name,
          specialty: doctor.specialty
        },
        availableSlots,
        bookedSlots
      }
    });
  } catch (error) {
    console.error('Error getting available slots:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve available slots',
      error: error.message
    });
  }
};

/**
 * POST /api/appointments
 * Create new appointment
 */
export const createAppointment = async (req, res) => {
  try {
    const { doctorId, date, time, reason } = req.body;
    const userId = req.user.id;

    // Validation
    if (!doctorId || !date || !time) {
      return res.status(400).json({
        success: false,
        message: 'Doctor ID, date, and time are required'
      });
    }

    // Validate date format
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(date)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid date format. Use YYYY-MM-DD'
      });
    }

    // Validate time format (HH:MM)
    const timeRegex = /^\d{2}:\d{2}$/;
    if (!timeRegex.test(time)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid time format. Use HH:MM'
      });
    }

    // Check if doctor exists and is active
    const doctor = await prisma.doctor.findUnique({
      where: { id: doctorId }
    });

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: 'Doctor not found'
      });
    }

    if (!doctor.isActive) {
      return res.status(400).json({
        success: false,
        message: 'Doctor is not active'
      });
    }

    // Check if time slot is available
    const existingAppointment = await prisma.appointment.findFirst({
      where: {
        doctorId,
        date: new Date(date),
        time,
        status: {
          in: ['SCHEDULED', 'CONFIRMED']
        }
      }
    });

    if (existingAppointment) {
      return res.status(400).json({
        success: false,
        message: 'This time slot is already booked'
      });
    }

    // Create appointment
    const appointment = await prisma.appointment.create({
      data: {
        userId,
        doctorId,
        date: new Date(date),
        time,
        reason,
        status: 'SCHEDULED'
      },
      include: {
        doctor: true,
        user: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        }
      }
    });

    res.status(201).json({
      success: true,
      message: 'Appointment created successfully',
      data: { appointment }
    });
  } catch (error) {
    console.error('Error creating appointment:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create appointment',
      error: error.message
    });
  }
};

/**
 * GET /api/appointments
 * Get all appointments for authenticated user
 * Query params: status (optional), upcoming (optional, boolean)
 */
export const getAppointments = async (req, res) => {
  try {
    const { status, upcoming } = req.query;
    const userId = req.user.id;

    // Build where clause
    const where = { userId };

    if (status) {
      where.status = status;
    }

    if (upcoming === 'true') {
      where.date = {
        gte: new Date()
      };
      where.status = {
        in: ['SCHEDULED', 'CONFIRMED']
      };
    }

    // Get appointments
    const appointments = await prisma.appointment.findMany({
      where,
      include: {
        doctor: true
      },
      orderBy: {
        date: 'asc'
      }
    });

    res.status(200).json({
      success: true,
      message: 'Appointments retrieved successfully',
      data: { appointments }
    });
  } catch (error) {
    console.error('Error getting appointments:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve appointments',
      error: error.message
    });
  }
};

/**
 * GET /api/appointments/:id
 * Get appointment by ID
 */
export const getAppointmentById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const appointment = await prisma.appointment.findUnique({
      where: { id },
      include: {
        doctor: true,
        user: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        }
      }
    });

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }

    // Check if user is the owner
    if (appointment.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to view this appointment'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Appointment retrieved successfully',
      data: { appointment }
    });
  } catch (error) {
    console.error('Error getting appointment by ID:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve appointment',
      error: error.message
    });
  }
};

/**
 * PUT /api/appointments/:id/confirm
 * Confirm appointment (change status from SCHEDULED to CONFIRMED)
 */
export const confirmAppointment = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    // Get appointment
    const appointment = await prisma.appointment.findUnique({
      where: { id }
    });

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }

    // Check if user is the owner
    if (appointment.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to confirm this appointment'
      });
    }

    // Check if status is SCHEDULED
    if (appointment.status !== 'SCHEDULED') {
      return res.status(400).json({
        success: false,
        message: 'Only scheduled appointments can be confirmed'
      });
    }

    // Update appointment
    const updatedAppointment = await prisma.appointment.update({
      where: { id },
      data: { status: 'CONFIRMED' },
      include: {
        doctor: true,
        user: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        }
      }
    });

    res.status(200).json({
      success: true,
      message: 'Appointment confirmed successfully',
      data: { appointment: updatedAppointment }
    });
  } catch (error) {
    console.error('Error confirming appointment:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to confirm appointment',
      error: error.message
    });
  }
};

/**
 * PUT /api/appointments/:id/cancel
 * Cancel appointment
 */
export const cancelAppointment = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    // Get appointment
    const appointment = await prisma.appointment.findUnique({
      where: { id }
    });

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }

    // Check if user is the owner
    if (appointment.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to cancel this appointment'
      });
    }

    // Check if status is SCHEDULED or CONFIRMED
    if (!['SCHEDULED', 'CONFIRMED'].includes(appointment.status)) {
      return res.status(400).json({
        success: false,
        message: 'Only scheduled or confirmed appointments can be cancelled'
      });
    }

    // Update appointment
    const updatedAppointment = await prisma.appointment.update({
      where: { id },
      data: { status: 'CANCELLED' },
      include: {
        doctor: true,
        user: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        }
      }
    });

    res.status(200).json({
      success: true,
      message: 'Appointment cancelled successfully',
      data: { appointment: updatedAppointment }
    });
  } catch (error) {
    console.error('Error cancelling appointment:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to cancel appointment',
      error: error.message
    });
  }
};

/**
 * PUT /api/appointments/:id/complete
 * Complete appointment (Admin only)
 */
export const completeAppointment = async (req, res) => {
  try {
    const { id } = req.params;

    // Get appointment
    const appointment = await prisma.appointment.findUnique({
      where: { id }
    });

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }

    // Update appointment
    const updatedAppointment = await prisma.appointment.update({
      where: { id },
      data: { status: 'COMPLETED' },
      include: {
        doctor: true,
        user: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        }
      }
    });

    res.status(200).json({
      success: true,
      message: 'Appointment completed successfully',
      data: { appointment: updatedAppointment }
    });
  } catch (error) {
    console.error('Error completing appointment:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to complete appointment',
      error: error.message
    });
  }
};
