/// Treatment Model
///
/// Represents a treatment/medication in the ClubePharma system.
class TreatmentModel {
  final String id;
  final String userId;
  final String? familyMemberId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String? instructions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TreatmentModel({
    required this.id,
    required this.userId,
    this.familyMemberId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.instructions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create TreatmentModel from JSON
  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      familyMemberId: json['familyMemberId'] as String?,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      instructions: json['instructions'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert TreatmentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'familyMemberId': familyMemberId,
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'instructions': instructions,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with some fields updated
  TreatmentModel copyWith({
    String? id,
    String? userId,
    String? familyMemberId,
    String? medicationName,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? instructions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TreatmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      familyMemberId: familyMemberId ?? this.familyMemberId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      instructions: instructions ?? this.instructions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Pill Take Model
///
/// Represents a pill take record for adherence tracking.
class PillTakeModel {
  final String id;
  final String treatmentId;
  final DateTime scheduledTime;
  final DateTime? takenAt;
  final String status; // TAKEN, SKIPPED, PENDING
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PillTakeModel({
    required this.id,
    required this.treatmentId,
    required this.scheduledTime,
    this.takenAt,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create PillTakeModel from JSON
  factory PillTakeModel.fromJson(Map<String, dynamic> json) {
    return PillTakeModel(
      id: json['id'] as String,
      treatmentId: json['treatmentId'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      takenAt: json['takenAt'] != null ? DateTime.parse(json['takenAt'] as String) : null,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert PillTakeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatmentId': treatmentId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenAt': takenAt?.toIso8601String(),
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with some fields updated
  PillTakeModel copyWith({
    String? id,
    String? treatmentId,
    DateTime? scheduledTime,
    DateTime? takenAt,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PillTakeModel(
      id: id ?? this.id,
      treatmentId: treatmentId ?? this.treatmentId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      takenAt: takenAt ?? this.takenAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
