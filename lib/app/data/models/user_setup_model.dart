import 'role_model.dart';

class UserSetupModel {
  final List<RoleModel> roles;

  UserSetupModel({
    required this.roles,
  });

  factory UserSetupModel.fromJson(Map<String, dynamic> json) {
    return UserSetupModel(
      roles: (json['roles'] as List)
          .map((role) => RoleModel.fromJson(role))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roles': roles.map((role) => role.toJson()).toList(),
    };
  }
}
