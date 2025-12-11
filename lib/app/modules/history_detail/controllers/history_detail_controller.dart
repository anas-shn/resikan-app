import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resikan_app/app/data/models/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryDetailController extends GetxController {
  final supabase = Supabase.instance.client;

  // Observable states
  final isLoading = false.obs;
  final isCancelling = false.obs;
  late final Rx<BookingModel> booking;

  @override
  void onInit() {
    super.onInit();
    // Get booking data from arguments
    final BookingModel bookingData = Get.arguments as BookingModel;
    booking = bookingData.obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Refresh booking detail
  Future<void> refreshBookingDetail() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('bookings')
          .select()
          .eq('id', booking.value.id)
          .single();

      booking.value = BookingModel.fromJson(response);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail pesanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Cancel booking
  Future<void> cancelBooking() async {
    try {
      isCancelling.value = true;

      await supabase
          .from('bookings')
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', booking.value.id);

      Get.snackbar(
        'Berhasil',
        'Pesanan berhasil dibatalkan',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Update local booking status
      booking.value = booking.value.copyWith(
        status: 'cancelled',
        updatedAt: DateTime.now(),
      );

      // Return to previous page with result
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal membatalkan pesanan: $e');
    } finally {
      isCancelling.value = false;
    }
  }

  // Get status display name
  String getStatusDisplayName(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'in_progress':
        return 'Sedang Berjalan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFA726); // Orange
      case 'confirmed':
        return const Color(0xFF42A5F5); // Blue
      case 'in_progress':
        return const Color(0xFF66BB6A); // Green
      case 'completed':
        return const Color(0xFF4CAF50); // Dark Green
      case 'cancelled':
        return const Color(0xFFEF5350); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}
