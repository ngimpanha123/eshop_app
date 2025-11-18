import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'admin_home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'product_detail_page.dart'; // Import the ProductDetailPage

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _currentIndex = 0;
  int _carouselIndex = 0;
  String _selectedRole = 'Cashier'; // Default to Cashier for CustomerHomePage

  final List<Product> _products = [
    Product(
      name: 'Panadol - 500mg',
      price: 5.0,
      description:
      'Panadol is a brand name for paracetamol, which is used as a pain reliever and fever reducer.',
      imageUrl:
      'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
    ),
    Product(
      name: 'Brufen - 400mg',
      price: 5.0,
      description:
      'Brufen is a brand name for ibuprofen, which is used as a pain reliever and fever reduction.',
      imageUrl:
      'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
    ),
    Product(
      name: 'Flagyl - 400mg',
      price: 4.5,
      description:
      'Flagyl is a brand name for metronidazole, used to treat bacterial infections.',
      imageUrl:
      'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
    ),
    Product(
      name: 'Paracetamol',
      price: 3.0,
      description: 'Paracetamol is used to treat pain and fever.',
      imageUrl:
      'https://phelans.ie/cdn/shop/products/Panadol-Extra-Soluble-455x455_600x.png?v=1737983217',
    ),
  ];

  // ---------------------- Role Switch ----------------------
  void _showRoleSwitchDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 60,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              _buildRoleTile('Admin', FontAwesomeIcons.userTie),
              const SizedBox(height: 8),
              _buildRoleTile('Cashier', FontAwesomeIcons.userGroup),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleTile(String role, IconData icon) {
    bool isSelected = _selectedRole == role;
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade800),
      title: Text(
        role,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.black : Colors.grey.shade700,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
        Navigator.pop(context);

        if (role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()),
          );
        }
      },
    );
  }

  // ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'medi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF003D6B),
                    height: 1.0,
                  ),
                ),
                Text(
                  'stock',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF003D6B),
                    height: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.auto_awesome, color: Color(0xFF003D6B), size: 16),
            const SizedBox(width: 8),
            Text(
              _selectedRole,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF003D6B),
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Color(0xFF003D6B)),
            onPressed: _showRoleSwitchDialog,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Featured Product Carousel
            SizedBox(
              height: 280,
              child: PageView.builder(
                itemCount: _products.length,
                onPageChanged: (index) {
                  setState(() {
                    _carouselIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to ProductDetailPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              name: _products[index].name,
                              price: _products[index].price,
                              description: _products[index].description,
                              imageUrl: _products[index].imageUrl,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0F7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: _products[index].imageUrl,
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      _products[index].imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _products[index].name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF003D6B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Carousel Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _products.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _carouselIndex == index
                        ? const Color(0xFF003D6B)
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(
                            name: _products[index].name,
                            price: _products[index].price,
                            description: _products[index].description,
                            imageUrl: _products[index].imageUrl,
                          ),
                        ),
                      );
                    },
                    child: ProductCard(product: _products[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            }
          },
          selectedItemColor: const Color(0xFF003D6B),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- Product Card ----------------------
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Hero(
                  tag: product.imageUrl,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.medication,
                          size: 80,
                          color: const Color(0xFF003D6B).withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.price.toStringAsFixed(1)} \$',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003D6B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- Product Model ----------------------
class Product {
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}
