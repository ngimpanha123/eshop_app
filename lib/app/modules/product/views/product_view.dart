import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../../../config/app_config.dart';
import '../../../data/models/product_model.dart';
import 'widgets/product_form_dialog.dart';
import 'widgets/product_type_form_dialog.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Product',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: controller.tabController,
              labelColor: const Color(0xFF1E40AF),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1E40AF),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Type'),
                Tab(text: 'Expiry Date'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildAllProductsTab(),
          _buildProductTypesTab(),
          _buildExpiryDateTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E40AF),
        onPressed: () {
          if (controller.selectedTabIndex.value == 0) {
            // Add product
            _showProductFormDialog(context);
          } else if (controller.selectedTabIndex.value == 1) {
            // Add product type
            _showProductTypeFormDialog(context);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAllProductsTab() {
    return Column(
      children: [
        // Filter chips
        Obx(() {
          if (controller.productTypes.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.productTypes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Obx(() => FilterChip(
                      label: const Text('All'),
                      selected: controller.selectedTypeId.value == null,
                      onSelected: (selected) {
                        controller.filterByType(null);
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF1E40AF),
                      labelStyle: TextStyle(
                        color: controller.selectedTypeId.value == null
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: controller.selectedTypeId.value == null
                            ? const Color(0xFF1E40AF)
                            : Colors.grey.shade300,
                      ),
                    )),
                  );
                }

                final type = controller.productTypes[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Obx(() => FilterChip(
                    label: Text(type.name),
                    selected: controller.selectedTypeId.value == type.id,
                    onSelected: (selected) {
                      controller.filterByType(selected ? type.id : null);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF1E40AF),
                    labelStyle: TextStyle(
                      color: controller.selectedTypeId.value == type.id
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: controller.selectedTypeId.value == type.id
                          ? const Color(0xFF1E40AF)
                          : Colors.grey.shade300,
                    ),
                  )),
                );
              },
            ),
          );
        }),

        // Product list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (controller.filteredProducts.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            return RefreshIndicator(
              onRefresh: controller.refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return _buildProductCard(product);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProductTypesTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.productTypes.isEmpty) {
        return const Center(child: Text("No product types found"));
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.productTypes.length,
          itemBuilder: (context, index) {
            final type = controller.productTypes[index];
            return _buildProductTypeCard(type);
          },
        ),
      );
    });
  }

  Widget _buildExpiryDateTab() {
    return const Center(
      child: Text('Expiry Date feature coming soon'),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showProductFormDialog(Get.context!, product: product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    AppConfig.getImageUrl(product.image ?? ''),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        color: Colors.grey.shade400,
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.type.name} | ${product.code}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.unitPrice.toStringAsFixed(0)} ៛',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // More options button
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showProductFormDialog(Get.context!, product: product);
                  } else if (value == 'delete') {
                    _showDeleteProductDialog(product);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductTypeCard(type) {
    final productCount = int.tryParse(type.nOfProducts ?? '0') ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showProductTypeFormDialog(Get.context!, productType: type),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: type.image != null && type.image!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          AppConfig.getImageUrl(type.image!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.category,
                              color: Color(0xFF1E40AF),
                              size: 24,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.category,
                        color: Color(0xFF1E40AF),
                        size: 24,
                      ),
              ),
              const SizedBox(width: 16),

              // Type name
              Expanded(
                child: Text(
                  type.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Product count
              Text(
                productCount.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),

              // More options button
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showProductTypeFormDialog(Get.context!, productType: type);
                  } else if (value == 'delete') {
                    _showDeleteProductTypeDialog(type);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductFormDialog(BuildContext context, {ProductModel? product}) {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );
  }

  void _showProductTypeFormDialog(BuildContext context, {dynamic productType}) {
    showDialog(
      context: context,
      builder: (context) => ProductTypeFormDialog(productType: productType),
    );
  }

  void _showDeleteProductDialog(ProductModel product) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteProduct(product.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteProductTypeDialog(dynamic productType) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product Type'),
        content: Text('Are you sure you want to delete "${productType.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteProductType(productType.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
