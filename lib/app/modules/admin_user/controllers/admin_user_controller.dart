import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/user_detail_model.dart';
import '../../../data/models/role_model.dart';
import '../../../data/models/user_setup_model.dart';
import '../../../data/models/user_sale_model.dart';
import '../../../data/providers/api_provider.dart';

class AdminUserController extends GetxController {
  final _api = Get.find<APIProvider>();

  // Observable lists
  var users = <UserDetailModel>[].obs;
  var roles = <RoleModel>[].obs;
  var filteredUsers = <UserDetailModel>[].obs;

  // Loading & Error states
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalItems = 0.obs;

  // Search & Filter
  var searchQuery = ''.obs;
  var selectedRoleFilter = Rx<int?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form state
  var selectedRoles = <int>[].obs;
  var selectedImage = Rx<File?>(null);
  var selectedImageBase64 = Rx<String?>(null);
  var isActive = true.obs;

  // Edit mode
  var isEditMode = false.obs;
  var editingUserId = Rx<int?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchSetupData();
    fetchUsers();
    
    // Listen to search query changes
    debounce(searchQuery, (_) => filterUsers(), time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Fetch setup data (roles)
  Future<void> fetchSetupData() async {
    try {
      final res = await _api.getUserSetupData();

      if (res.statusCode == 200 && res.data != null) {
        final setupData = UserSetupModel.fromJson(res.data);
        roles.value = setupData.roles;
      }
    } catch (e) {
      print('❌ Setup Data Error: $e');
      errorMessage.value = 'Failed to load setup data: ${e.toString()}';
    }
  }

  /// Fetch users with optional pagination
  Future<void> fetchUsers({int page = 1, bool enablePagination = false}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final res = await _api.getUsers(
        page: enablePagination ? page : null,
        limit: enablePagination ? 10 : 1000,
      );

      if (res.statusCode == 200 && res.data['status'] == 'success') {
        final data = res.data['data'] as List;
        
        users.value = data
            .map((json) => UserDetailModel.fromJson(json))
            .toList();

        // Handle pagination if available
        if (res.data['pagination'] != null) {
          currentPage.value = res.data['pagination']['page'];
          totalPages.value = res.data['pagination']['totalPage'];
          totalItems.value = res.data['pagination']['total'];
        }

        // Apply filters
        filterUsers();
      } else {
        errorMessage.value = "Failed to load users (${res.statusCode})";
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('❌ Fetch Users Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter users based on search query and role
  void filterUsers() {
    if (searchQuery.value.isEmpty && selectedRoleFilter.value == null) {
      filteredUsers.value = users;
      return;
    }

    filteredUsers.value = users.where((user) {
      // Search filter
      final matchesSearch = searchQuery.value.isEmpty ||
          user.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          user.email.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          user.phone.contains(searchQuery.value);

      // Role filter
      final matchesRole = selectedRoleFilter.value == null ||
          user.roleIds.contains(selectedRoleFilter.value);

      return matchesSearch && matchesRole;
    }).toList();
  }

  /// Pick image from gallery or camera
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        
        // Convert to base64
        final bytes = await selectedImage.value!.readAsBytes();
        final base64Image = base64Encode(bytes);
        selectedImageBase64.value = 'data:image/png;base64,$base64Image';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  /// Clear form
  void clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRoles.clear();
    selectedImage.value = null;
    selectedImageBase64.value = null;
    isActive.value = true;
    isEditMode.value = false;
    editingUserId.value = null;
  }

  /// Prepare form for editing
  Future<void> prepareEditForm(UserDetailModel user) async {
    isEditMode.value = true;
    editingUserId.value = user.id;
    
    nameController.text = user.name;
    phoneController.text = user.phone;
    emailController.text = user.email;
    selectedRoles.value = user.roleIds;
    isActive.value = user.isActiveUser;
    
    // Don't set password in edit mode
    passwordController.clear();
    confirmPasswordController.clear();
  }

  /// Validate form
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter user name');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter phone number');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter email address');
      return false;
    }

    if (!isEditMode.value && passwordController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter password');
      return false;
    }

    if (!isEditMode.value && passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }

    if (selectedRoles.isEmpty) {
      Get.snackbar('Error', 'Please select at least one role');
      return false;
    }

    return true;
  }

  /// Create new user
  Future<void> createUser() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final data = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'role_ids': selectedRoles,
      };

      if (selectedImageBase64.value != null) {
        data['avatar'] = selectedImageBase64.value!;
      }

      final res = await _api.createUser(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar('Success', 'User created successfully');
        clearForm();
        Get.back();
        fetchUsers();
      } else {
        Get.snackbar('Error', 'Failed to create user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error creating user: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user
  Future<void> updateUser() async {
    if (!validateForm() || editingUserId.value == null) return;

    try {
      isLoading.value = true;

      final data = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'role_ids': selectedRoles,
      };

      if (selectedImageBase64.value != null) {
        data['avatar'] = selectedImageBase64.value!;
      }

      final res = await _api.updateUser(
        userId: editingUserId.value!,
        data: data,
      );

      if (res.statusCode == 200) {
        Get.snackbar('Success', res.data['message'] ?? 'User updated successfully');
        clearForm();
        Get.back();
        fetchUsers();
      } else {
        Get.snackbar('Error', 'Failed to update user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error updating user: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user status
  Future<void> updateUserStatus(int userId, bool isActive) async {
    try {
      final res = await _api.updateUserStatus(
        userId: userId,
        isActive: isActive,
      );

      if (res.statusCode == 200) {
        Get.snackbar('Success', 'User status updated successfully');
        fetchUsers();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user status');
    }
  }

  /// Update user password
  Future<void> updateUserPassword(int userId, String newPassword) async {
    try {
      isLoading.value = true;

      final res = await _api.updateUserPassword(
        userId: userId,
        password: newPassword,
      );

      if (res.statusCode == 200) {
        Get.snackbar('Success', res.data['message'] ?? 'Password updated successfully');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete user
  Future<void> deleteUser(int userId) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        isLoading.value = true;

        final res = await _api.deleteUser(userId: userId);

        if (res.statusCode == 200) {
          Get.snackbar('Success', res.data['message'] ?? 'User deleted successfully');
          fetchUsers();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user');
    } finally {
      isLoading.value = false;
    }
  }

  /// Show user details with sales history
  Future<void> showUserDetails(int userId) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final res = await _api.getUserById(userId: userId);

      // Close loading dialog
      Get.back();

      if (res.statusCode == 200 && res.data['data'] != null) {
        final userData = UserDetailModel.fromJson(res.data['data']);
        final salesData = res.data['sale'] != null
            ? (res.data['sale'] as List)
                .map((sale) => UserSaleModel.fromJson(sale))
                .toList()
            : <UserSaleModel>[];

        // Show details dialog
        _showUserDetailsDialog(userData, salesData);
      }
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar('Error', 'Failed to load user details');
    }
  }

  void _showUserDetailsDialog(UserDetailModel user, List<UserSaleModel> sales) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF5C6BC0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    if (user.avatar != null)
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'http://10.0.2.2:9056/${user.avatar}',
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5C6BC0),
                          ),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.roleNames,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Section
                      _buildSectionTitle('User Information'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Phone', user.phone),
                      _buildDetailRow('Email', user.email),
                      _buildDetailRow(
                        'Status',
                        user.isActiveUser ? 'Active' : 'Inactive',
                      ),
                      _buildDetailRow('Total Orders', user.totalOrders ?? '0'),
                      _buildDetailRow(
                        'Total Sales',
                        '\$${user.totalSales?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                      if (user.lastLogin != null)
                        _buildDetailRow('Last Login', _formatDate(user.lastLogin!)),

                      const SizedBox(height: 24),

                      // Sales History Section
                      if (sales.isNotEmpty) ...[
                        _buildSectionTitle('Recent Sales (${sales.length})'),
                        const SizedBox(height: 12),
                        ...sales.take(5).map((sale) => _buildSaleCard(sale)).toList(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF5C6BC0),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleCard(UserSaleModel sale) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Receipt #${sale.receiptNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${sale.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF5C6BC0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(sale.orderedAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.devices, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  sale.platform,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${sale.details.length} items',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
