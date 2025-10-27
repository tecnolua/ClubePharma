import '../config/api_endpoints.dart';
import '../models/prescription_model.dart';
import 'api_service.dart';

/// Prescription Service
///
/// Handles prescription operations including list, upload, download, and delete.
class PrescriptionService {
  final ApiService _apiService;

  PrescriptionService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all prescriptions
  ///
  /// Parameters:
  /// - [familyMemberId]: Optional - Filter by family member
  ///
  /// Returns list of [PrescriptionModel]
  /// Throws [ApiException] on error
  Future<List<PrescriptionModel>> getPrescriptions({
    String? familyMemberId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (familyMemberId != null) {
        queryParams['familyMemberId'] = familyMemberId;
      }

      final response = await _apiService.get(
        ApiEndpoints.prescriptionsList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final prescriptionsList = data['data'] as List;
        return prescriptionsList
            .map((json) => PrescriptionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get prescriptions');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get prescription by ID
  ///
  /// Parameters:
  /// - [id]: Prescription ID
  ///
  /// Returns [PrescriptionModel]
  /// Throws [ApiException] on error
  Future<PrescriptionModel> getPrescriptionById(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.prescriptionsGetById(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PrescriptionModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get prescription');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Upload prescription
  ///
  /// Parameters:
  /// - [filePath]: Local path to prescription file
  /// - [description]: Optional description
  /// - [doctorName]: Optional doctor name
  /// - [issueDate]: Optional issue date
  /// - [familyMemberId]: Optional family member ID
  ///
  /// Returns created [PrescriptionModel]
  /// Throws [ApiException] on error
  Future<PrescriptionModel> uploadPrescription({
    required String filePath,
    String? description,
    String? doctorName,
    DateTime? issueDate,
    String? familyMemberId,
  }) async {
    try {
      // TODO: Implement multipart file upload
      throw UnimplementedError('Prescription upload not yet implemented');
    } catch (e) {
      rethrow;
    }
  }

  /// Download prescription file
  ///
  /// Parameters:
  /// - [id]: Prescription ID
  ///
  /// Returns file URL or bytes
  /// Throws [ApiException] on error
  Future<String> downloadPrescription(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.prescriptionsDownload(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['url'] as String;
      } else {
        throw Exception('Failed to download prescription');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update prescription
  ///
  /// Parameters:
  /// - [id]: Prescription ID
  /// - [description]: Optional new description
  /// - [doctorName]: Optional new doctor name
  ///
  /// Returns updated [PrescriptionModel]
  /// Throws [ApiException] on error
  Future<PrescriptionModel> updatePrescription({
    required String id,
    String? description,
    String? doctorName,
  }) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.prescriptionsUpdate(id),
        data: {
          if (description != null) 'description': description,
          if (doctorName != null) 'doctorName': doctorName,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PrescriptionModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update prescription');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete prescription
  ///
  /// Parameters:
  /// - [id]: Prescription ID
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> deletePrescription(String id) async {
    try {
      final response = await _apiService.delete(
        ApiEndpoints.prescriptionsDelete(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] as String? ?? 'Prescription deleted successfully';
      } else {
        throw Exception('Failed to delete prescription');
      }
    } catch (e) {
      rethrow;
    }
  }
}
