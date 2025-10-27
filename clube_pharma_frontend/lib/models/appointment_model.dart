/// Appointment Model
///
/// Represents an appointment in the ClubePharma system.
class AppointmentModel {
  final String id;
  final String userId;
  final String doctorId;
  final String? familyMemberId;
  final DateTime scheduledDate;
  final String type; // IN_PERSON or TELEMEDICINE
  final String status; // PENDING, CONFIRMED, CANCELLED, COMPLETED
  final String? notes;
  final String? meetingLink;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DoctorAppointmentInfo? doctor;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    this.familyMemberId,
    required this.scheduledDate,
    required this.type,
    required this.status,
    this.notes,
    this.meetingLink,
    required this.createdAt,
    required this.updatedAt,
    this.doctor,
  });

  /// Create AppointmentModel from JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      doctorId: json['doctorId'] as String,
      familyMemberId: json['familyMemberId'] as String?,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      type: json['type'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      meetingLink: json['meetingLink'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      doctor: json['doctor'] != null ? DoctorAppointmentInfo.fromJson(json['doctor'] as Map<String, dynamic>) : null,
    );
  }

  /// Convert AppointmentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'familyMemberId': familyMemberId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'type': type,
      'status': status,
      'notes': notes,
      'meetingLink': meetingLink,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'doctor': doctor?.toJson(),
    };
  }

  /// Check if appointment can be cancelled
  bool get canBeCancelled => status == 'PENDING' || status == 'CONFIRMED';
}

/// Doctor Appointment Info
///
/// Simplified doctor info for appointments.
class DoctorAppointmentInfo {
  final String id;
  final String name;
  final String crm;
  final String specialty;
  final String? avatar;

  DoctorAppointmentInfo({
    required this.id,
    required this.name,
    required this.crm,
    required this.specialty,
    this.avatar,
  });

  factory DoctorAppointmentInfo.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      crm: json['crm'] as String,
      specialty: json['specialty'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'crm': crm,
      'specialty': specialty,
      'avatar': avatar,
    };
  }
}

/// Available Slots Model
///
/// Represents available time slots for appointments.
class AvailableSlotsModel {
  final String doctorId;
  final DateTime date;
  final List<String> slots;

  AvailableSlotsModel({
    required this.doctorId,
    required this.date,
    required this.slots,
  });

  /// Create AvailableSlotsModel from JSON
  factory AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotsModel(
      doctorId: json['doctorId'] as String,
      date: DateTime.parse(json['date'] as String),
      slots: (json['slots'] as List).map((e) => e as String).toList(),
    );
  }

  /// Convert AvailableSlotsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'date': date.toIso8601String(),
      'slots': slots,
    };
  }
}
