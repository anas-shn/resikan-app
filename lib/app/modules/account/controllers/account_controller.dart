import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../routes/app_pages.dart';

class AccountController extends GetxController {
  final _supabase = SupabaseProvider.to;

  // Observable state
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;

  // Form fields
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onClose() {
    // Note: Don't dispose TextEditingControllers here
    // GetX manages the controller lifecycle
    super.onClose();
  }

  /// Load user profile from database
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      final userId = _supabase.currentUser?.id;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User not authenticated',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await _supabase.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        user.value = UserModel.fromJson(response);
        _populateFormFields();
      } else {
        // User doesn't exist in users table, create one
        await _createUserProfile();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create user profile in database
  Future<void> _createUserProfile() async {
    try {
      final userId = _supabase.currentUser?.id;
      final email = _supabase.currentUser?.email;
      final userMetadata = _supabase.currentUser?.userMetadata;

      if (userId == null) return;

      final newUser = {
        'id': userId,
        'fullname':
            userMetadata?['name'] ??
            userMetadata?['full_name'] ??
            email?.split('@')[0] ??
            'User',
        'email': email,

        //    metadata': userMetadata,
        // 'created_at': DateTime.now().toIso8601String(),
        // 'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase.client
          .from('users')
          .insert(newUser)
          .select()
          .single();

      user.value = UserModel.fromJson(response);
      _populateFormFields();

      Get.snackbar(
        'Success',
        'Profile created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Populate form fields with user data
  void _populateFormFields() {
    if (user.value != null) {
      fullNameController.text = user.value!.fullname;
      phoneController.text = user.value!.phone ?? '';
      emailController.text = user.value!.email ?? '';
      // addressController.text = user.value!.address ?? '';
    }
  }

  /// Update user profile
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final userId = _supabase.currentUser?.id;
      if (userId == null) return;

      final updates = {
        'fullname': fullNameController.text.trim(),
        'phone': phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        'email': emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        'address': addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase.client
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      user.value = UserModel.fromJson(response);

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      isEditing.value = false;
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle edit mode
  void toggleEditing() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Reset to original values
      _populateFormFields();
    }
  }

  /// Navigate to edit profile page
  void goToEditProfile() {
    print('🔍 DEBUG: goToEditProfile called');
    print('🔍 DEBUG: Current route: ${Get.currentRoute}');
    print('🔍 DEBUG: Navigating to: ${Routes.EDIT_PROFILE}');
    isEditing.value = true;
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      );

      if (result == true) {
        isLoading.value = true;
        await _supabase.signOut();
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Validators
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 10) {
        return 'Phone number must be at least 10 digits';
      }
      if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
        return 'Invalid phone number format';
      }
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isEmail(value)) {
        return 'Enter a valid email address';
      }
    }
    return null;
  }

  // Getters
  String get displayName => user.value?.fullname ?? 'User';
  String get displayEmail =>
      user.value?.email ?? _supabase.currentUser?.email ?? 'No email';
  String get displayPhone => user.value?.phone ?? 'No phone number';
  String get displayAddress => user.value?.address ?? 'No address';
  String get initials {
    final name = displayName;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
