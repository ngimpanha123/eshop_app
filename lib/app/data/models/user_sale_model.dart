class UserSaleModel {
  final int id;
  final String receiptNumber;
  final double totalPrice;
  final String platform;
  final String orderedAt;
  final List<SaleDetailModel> details;
  final CashierModel cashier;

  UserSaleModel({
    required this.id,
    required this.receiptNumber,
    required this.totalPrice,
    required this.platform,
    required this.orderedAt,
    required this.details,
    required this.cashier,
  });

  factory UserSaleModel.fromJson(Map<String, dynamic> json) {
    return UserSaleModel(
      id: json['id'],
      receiptNumber: json['receipt_number'],
      totalPrice: (json['total_price'] as num).toDouble(),
      platform: json['platform'],
      orderedAt: json['ordered_at'],
      details: (json['details'] as List)
          .map((detail) => SaleDetailModel.fromJson(detail))
          .toList(),
      cashier: CashierModel.fromJson(json['cashier']),
    );
  }
}

class SaleDetailModel {
  final int id;
  final double unitPrice;
  final int qty;
  final ProductSaleModel product;

  SaleDetailModel({
    required this.id,
    required this.unitPrice,
    required this.qty,
    required this.product,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      id: json['id'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      qty: json['qty'],
      product: ProductSaleModel.fromJson(json['product']),
    );
  }

  double get totalPrice => unitPrice * qty;
}

class ProductSaleModel {
  final int id;
  final String name;
  final String code;
  final String? image;
  final ProductTypeModel type;

  ProductSaleModel({
    required this.id,
    required this.name,
    required this.code,
    this.image,
    required this.type,
  });

  factory ProductSaleModel.fromJson(Map<String, dynamic> json) {
    return ProductSaleModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      image: json['image'],
      type: ProductTypeModel.fromJson(json['type']),
    );
  }
}

class ProductTypeModel {
  final String name;

  ProductTypeModel({required this.name});

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(name: json['name']);
  }
}

class CashierModel {
  final int id;
  final String? avatar;
  final String name;

  CashierModel({
    required this.id,
    this.avatar,
    required this.name,
  });

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(
      id: json['id'],
      avatar: json['avatar'],
      name: json['name'],
    );
  }
}
