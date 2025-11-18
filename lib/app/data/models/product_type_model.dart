class ProductTypeModel {
  final int id;
  final String name;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final String? nOfProducts;

  ProductTypeModel({
    required this.id,
    required this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.nOfProducts,
  });

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      nOfProducts: json['n_of_products']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'n_of_products': nOfProducts,
    };
  }
}
