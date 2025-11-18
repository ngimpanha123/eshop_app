import 'product_type_model.dart';
import 'user_model.dart';

class ProductModel {
  final int id;
  final String code;
  final String name;
  final String? image;
  final double unitPrice;
  final String createdAt;
  final String totalSale;
  final ProductTypeModel type;
  final UserModel creator;

  ProductModel({
    required this.id,
    required this.code,
    required this.name,
    this.image,
    required this.unitPrice,
    required this.createdAt,
    required this.totalSale,
    required this.type,
    required this.creator,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      createdAt: json['created_at'],
      totalSale: json['total_sale']?.toString() ?? '0',
      type: ProductTypeModel.fromJson(json['type']),
      creator: UserModel.fromJson(json['creator']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'image': image,
      'unit_price': unitPrice,
      'created_at': createdAt,
      'total_sale': totalSale,
      'type': type.toJson(),
      'creator': creator.toJson(),
    };
  }

  // Helper getters for backward compatibility
  String get typeName => type.name;
  String get creatorName => creator.name;
}
