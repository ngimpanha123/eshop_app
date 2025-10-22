class ProductModel {
  final int id;
  final String code;
  final String name;
  final String image;
  final double unitPrice;
  final String createdAt;
  final String totalSale;
  final String typeName;
  final String creatorName;

  ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.unitPrice,
    required this.createdAt,
    required this.totalSale,
    required this.typeName,
    required this.creatorName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      createdAt: json['created_at'],
      totalSale: json['total_sale'],
      typeName: json['type']['name'],
      creatorName: json['creator']['name'],
    );
  }
}
