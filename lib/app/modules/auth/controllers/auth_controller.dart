import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final supabase = SupabaseProvider.to;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  // Form keys
  final formKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToAuthChanges();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void _listenToAuthChanges() {
    supabase.authStateChanges.listen((data) {
      final session = data.session;
      if (session != null) {
        Get.offAllNamed(Routes.NAVIGATION);
      } else {
        if (Get.currentRoute != Routes.LOGIN && Get.currentRoute != Routes.REGISTER) {
          Get.offAllNamed(Routes.LOGIN);
        }
      }
    });
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Sign in with email
  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await supabase.signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Welcome back!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.NAVIGATION);
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign up with email
  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await supabase.signUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {
          'name': nameController.text.trim(),
        },
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Account created! Please check your email to verify.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        // Clear form
        emailController.clear();
        passwordController.clear();
        nameController.clear();
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google (native)
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final response = await supabase.signInWithGoogle();

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Welcome!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.NAVIGATION);
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      final errorMessage = e.toString().contains('cancelled')
          ? 'Google sign in was cancelled'
          : 'Failed to sign in with Google. Please try again.';

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.signOut();
  }

  // Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // Navigation
  void goToRegister() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    Get.toNamed(Routes.REGISTER);
  }

  void goToLogin() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    Get.toNamed(Routes.LOGIN);
  }
}
