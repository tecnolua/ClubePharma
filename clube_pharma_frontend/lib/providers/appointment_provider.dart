import 'package:flutter/foundation.dart';
import '../models/appointment_model.dart';
import '../services/api_service.dart';
import '../services/appointment_service.dart';

/// Appointment Provider
class AppointmentProvider with ChangeNotifier {
  final AppointmentService _appointmentService;

  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> _upcomingAppointments = [];
  AppointmentModel? _selectedAppointment;
  bool _isLoading = false;
  String? _error;

  AppointmentProvider({AppointmentService? appointmentService})
      : _appointmentService =
            appointmentService ?? AppointmentService();

  List<AppointmentModel> get appointments => _appointments;
  List<AppointmentModel> get upcomingAppointments => _upcomingAppointments;
  AppointmentModel? get selectedAppointment => _selectedAppointment;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getAppointments({String? status}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _appointments = await _appointmentService.getAppointments(status: status);
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load appointments.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUpcomingAppointments() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _upcomingAppointments =
          await _appointmentService.getUpcomingAppointments();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load upcoming appointments.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAppointment({
    required String doctorId,
    required DateTime appointmentDate,
    required String reason,
    String? familyMemberId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final appointment = await _appointmentService.createAppointment(
        doctorId: doctorId,
        appointmentDate: appointmentDate,
        reason: reason,
        familyMemberId: familyMemberId,
      );

      _appointments.insert(0, appointment);
      _upcomingAppointments.insert(0, appointment);
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to create appointment.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelAppointment(String id, {String? reason}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _appointmentService.cancelAppointment(id, reason: reason);

      // Update locally
      _appointments.removeWhere((a) => a.id == id);
      _upcomingAppointments.removeWhere((a) => a.id == id);

      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to cancel appointment.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _appointments = [];
    _upcomingAppointments = [];
    _selectedAppointment = null;
    _error = null;
    notifyListeners();
  }
}
