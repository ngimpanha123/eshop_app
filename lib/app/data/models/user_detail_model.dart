import 'role_model.dart';

class UserDetailModel {
  final int id;
  final String name;
  final String? avatar;
  final String phone;
  final String email;
  final int isActive;
  final String? lastLogin;
  final String createdAt;
  final String? totalOrders;
  final double? totalSales;
  final List<UserRoleModel> role;

  UserDetailModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.phone,
    required this.email,
    required this.isActive,
    this.lastLogin,
    required this.createdAt,
    this.totalOrders,
    this.totalSales,
    required this.role,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      phone: json['phone'],
      email: json['email'],
      isActive: json['is_active'],
      lastLogin: json['last_login'],
      createdAt: json['created_at'],
      totalOrders: json['totalOrders']?.toString(),
      totalSales: json['totalSales']?.toDouble(),
      role: (json['role'] as List)
          .map((r) => UserRoleModel.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'is_active': isActive,
      'last_login': lastLogin,
      'created_at': createdAt,
      'totalOrders': totalOrders,
      'totalSales': totalSales,
      'role': role.map((r) => r.toJson()).toList(),
    };
  }

  // Helper getters
  bool get isActiveUser => isActive == 1;
  String get roleNames => role.map((r) => r.role.name).join(', ');
  List<int> get roleIds => role.map((r) => r.roleId).toList();
}

class UserRoleModel {
  final int id;
  final int roleId;
  final RoleModel role;

  UserRoleModel({
    required this.id,
    required this.roleId,
    required this.role,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id'],
      roleId: json['role_id'],
      role: RoleModel.fromJson(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'role': role.toJson(),
    };
  }
}
