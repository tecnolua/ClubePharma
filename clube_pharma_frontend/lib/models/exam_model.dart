/// Exam Model
///
/// Represents an exam document in the ClubePharma system.
class ExamModel {
  final String id;
  final String userId;
  final String? familyMemberId;
  final String examType;
  final String fileUrl;
  final String fileName;
  final DateTime examDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExamModel({
    required this.id,
    required this.userId,
    this.familyMemberId,
    required this.examType,
    required this.fileUrl,
    required this.fileName,
    required this.examDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create ExamModel from JSON
  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      familyMemberId: json['familyMemberId'] as String?,
      examType: json['examType'] as String,
      fileUrl: json['fileUrl'] as String,
      fileName: json['fileName'] as String,
      examDate: DateTime.parse(json['examDate'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert ExamModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'familyMemberId': familyMemberId,
      'examType': examType,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'examDate': examDate.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with some fields updated
  ExamModel copyWith({
    String? id,
    String? userId,
    String? familyMemberId,
    String? examType,
    String? fileUrl,
    String? fileName,
    DateTime? examDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExamModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      familyMemberId: familyMemberId ?? this.familyMemberId,
      examType: examType ?? this.examType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      examDate: examDate ?? this.examDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
