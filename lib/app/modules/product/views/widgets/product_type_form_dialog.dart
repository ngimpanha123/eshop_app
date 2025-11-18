import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/product_type_model.dart';
import '../../../../data/providers/api_provider.dart';
import '../../../../config/app_config.dart';
import '../../controllers/product_controller.dart';

class ProductTypeFormDialog extends StatefulWidget {
  final ProductTypeModel? productType;

  const ProductTypeFormDialog({super.key, this.productType});

  @override
  State<ProductTypeFormDialog> createState() => _ProductTypeFormDialogState();
}

class _ProductTypeFormDialogState extends State<ProductTypeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _api = Get.find<APIProvider>();
  final _productController = Get.find<ProductController>();

  File? _selectedImage;
  String? _imageBase64;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productType != null) {
      _nameController.text = widget.productType!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
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

    setState(() => _isLoading = true);

    try {
      if (widget.productType == null) {
        // Create new product type
        final res = await _api.createProductType(
          name: _nameController.text,
          imageBase64: _imageBase64,
        );

        if (res.statusCode == 200) {
          Get.back();
          await _productController.refreshData();
          Get.snackbar(
            'Success',
            res.data['message'] ?? 'Product type created successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            res.data['message'] ?? 'Failed to create product type',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Update existing product type
        final res = await _api.updateProductType(
          typeId: widget.productType!.id,
          name: _nameController.text,
          imageBase64: _imageBase64,
        );

        if (res.statusCode == 200) {
          Get.back();
          await _productController.refreshData();
          Get.snackbar(
            'Success',
            res.data['message'] ?? 'Product type updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            res.data['message'] ?? 'Failed to update product type',
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
                  widget.productType == null ? 'Add Product Type' : 'Edit Product Type',
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
                      width: 100,
                      height: 100,
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
                          : widget.productType?.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    AppConfig.getImageUrl(widget.productType!.image!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate,
                                              size: 32, color: Colors.grey.shade600),
                                          const SizedBox(height: 4),
                                          Text('Add Icon',
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.grey.shade600)),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate,
                                        size: 32, color: Colors.grey.shade600),
                                    const SizedBox(height: 4),
                                    Text('Add Icon',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey.shade600)),
                                  ],
                                ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Type Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Type Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter type name';
                    }
                    return null;
                  },
                ),
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
                              widget.productType == null ? 'Create' : 'Update',
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
