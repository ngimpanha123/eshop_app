class OrderProductType {
  final int id;
  final String name;
  final List<OrderProduct> products;

  OrderProductType({
    required this.id,
    required this.name,
    required this.products,
  });

  factory OrderProductType.fromJson(Map<String, dynamic> json) {
    return OrderProductType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((product) => OrderProduct.fromJson(product))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

class OrderProduct {
  final int id;
  final int typeId;
  final String name;
  final String image;
  final double unitPrice;
  final String code;
  final OrderProductTypeInfo type;

  OrderProduct({
    required this.id,
    required this.typeId,
    required this.name,
    required this.image,
    required this.unitPrice,
    required this.code,
    required this.type,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'] ?? 0,
      typeId: json['type_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      code: json['code'] ?? '',
      type: OrderProductTypeInfo.fromJson(json['type'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'name': name,
      'image': image,
      'unit_price': unitPrice,
      'code': code,
      'type': type.toJson(),
    };
  }
}

class OrderProductTypeInfo {
  final String name;

  OrderProductTypeInfo({required this.name});

  factory OrderProductTypeInfo.fromJson(Map<String, dynamic> json) {
    return OrderProductTypeInfo(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class OrderProductsResponse {
  final List<OrderProductType> data;

  OrderProductsResponse({required this.data});

  factory OrderProductsResponse.fromJson(Map<String, dynamic> json) {
    return OrderProductsResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((type) => OrderProductType.fromJson(type))
              .toList() ??
          [],
    );
  }
}

// Cart Item for local state management
class CartItem {
  final OrderProduct product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.unitPrice * quantity;

  void increment() {
    quantity++;
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'quantity': quantity,
      'unit_price': product.unitPrice,
    };
  }
}
