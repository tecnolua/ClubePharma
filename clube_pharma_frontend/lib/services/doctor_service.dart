import '../models/doctor_model.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class DoctorService {
  final ApiService _apiService;
  
  DoctorService(this._apiService);
  
  Future<List<DoctorModel>> getDoctors({
    String? specialty,
    String? city,
    bool? telemedicine,
  }) async {
    final response = await _apiService.get(
      ApiConfig.doctors,
      queryParameters: {
        if (specialty != null) 'specialty': specialty,
        if (city != null) 'city': city,
        if (telemedicine != null) 'telemedicine': telemedicine.toString(),
      },
    );
    return (response.data['doctors'] as List)
        .map((e) => DoctorModel.fromJson(e))
        .toList();
  }
  
  Future<List<String>> getSpecialties() async {
    final response = await _apiService.get('${ApiConfig.doctors}/specialties');
    return (response.data['specialties'] as List).map((e) => e as String).toList();
  }
  
  Future<DoctorModel> getDoctorById(String id) async {
    final response = await _apiService.get('${ApiConfig.doctors}/$id');
    return DoctorModel.fromJson(response.data['doctor']);
  }
}
