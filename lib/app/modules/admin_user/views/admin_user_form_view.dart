import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/admin_user_controller.dart';

class AdminUserFormView extends GetView<AdminUserController> {
  const AdminUserFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditMode.value ? 'Update Profile' : 'Create User',
        )),
        backgroundColor: const Color(0xFF5C6BC0),
        foregroundColor: Colors.white,
        actions: [
          Obx(() => TextButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    if (controller.isEditMode.value) {
                      controller.updateUser();
                    } else {
                      controller.createUser();
                    }
                  },
            child: Text(
              'Done',
              style: TextStyle(
                color: controller.isLoading.value ? Colors.grey : Colors.white,
                fontSize: 16,
              ),
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Section
              _buildAvatarSection(),
              const SizedBox(height: 32),

              // Name Field
              _buildTextField(
                label: 'Name',
                controller: controller.nameController,
                hint: 'Enter full name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              _buildTextField(
                label: 'Phone Number',
                controller: controller.phoneController,
                hint: 'Enter phone number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email Field
              _buildTextField(
                label: 'Email',
                controller: controller.emailController,
                hint: 'Enter email address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password Fields (only for new users)
              if (!controller.isEditMode.value) ...[
                _buildTextField(
                  label: 'Password',
                  controller: controller.passwordController,
                  hint: 'Enter password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Confirm Password',
                  controller: controller.confirmPasswordController,
                  hint: 'Re-enter password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
              ],

              // Role Selection
              _buildRoleSelection(),
              const SizedBox(height: 16),

              // Active Status Toggle (only in edit mode)
              if (controller.isEditMode.value) ...[
                _buildActiveToggle(),
                const SizedBox(height: 32),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatarSection() {
    return Obx(() {
      final hasImage = controller.selectedImage.value != null;
      
      return Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: hasImage
                  ? FileImage(controller.selectedImage.value!)
                  : null,
              child: !hasImage
                  ? const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () => _showImagePickerOptions(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C6BC0),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF5C6BC0)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                controller.pickImage(source: ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF5C6BC0)),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                controller.pickImage(source: ImageSource.camera);
              },
            ),
            if (controller.selectedImage.value != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                onTap: () {
                  Get.back();
                  controller.selectedImage.value = null;
                  controller.selectedImageBase64.value = null;
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF5C6BC0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5C6BC0), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Select roles'),
                icon: const Icon(Icons.arrow_drop_down),
                items: controller.roles.map((role) {
                  return DropdownMenuItem<int>(
                    value: role.id,
                    child: Row(
                      children: [
                        Checkbox(
                          value: controller.selectedRoles.contains(role.id),
                          onChanged: null,
                        ),
                        Text(role.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    if (controller.selectedRoles.contains(value)) {
                      controller.selectedRoles.remove(value);
                    } else {
                      controller.selectedRoles.add(value);
                    }
                  }
                },
                value: controller.selectedRoles.isNotEmpty
                    ? controller.selectedRoles.first
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (controller.selectedRoles.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.selectedRoles.map((roleId) {
                final role = controller.roles.firstWhere((r) => r.id == roleId);
                return Chip(
                  label: Text(role.name),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    controller.selectedRoles.remove(roleId);
                  },
                  backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.1),
                  labelStyle: const TextStyle(color: Color(0xFF5C6BC0)),
                );
              }).toList(),
            ),
        ],
      );
    });
  }

  Widget _buildActiveToggle() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Active Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: controller.isActive.value,
            onChanged: (value) {
              controller.isActive.value = value;
            },
            activeColor: const Color(0xFF5C6BC0),
          ),
        ],
      );
    });
  }
}
