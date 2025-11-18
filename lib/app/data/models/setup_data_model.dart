import 'product_type_model.dart';
import 'user_model.dart';

class SetupDataModel {
  final List<ProductTypeModel> productTypes;
  final List<UserModel> users;

  SetupDataModel({
    required this.productTypes,
    required this.users,
  });

  factory SetupDataModel.fromJson(Map<String, dynamic> json) {
    return SetupDataModel(
      productTypes: (json['productTypes'] as List)
          .map((type) => ProductTypeModel.fromJson(type))
          .toList(),
      users: (json['users'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productTypes': productTypes.map((type) => type.toJson()).toList(),
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
