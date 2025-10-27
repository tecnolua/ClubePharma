import '../models/treatment_model.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class TreatmentService {
  final ApiService _apiService;
  
  TreatmentService(this._apiService);
  
  Future<List<TreatmentModel>> getTreatments() async {
    final response = await _apiService.get(ApiConfig.treatments);
    return (response.data['treatments'] as List)
        .map((e) => TreatmentModel.fromJson(e))
        .toList();
  }
  
  Future<List<TreatmentModel>> getActiveTreatments() async {
    final response = await _apiService.get('${ApiConfig.treatments}/active');
    return (response.data['treatments'] as List)
        .map((e) => TreatmentModel.fromJson(e))
        .toList();
  }
  
  Future<TreatmentModel> createTreatment(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.treatments, data: data);
    return TreatmentModel.fromJson(response.data['treatment']);
  }
  
  Future<void> deleteTreatment(String id) async {
    await _apiService.delete('${ApiConfig.treatments}/$id');
  }
}
