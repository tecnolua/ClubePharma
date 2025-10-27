import '../config/api_endpoints.dart';
import '../models/appointment_model.dart';
import 'api_service.dart';

/// Appointment Service
///
/// Handles medical appointment operations including create, list, confirm, cancel, and reschedule.
class AppointmentService {
  final ApiService _apiService;

  AppointmentService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all appointments
  ///
  /// Parameters:
  /// - [status]: Optional - Filter by status (PENDING, CONFIRMED, CANCELLED, COMPLETED)
  /// - [startDate]: Optional - Filter from date
  /// - [endDate]: Optional - Filter to date
  ///
  /// Returns list of [AppointmentModel]
  /// Throws [ApiException] on error
  Future<List<AppointmentModel>> getAppointments({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get(
        ApiEndpoints.appointmentsList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final appointmentsList = data['data'] as List;
        return appointmentsList
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get appointments');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get upcoming appointments
  ///
  /// Returns list of upcoming [AppointmentModel]
  /// Throws [ApiException] on error
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.appointmentsUpcoming,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final appointmentsList = data['data'] as List;
        return appointmentsList
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get upcoming appointments');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get appointment by ID
  ///
  /// Parameters:
  /// - [id]: Appointment ID
  ///
  /// Returns [AppointmentModel]
  /// Throws [ApiException] on error
  Future<AppointmentModel> getAppointmentById(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.appointmentsGetById(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return AppointmentModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get appointment');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get available slots for a doctor
  ///
  /// Parameters:
  /// - [doctorId]: Doctor ID
  /// - [date]: Optional - Specific date to check (defaults to today)
  ///
  /// Returns list of available time slots
  /// Throws [ApiException] on error
  Future<List<DateTime>> getAvailableSlots({
    required String doctorId,
    DateTime? date,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) queryParams['date'] = date.toIso8601String();

      final response = await _apiService.get(
        ApiEndpoints.appointmentsAvailableSlots(doctorId),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final slotsList = data['data'] as List;
        return slotsList
            .map((slot) => DateTime.parse(slot as String))
            .toList();
      } else {
        throw Exception('Failed to get available slots');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Create appointment
  ///
  /// Parameters:
  /// - [doctorId]: Doctor ID
  /// - [appointmentDate]: Date and time of appointment
  /// - [reason]: Reason for appointment
  /// - [familyMemberId]: Optional - Family member ID if booking for someone else
  ///
  /// Returns created [AppointmentModel]
  /// Throws [ApiException] on error
  Future<AppointmentModel> createAppointment({
    required String doctorId,
    required DateTime appointmentDate,
    required String reason,
    String? familyMemberId,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.appointmentsCreate,
        data: {
          'doctorId': doctorId,
          'appointmentDate': appointmentDate.toIso8601String(),
          'reason': reason,
          if (familyMemberId != null) 'familyMemberId': familyMemberId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return AppointmentModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Confirm appointment
  ///
  /// Parameters:
  /// - [id]: Appointment ID
  ///
  /// Returns updated [AppointmentModel]
  /// Throws [ApiException] on error
  Future<AppointmentModel> confirmAppointment(String id) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.appointmentsConfirm(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return AppointmentModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to confirm appointment');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel appointment
  ///
  /// Parameters:
  /// - [id]: Appointment ID
  /// - [reason]: Optional - Cancellation reason
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> cancelAppointment(String id, {String? reason}) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.appointmentsCancel(id),
        data: {
          if (reason != null) 'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] as String? ?? 'Appointment cancelled successfully';
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Reschedule appointment
  ///
  /// Parameters:
  /// - [id]: Appointment ID
  /// - [newDate]: New appointment date and time
  ///
  /// Returns updated [AppointmentModel]
  /// Throws [ApiException] on error
  Future<AppointmentModel> rescheduleAppointment({
    required String id,
    required DateTime newDate,
  }) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.appointmentsReschedule(id),
        data: {
          'appointmentDate': newDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return AppointmentModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to reschedule appointment');
      }
    } catch (e) {
      rethrow;
    }
  }
}
