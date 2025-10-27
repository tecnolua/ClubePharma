import 'package:flutter/foundation.dart';
import '../models/treatment_model.dart';
import '../services/api_service.dart';
import '../services/treatment_service.dart';

/// Treatment Provider
///
/// Manages treatment state and operations using ChangeNotifier.
class TreatmentProvider with ChangeNotifier {
  final TreatmentService _treatmentService;

  List<TreatmentModel> _treatments = [];
  List<TreatmentModel> _activeTreatments = [];
  TreatmentModel? _selectedTreatment;
  bool _isLoading = false;
  String? _error;

  TreatmentProvider({TreatmentService? treatmentService})
      : _treatmentService = treatmentService ?? TreatmentService(ApiService());

  // Getters
  List<TreatmentModel> get treatments => _treatments;
  List<TreatmentModel> get activeTreatments => _activeTreatments;
  TreatmentModel? get selectedTreatment => _selectedTreatment;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasTreatments => _treatments.isNotEmpty;
  bool get hasActiveTreatments => _activeTreatments.isNotEmpty;

  /// Get all treatments
  Future<void> getTreatments() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _treatments = await _treatmentService.getTreatments();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load treatments. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get active treatments
  Future<void> getActiveTreatments() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _activeTreatments = await _treatmentService.getActiveTreatments();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load active treatments. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get treatment by ID (searches in local list)
  void selectTreatmentById(String id) {
    try {
      _selectedTreatment = _treatments.firstWhere(
        (t) => t.id == id,
        orElse: () => _activeTreatments.firstWhere((t) => t.id == id),
      );
      _error = null;
    } catch (e) {
      _error = 'Treatment not found.';
    }
    notifyListeners();
  }

  /// Create treatment
  Future<bool> createTreatment({
    required String medicationName,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? instructions,
    String? familyMemberId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = {
        'medicationName': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (instructions != null) 'instructions': instructions,
        if (familyMemberId != null) 'familyMemberId': familyMemberId,
      };

      final treatment = await _treatmentService.createTreatment(data);

      _treatments.insert(0, treatment);
      if (treatment.isActive) {
        _activeTreatments.insert(0, treatment);
      }
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to create treatment. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update treatment locally
  void updateTreatmentLocal(TreatmentModel updatedTreatment) {
    final id = updatedTreatment.id;

    // Update in treatments list
    final index = _treatments.indexWhere((t) => t.id == id);
    if (index != -1) {
      _treatments[index] = updatedTreatment;
    }

    // Update in active treatments list
    final activeIndex = _activeTreatments.indexWhere((t) => t.id == id);
    if (updatedTreatment.isActive) {
      if (activeIndex != -1) {
        _activeTreatments[activeIndex] = updatedTreatment;
      } else {
        _activeTreatments.add(updatedTreatment);
      }
    } else {
      if (activeIndex != -1) {
        _activeTreatments.removeAt(activeIndex);
      }
    }

    // Update selected treatment if it's the same
    if (_selectedTreatment?.id == id) {
      _selectedTreatment = updatedTreatment;
    }

    notifyListeners();
  }

  /// Delete treatment
  Future<bool> deleteTreatment(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _treatmentService.deleteTreatment(id);

      _treatments.removeWhere((t) => t.id == id);
      _activeTreatments.removeWhere((t) => t.id == id);

      if (_selectedTreatment?.id == id) {
        _selectedTreatment = null;
      }

      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to delete treatment. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear selected treatment
  void clearSelectedTreatment() {
    _selectedTreatment = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _treatments = [];
    _activeTreatments = [];
    _selectedTreatment = null;
    _error = null;
    notifyListeners();
  }
}
