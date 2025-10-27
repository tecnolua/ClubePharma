import 'package:flutter/foundation.dart';
import '../models/doctor_model.dart';
import '../services/api_service.dart';
import '../services/doctor_service.dart';

/// Doctor Provider
class DoctorProvider with ChangeNotifier {
  final DoctorService _doctorService;

  List<DoctorModel> _doctors = [];
  List<String> _specialties = [];
  DoctorModel? _selectedDoctor;
  bool _isLoading = false;
  String? _error;

  DoctorProvider({DoctorService? doctorService})
      : _doctorService = doctorService ?? DoctorService(ApiService());

  List<DoctorModel> get doctors => _doctors;
  List<String> get specialties => _specialties;
  DoctorModel? get selectedDoctor => _selectedDoctor;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getDoctors({String? specialty, String? city}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _doctors = await _doctorService.getDoctors(
        specialty: specialty,
        city: city,
      );
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load doctors.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSpecialties() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _specialties = await _doctorService.getSpecialties();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load specialties.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDoctorById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _selectedDoctor = await _doctorService.getDoctorById(id);
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load doctor.';
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
    _doctors = [];
    _specialties = [];
    _selectedDoctor = null;
    _error = null;
    notifyListeners();
  }
}
