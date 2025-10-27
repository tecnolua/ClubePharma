/// User Model
///
/// Represents a user in the ClubePharma system.
/// Matches the backend User schema.
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? cpf;
  final String? phone;
  final String? avatar;
  final String planType; // BASIC or FAMILY
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.cpf,
    this.phone,
    this.avatar,
    required this.planType,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      cpf: json['cpf'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      planType: json['planType'] as String? ?? 'BASIC',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'cpf': cpf,
      'phone': phone,
      'avatar': avatar,
      'planType': planType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of UserModel with some fields updated
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? cpf,
    String? phone,
    String? avatar,
    String? planType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      planType: planType ?? this.planType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, planType: $planType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.cpf == cpf &&
        other.phone == phone &&
        other.avatar == avatar &&
        other.planType == planType &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      name,
      cpf,
      phone,
      avatar,
      planType,
      createdAt,
      updatedAt,
    );
  }
}
