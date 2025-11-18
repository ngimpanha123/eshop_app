class ProfileLog {
  final String action;
  final DateTime timestamp;
  final String? details;

  ProfileLog({
    required this.action,
    required this.timestamp,
    this.details,
  });

  factory ProfileLog.fromJson(Map<String, dynamic> json) {
    return ProfileLog(
      action: json['action'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
    };
  }
}

class ProfileLogsResponse {
  final String status;
  final List<ProfileLog> data;
  final ProfileLogsPagination pagination;

  ProfileLogsResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory ProfileLogsResponse.fromJson(Map<String, dynamic> json) {
    return ProfileLogsResponse(
      status: json['status'] ?? 'success',
      data: (json['data'] as List<dynamic>?)
              ?.map((log) => ProfileLog.fromJson(log))
              .toList() ??
          [],
      pagination: ProfileLogsPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class ProfileLogsPagination {
  final int page;
  final int limit;
  final int totalPage;
  final int total;

  ProfileLogsPagination({
    required this.page,
    required this.limit,
    required this.totalPage,
    required this.total,
  });

  factory ProfileLogsPagination.fromJson(Map<String, dynamic> json) {
    return ProfileLogsPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPage: json['totalPage'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'totalPage': totalPage,
      'total': total,
    };
  }
}

class UserProfile {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String avatar;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final List<UserRole>? roles;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.isActive,
    this.lastLogin,
    required this.createdAt,
    this.roles,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      lastLogin: json['last_login'] != null 
          ? DateTime.parse(json['last_login']) 
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      roles: (json['role'] as List<dynamic>?)
          ?.map((role) => UserRole.fromJson(role))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'is_active': isActive ? 1 : 0,
      'last_login': lastLogin?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'role': roles?.map((role) => role.toJson()).toList(),
    };
  }
}

class UserRole {
  final int id;
  final int roleId;
  final RoleInfo role;

  UserRole({
    required this.id,
    required this.roleId,
    required this.role,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'] ?? 0,
      roleId: json['role_id'] ?? 0,
      role: RoleInfo.fromJson(json['role'] ?? {}),
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

class RoleInfo {
  final int id;
  final String name;

  RoleInfo({
    required this.id,
    required this.name,
  });

  factory RoleInfo.fromJson(Map<String, dynamic> json) {
    return RoleInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
