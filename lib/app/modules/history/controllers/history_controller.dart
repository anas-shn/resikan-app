import 'package:get/get.dart';
import 'package:resikan_app/app/data/models/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryController extends GetxController {
  final supabase = Supabase.instance.client;

  // Observable states
  final isLoading = false.obs;
  final bookings = <BookingModel>[].obs;
  final filteredBookings = <BookingModel>[].obs;
  final selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Load all user bookings
  Future<void> loadBookings() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'Anda harus login terlebih dahulu');
        return;
      }

      final response = await supabase
          .from('bookings')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      bookings.value = (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();

      // Apply current filter
      filterBookings(selectedFilter.value);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter bookings by status
  void filterBookings(String filter) {
    selectedFilter.value = filter;

    if (filter == 'all') {
      filteredBookings.value = bookings;
    } else {
      filteredBookings.value = bookings
          .where((booking) => booking.status == filter)
          .toList();
    }
  }

  // Refresh bookings
  Future<void> refreshBookings() async {
    await loadBookings();
  }

  // Cancel booking
  Future<void> cancelBooking(BookingModel booking) async {
    try {
      isLoading.value = true;

      await supabase
          .from('bookings')
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', booking.id);

      Get.snackbar(
        'Berhasil',
        'Pesanan berhasil dibatalkan',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Reload bookings
      await loadBookings();
    } catch (e) {
      Get.snackbar('Error', 'Gagal membatalkan pesanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get booking count by status
  int getBookingCountByStatus(String status) {
    if (status == 'all') {
      return bookings.length;
    }
    return bookings.where((booking) => booking.status == status).length;
  }

  // Check if there are any bookings
  bool get hasBookings => bookings.isNotEmpty;

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
}
