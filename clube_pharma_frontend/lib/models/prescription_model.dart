/// Prescription Model
///
/// Represents a prescription document in the ClubePharma system.
class PrescriptionModel {
  final String id;
  final String userId;
  final String? familyMemberId;
  final String? doctorName;
  final String fileUrl;
  final String fileName;
  final DateTime prescriptionDate;
  final DateTime? expirationDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrescriptionModel({
    required this.id,
    required this.userId,
    this.familyMemberId,
    this.doctorName,
    required this.fileUrl,
    required this.fileName,
    required this.prescriptionDate,
    this.expirationDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create PrescriptionModel from JSON
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      familyMemberId: json['familyMemberId'] as String?,
      doctorName: json['doctorName'] as String?,
      fileUrl: json['fileUrl'] as String,
      fileName: json['fileName'] as String,
      prescriptionDate: DateTime.parse(json['prescriptionDate'] as String),
      expirationDate: json['expirationDate'] != null ? DateTime.parse(json['expirationDate'] as String) : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert PrescriptionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'familyMemberId': familyMemberId,
      'doctorName': doctorName,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'prescriptionDate': prescriptionDate.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with some fields updated
  PrescriptionModel copyWith({
    String? id,
    String? userId,
    String? familyMemberId,
    String? doctorName,
    String? fileUrl,
    String? fileName,
    DateTime? prescriptionDate,
    DateTime? expirationDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      familyMemberId: familyMemberId ?? this.familyMemberId,
      doctorName: doctorName ?? this.doctorName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      prescriptionDate: prescriptionDate ?? this.prescriptionDate,
      expirationDate: expirationDate ?? this.expirationDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
