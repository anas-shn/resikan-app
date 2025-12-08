import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Comprehensive error handling utility for booking operations
class BookingErrorHandler {
  // Error type enumeration
  static const String validationError = 'validation';
  static const String networkError = 'network';
  static const String authError = 'auth';
  static const String databaseError = 'database';
  static const String unknownError = 'unknown';

  /// Show error message to user
  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
    Color? backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor ?? Colors.red[700],
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 20,
    );
  }

  /// Show success message to user
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: Colors.green[700],
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 20,
    );
  }

  /// Show warning message to user
  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: Colors.orange[700],
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber_outlined, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 20,
    );
  }

  /// Show info message to user
  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: Colors.blue[700],
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 20,
    );
  }

  /// Handle validation errors
  static void handleValidationError(String field, String message) {
    showError(
      title: 'Validasi Gagal',
      message: message,
      duration: const Duration(seconds: 2),
    );
  }

  /// Handle network errors
  static void handleNetworkError([String? customMessage]) {
    showError(
      title: 'Kesalahan Jaringan',
      message:
          customMessage ??
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      duration: const Duration(seconds: 4),
    );
  }

  /// Handle authentication errors
  static void handleAuthError([String? customMessage]) {
    showError(
      title: 'Autentikasi Gagal',
      message:
          customMessage ?? 'Sesi Anda telah berakhir. Silakan login kembali.',
      duration: const Duration(seconds: 3),
    );
  }

  /// Handle database errors
  static void handleDatabaseError([String? customMessage]) {
    showError(
      title: 'Kesalahan Database',
      message: customMessage ?? 'Terjadi kesalahan saat menyimpan data.',
      duration: const Duration(seconds: 3),
    );
  }

  /// Handle generic errors with detailed categorization
  static void handleError(dynamic error, {String? context}) {
    String errorMessage = _parseErrorMessage(error);
    String errorType = _categorizeError(error);

    switch (errorType) {
      case networkError:
        handleNetworkError(errorMessage);
        break;
      case authError:
        handleAuthError(errorMessage);
        break;
      case databaseError:
        handleDatabaseError(errorMessage);
        break;
      default:
        showError(title: context ?? 'Terjadi Kesalahan', message: errorMessage);
    }

    // Log error for debugging
    debugPrint('=== BOOKING ERROR ===');
    debugPrint('Context: $context');
    debugPrint('Type: $errorType');
    debugPrint('Error: $error');
    debugPrint('====================');
  }

  /// Parse error message from various error types
  static String _parseErrorMessage(dynamic error) {
    if (error == null) return 'Terjadi kesalahan yang tidak diketahui';

    if (error is String) return error;

    if (error is Exception) {
      final message = error.toString();
      if (message.contains('Exception:')) {
        return message.split('Exception:').last.trim();
      }
      return message;
    }

    return error.toString();
  }

  /// Categorize error type based on error content
  static String _categorizeError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('socket') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return networkError;
    }

    if (errorString.contains('auth') ||
        errorString.contains('unauthorized') ||
        errorString.contains('token') ||
        errorString.contains('session')) {
      return authError;
    }

    if (errorString.contains('database') ||
        errorString.contains('sql') ||
        errorString.contains('postgres') ||
        errorString.contains('duplicate')) {
      return databaseError;
    }

    return unknownError;
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Tidak',
    Color? confirmColor,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Colors.orange[700]),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  /// Show error dialog with retry option
  static Future<bool> showErrorDialogWithRetry({
    required String title,
    required String message,
    String retryText = 'Coba Lagi',
    String cancelText = 'Batal',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(retryText),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  /// Validate booking form fields
  static Map<String, String?> validateBookingFields({
    DateTime? selectedDate,
    int? selectedHour,
    int? selectedMinute,
    String? address,
  }) {
    Map<String, String?> errors = {};

    // Validate date
    if (selectedDate == null) {
      errors['date'] = 'Tanggal harus dipilih';
    } else {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final today = DateTime(now.year, now.month, now.day);

      if (selectedDateTime.isBefore(today)) {
        errors['date'] = 'Tanggal tidak boleh di masa lalu';
      }
    }

    // Validate time
    if (selectedHour == null || selectedMinute == null) {
      errors['time'] = 'Waktu harus dipilih';
    } else if (selectedDate != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedHour,
        selectedMinute,
      );

      if (selectedDateTime.isBefore(now.add(const Duration(hours: 1)))) {
        errors['time'] = 'Waktu booking minimal 1 jam dari sekarang';
      }

      // Validate business hours
      if (selectedHour < 7 || selectedHour > 20) {
        errors['time'] = 'Jam operasional adalah 07:00 - 20:00';
      }
    }

    // Validate address
    if (address == null || address.trim().isEmpty) {
      errors['address'] = 'Alamat harus diisi';
    } else if (address.trim().length < 10) {
      errors['address'] = 'Alamat minimal 10 karakter';
    }

    return errors;
  }

  /// Show validation errors
  static void showValidationErrors(Map<String, String?> errors) {
    if (errors.isEmpty) return;

    final firstError = errors.values.first;
    if (firstError != null) {
      handleValidationError('', firstError);
    }
  }

  /// Handle booking creation errors with specific messages
  static void handleBookingCreationError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('duplicate')) {
      showError(
        title: 'Pesanan Duplikat',
        message: 'Anda sudah memiliki pesanan pada waktu yang sama.',
      );
    } else if (errorString.contains('slot')) {
      showError(
        title: 'Waktu Tidak Tersedia',
        message: 'Waktu yang dipilih sudah dipesan. Silakan pilih waktu lain.',
      );
    } else if (errorString.contains('service')) {
      showError(
        title: 'Layanan Tidak Tersedia',
        message: 'Layanan yang dipilih sedang tidak tersedia.',
      );
    } else {
      handleError(error, context: 'Gagal Membuat Pesanan');
    }
  }

  /// Show loading overlay
  static void showLoadingOverlay([String? message]) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading overlay
  static void hideLoadingOverlay() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
