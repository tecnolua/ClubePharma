import '../config/api_endpoints.dart';
import '../models/exam_model.dart';
import 'api_service.dart';

/// Exam Service
///
/// Handles medical exam operations including list, upload, download, and delete.
class ExamService {
  final ApiService _apiService;

  ExamService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all exams
  ///
  /// Parameters:
  /// - [familyMemberId]: Optional - Filter by family member
  /// - [examType]: Optional - Filter by exam type
  ///
  /// Returns list of [ExamModel]
  /// Throws [ApiException] on error
  Future<List<ExamModel>> getExams({
    String? familyMemberId,
    String? examType,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (familyMemberId != null) {
        queryParams['familyMemberId'] = familyMemberId;
      }
      if (examType != null) {
        queryParams['examType'] = examType;
      }

      final response = await _apiService.get(
        ApiEndpoints.examsList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final examsList = data['data'] as List;
        return examsList
            .map((json) => ExamModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get exams');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get exam by ID
  ///
  /// Parameters:
  /// - [id]: Exam ID
  ///
  /// Returns [ExamModel]
  /// Throws [ApiException] on error
  Future<ExamModel> getExamById(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.examsGetById(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ExamModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get exam');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Upload exam
  ///
  /// Parameters:
  /// - [filePath]: Local path to exam file
  /// - [examType]: Type of exam
  /// - [examDate]: Date of exam
  /// - [description]: Optional description
  /// - [doctorName]: Optional doctor name
  /// - [familyMemberId]: Optional family member ID
  ///
  /// Returns created [ExamModel]
  /// Throws [ApiException] on error
  Future<ExamModel> uploadExam({
    required String filePath,
    required String examType,
    required DateTime examDate,
    String? description,
    String? doctorName,
    String? familyMemberId,
  }) async {
    try {
      // TODO: Implement multipart file upload with form data
      throw UnimplementedError('Exam upload not yet implemented');
    } catch (e) {
      rethrow;
    }
  }

  /// Download exam file
  ///
  /// Parameters:
  /// - [id]: Exam ID
  ///
  /// Returns file URL
  /// Throws [ApiException] on error
  Future<String> downloadExam(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.examsDownload(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['url'] as String;
      } else {
        throw Exception('Failed to download exam');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update exam
  ///
  /// Parameters:
  /// - [id]: Exam ID
  /// - [examType]: Optional new exam type
  /// - [examDate]: Optional new exam date
  /// - [description]: Optional new description
  /// - [doctorName]: Optional new doctor name
  ///
  /// Returns updated [ExamModel]
  /// Throws [ApiException] on error
  Future<ExamModel> updateExam({
    required String id,
    String? examType,
    DateTime? examDate,
    String? description,
    String? doctorName,
  }) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.examsUpdate(id),
        data: {
          if (examType != null) 'examType': examType,
          if (examDate != null) 'examDate': examDate.toIso8601String(),
          if (description != null) 'description': description,
          if (doctorName != null) 'doctorName': doctorName,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ExamModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update exam');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete exam
  ///
  /// Parameters:
  /// - [id]: Exam ID
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> deleteExam(String id) async {
    try {
      final response = await _apiService.delete(
        ApiEndpoints.examsDelete(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] as String? ?? 'Exam deleted successfully';
      } else {
        throw Exception('Failed to delete exam');
      }
    } catch (e) {
      rethrow;
    }
  }
}
