import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/providers/api_provider.dart';
import '../../../../config/app_config.dart';
import '../../controllers/product_controller.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;

  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _priceController = TextEditingController();
  final _api = Get.find<APIProvider>();
  final _productController = Get.find<ProductController>();

  int? _selectedTypeId;
  File? _selectedImage;
  String? _imageBase64;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _codeController.text = widget.product!.code;
      _priceController.text = widget.product!.unitPrice.toStringAsFixed(0);
      _selectedTypeId = widget.product!.type.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Convert to base64
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      _imageBase64 = 'data:image/png;base64,$base64Image';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTypeId == null) {
      Get.snackbar('Error', 'Please select a product type');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.product == null) {
        // Create new product
        final res = await _api.createProduct(
          name: _nameController.text,
          code: _codeController.text,
          unitPrice: _priceController.text,
          typeId: _selectedTypeId.toString(),
          imageBase64: _imageBase64,
        );

        if (res.statusCode == 200) {
          Get.back();
          await _productController.fetchProducts();
          Get.snackbar(
            'Success',
            res.data['message'] ?? 'Product created successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            res.data['message'] ?? 'Failed to create product',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Update existing product
        final res = await _api.updateProduct(
          productId: widget.product!.id,
          name: _nameController.text,
          code: _codeController.text,
          unitPrice: _priceController.text,
          typeId: _selectedTypeId.toString(),
          imageBase64: _imageBase64,
        );

        if (res.statusCode == 200) {
          Get.back();
          await _productController.fetchProducts();
          Get.snackbar(
            'Success',
            res.data['message'] ?? 'Product updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            res.data['message'] ?? 'Failed to update product',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.product == null ? 'Add Product' : 'Edit Product',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Image picker
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_selectedImage!, fit: BoxFit.cover),
                            )
                          : widget.product?.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    AppConfig.getImageUrl(widget.product!.image!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate,
                                              size: 40, color: Colors.grey.shade600),
                                          const SizedBox(height: 8),
                                          Text('Add Image',
                                              style: TextStyle(color: Colors.grey.shade600)),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate,
                                        size: 40, color: Colors.grey.shade600),
                                    const SizedBox(height: 8),
                                    Text('Add Image',
                                        style: TextStyle(color: Colors.grey.shade600)),
                                  ],
                                ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Product Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Product Code
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Product Code',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Unit Price
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    suffixText: '៛',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter unit price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Product Type Dropdown
                Obx(() {
                  final types = _productController.productTypes;
                  return DropdownButtonFormField<int>(
                    value: _selectedTypeId,
                    decoration: InputDecoration(
                      labelText: 'Product Type',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    items: types.map((type) {
                      return DropdownMenuItem<int>(
                        value: type.id,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a product type';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              widget.product == null ? 'Create' : 'Update',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
