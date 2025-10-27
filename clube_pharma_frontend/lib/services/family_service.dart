import '../models/family_member_model.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class FamilyService {
  final ApiService _apiService;
  
  FamilyService(this._apiService);
  
  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    final response = await _apiService.get(ApiConfig.familyMembers);
    return (response.data['familyMembers'] as List)
        .map((e) => FamilyMemberModel.fromJson(e))
        .toList();
  }
  
  Future<FamilyMemberModel> createFamilyMember(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.familyMembers, data: data);
    return FamilyMemberModel.fromJson(response.data['familyMember']);
  }
  
  Future<FamilyMemberModel> updateFamilyMember(String id, Map<String, dynamic> data) async {
    final response = await _apiService.put('${ApiConfig.familyMembers}/$id', data: data);
    return FamilyMemberModel.fromJson(response.data['familyMember']);
  }
  
  Future<void> deleteFamilyMember(String id) async {
    await _apiService.delete('${ApiConfig.familyMembers}/$id');
  }
}
