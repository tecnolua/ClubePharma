import '../models/treatment_model.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class PillTakeService {
  final ApiService _apiService;
  
  PillTakeService(this._apiService);
  
  Future<List<PillTakeModel>> getTodayPillTakes() async {
    final response = await _apiService.get('${ApiConfig.pillTakes}/today');
    return (response.data['pillTakes'] as List)
        .map((e) => PillTakeModel.fromJson(e))
        .toList();
  }
  
  Future<List<PillTakeModel>> getUpcomingPills() async {
    final response = await _apiService.get('${ApiConfig.pillTakes}/upcoming');
    return (response.data['pillTakes'] as List)
        .map((e) => PillTakeModel.fromJson(e))
        .toList();
  }
  
  Future<Map<String, dynamic>> getAdherenceDashboard() async {
    final response = await _apiService.get('${ApiConfig.pillTakes}/adherence');
    return response.data;
  }
  
  Future<PillTakeModel> createPillTake(String treatmentId, Map<String, dynamic> data) async {
    final response = await _apiService.post(
      '${ApiConfig.pillTakes}/treatment/$treatmentId',
      data: data,
    );
    return PillTakeModel.fromJson(response.data['pillTake']);
  }
  
  Future<PillTakeModel> markAsTaken(String id) async {
    final response = await _apiService.patch('${ApiConfig.pillTakes}/$id/taken');
    return PillTakeModel.fromJson(response.data['pillTake']);
  }
  
  Future<PillTakeModel> markAsSkipped(String id) async {
    final response = await _apiService.patch('${ApiConfig.pillTakes}/$id/skipped');
    return PillTakeModel.fromJson(response.data['pillTake']);
  }
}
