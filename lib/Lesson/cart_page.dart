import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'PANADOL EXTRA',
      dosage: '250mg',
      price: 5.0,
      quantity: 3,
      imageUrl: 'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
      isSelected: true,
    ),
    CartItem(
      id: '2',
      name: 'BRUFEN',
      dosage: '500mg',
      price: 1.0,
      quantity: 5,
      imageUrl: 'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
      isSelected: true,
    ),
    CartItem(
      id: '3',
      name: 'PANADOL EXTRA',
      dosage: '250mg',
      price: 5.0,
      quantity: 3,
      imageUrl: 'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
      isSelected: false,
    ),
    CartItem(
      id: '4',
      name: 'BRUFEN',
      dosage: '500mg',
      price: 5.0,
      quantity: 5,
      imageUrl: 'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
      isSelected: true,
    ),
    CartItem(
      id: '5',
      name: 'PANADOL EXTRA',
      dosage: '250mg',
      price: 5.0,
      quantity: 3,
      imageUrl: 'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
      isSelected: false,
    ),
  ];

  bool get _isAllSelected => _cartItems.every((item) => item.isSelected);

  double get _totalPrice {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      for (var item in _cartItems) {
        item.isSelected = value ?? false;
      }
    });
  }

  void _toggleItemSelection(String id) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item.id == id);
      item.isSelected = !item.isSelected;
    });
  }

  void _updateQuantity(String id, int delta) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item.id == id);
      final newQuantity = item.quantity + delta;
      if (newQuantity > 0) {
        item.quantity = newQuantity;
      }
    });
  }

  void _confirmOrder() {
    final selectedItems = _cartItems.where((item) => item.isSelected).toList();
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Handle order confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Confirmed'),
        content: Text('Your order of ${selectedItems.length} items has been confirmed!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Confirm',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: _cartItems.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return CartItemWidget(
                  item: item,
                  onToggleSelection: () => _toggleItemSelection(item.id),
                  onIncrement: () => _updateQuantity(item.id, 1),
                  onDecrement: () => _updateQuantity(item.id, -1),
                );
              },
            ),
          ),

          // Bottom Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Select All & Total
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _toggleSelectAll(!_isAllSelected),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isAllSelected
                                      ? Color(0xFF003D6B)
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: _isAllSelected
                                    ? Color(0xFF003D6B)
                                    : Colors.transparent,
                              ),
                              child: _isAllSelected
                                  ? Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Select all',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Total ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${_totalPrice.toStringAsFixed(0)} \$',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _confirmOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF003D6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation Bar Space
                SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onToggleSelection;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onToggleSelection,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Selection Checkbox
          InkWell(
            onTap: onToggleSelection,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.isSelected
                      ? Color(0xFF003D6B)
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: item.isSelected
                    ? Color(0xFF003D6B)
                    : Colors.transparent,
              ),
              child: item.isSelected
                  ? Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
                  : null,
            ),
          ),
          SizedBox(width: 12),

          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.medication,
                    size: 30,
                    color: Color(0xFF003D6B).withOpacity(0.3),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  item.dosage,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${item.price.toStringAsFixed(0)} \$',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003D6B),
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Row(
            children: [
              InkWell(
                onTap: onDecrement,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                '${item.quantity}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 12),
              InkWell(
                onTap: onIncrement,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Color(0xFF003D6B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xFF003D6B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final String dosage;
  final double price;
  int quantity;
  final String imageUrl;
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.isSelected = false,
  });
}
