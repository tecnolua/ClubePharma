/// Doctor Model
///
/// Represents a doctor in the ClubePharma telemedicine system.
class DoctorModel {
  final String id;
  final String name;
  final String crm;
  final String specialty;
  final String? avatar;
  final String? bio;
  final String? city;
  final String? state;
  final bool telemedicineAvailable;
  final double consultationPrice;
  final double? rating;
  final int totalConsultations;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorModel({
    required this.id,
    required this.name,
    required this.crm,
    required this.specialty,
    this.avatar,
    this.bio,
    this.city,
    this.state,
    required this.telemedicineAvailable,
    required this.consultationPrice,
    this.rating,
    required this.totalConsultations,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create DoctorModel from JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      crm: json['crm'] as String,
      specialty: json['specialty'] as String,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      telemedicineAvailable: json['telemedicineAvailable'] as bool? ?? false,
      consultationPrice: (json['consultationPrice'] as num).toDouble(),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      totalConsultations: json['totalConsultations'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert DoctorModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'crm': crm,
      'specialty': specialty,
      'avatar': avatar,
      'bio': bio,
      'city': city,
      'state': state,
      'telemedicineAvailable': telemedicineAvailable,
      'consultationPrice': consultationPrice,
      'rating': rating,
      'totalConsultations': totalConsultations,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
