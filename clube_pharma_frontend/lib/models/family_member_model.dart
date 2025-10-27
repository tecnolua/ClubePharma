/// Family Member Model
///
/// Represents a family member in the ClubePharma system.
class FamilyMemberModel {
  final String id;
  final String userId;
  final String name;
  final String? cpf;
  final DateTime birthDate;
  final String relationship;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilyMemberModel({
    required this.id,
    required this.userId,
    required this.name,
    this.cpf,
    required this.birthDate,
    required this.relationship,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create FamilyMemberModel from JSON
  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      cpf: json['cpf'] as String?,
      birthDate: DateTime.parse(json['birthDate'] as String),
      relationship: json['relationship'] as String,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert FamilyMemberModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'cpf': cpf,
      'birthDate': birthDate.toIso8601String(),
      'relationship': relationship,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with some fields updated
  FamilyMemberModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? cpf,
    DateTime? birthDate,
    String? relationship,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      birthDate: birthDate ?? this.birthDate,
      relationship: relationship ?? this.relationship,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
