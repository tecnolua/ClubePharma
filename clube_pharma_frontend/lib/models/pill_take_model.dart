/// Pill Take Model
///
/// Represents a pill take record for medication adherence tracking.
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
      takenAt: json['takenAt'] != null
          ? DateTime.parse(json['takenAt'] as String)
          : null,
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

  /// Check if pill is pending
  bool get isPending => status == 'PENDING';

  /// Check if pill was taken
  bool get isTaken => status == 'TAKEN';

  /// Check if pill was skipped
  bool get isSkipped => status == 'SKIPPED';

  /// Check if pill is late (past scheduled time and still pending)
  bool get isLate {
    return isPending && DateTime.now().isAfter(scheduledTime);
  }

  @override
  String toString() {
    return 'PillTakeModel(id: $id, treatmentId: $treatmentId, status: $status, scheduledTime: $scheduledTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PillTakeModel &&
        other.id == id &&
        other.treatmentId == treatmentId &&
        other.scheduledTime == scheduledTime &&
        other.takenAt == takenAt &&
        other.status == status &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      treatmentId,
      scheduledTime,
      takenAt,
      status,
      notes,
    );
  }
}

/// Adherence Stats Model
///
/// Represents medication adherence statistics.
class AdherenceStatsModel {
  final int totalScheduled;
  final int totalTaken;
  final int totalSkipped;
  final int totalPending;
  final double adherenceRate;
  final DateTime periodStart;
  final DateTime periodEnd;

  AdherenceStatsModel({
    required this.totalScheduled,
    required this.totalTaken,
    required this.totalSkipped,
    required this.totalPending,
    required this.adherenceRate,
    required this.periodStart,
    required this.periodEnd,
  });

  factory AdherenceStatsModel.fromJson(Map<String, dynamic> json) {
    return AdherenceStatsModel(
      totalScheduled: json['totalScheduled'] as int,
      totalTaken: json['totalTaken'] as int,
      totalSkipped: json['totalSkipped'] as int,
      totalPending: json['totalPending'] as int,
      adherenceRate: (json['adherenceRate'] as num).toDouble(),
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalScheduled': totalScheduled,
      'totalTaken': totalTaken,
      'totalSkipped': totalSkipped,
      'totalPending': totalPending,
      'adherenceRate': adherenceRate,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
    };
  }
}
