import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/history_detail_controller.dart';

class HistoryDetailView extends GetView<HistoryDetailController> {
  const HistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final booking = controller.booking.value;

        return RefreshIndicator(
          onRefresh: controller.refreshBookingDetail,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: controller.getStatusColor(booking.status),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getStatusIcon(booking.status),
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.getStatusDisplayName(booking.status),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.bookingNumber,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Booking Details Card
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.receipt_long,
                                color: Theme.of(context).primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Informasi Pesanan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: 4),

                      // Service Name
                      if (booking.extras?['service_name'] != null)
                        _buildDetailItem(
                          context,
                          icon: Icons.cleaning_services,
                          label: 'Layanan',
                          value: booking.extras!['service_name'],
                        ),

                      // Date
                      _buildDetailItem(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Tanggal',
                        value: DateFormat(
                          'EEEE, dd MMMM yyyy',
                          'id_ID',
                        ).format(booking.scheduledAt),
                      ),

                      // Time
                      _buildDetailItem(
                        context,
                        icon: Icons.access_time,
                        label: 'Waktu',
                        value: DateFormat('HH:mm').format(booking.scheduledAt),
                      ),

                      // Duration
                      if (booking.durationMinutes != null)
                        _buildDetailItem(
                          context,
                          icon: Icons.timer_outlined,
                          label: 'Durasi',
                          value: '${booking.durationMinutes} menit',
                        ),

                      // Address
                      if (booking.address != null)
                        _buildDetailItem(
                          context,
                          icon: Icons.location_on,
                          label: 'Alamat',
                          value: booking.address!,
                          isLongText: true,
                        ),

                      // Notes
                      if (booking.extras?['notes'] != null &&
                          booking.extras!['notes'].toString().isNotEmpty)
                        _buildDetailItem(
                          context,
                          icon: Icons.notes,
                          label: 'Catatan',
                          value: booking.extras!['notes'],
                          isLongText: true,
                        ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                // Price Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.payments,
                                color: Colors.green,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Informasi Pembayaran',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Biaya',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(booking.totalPrice),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Timeline Card
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.history,
                                color: Colors.orange,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Timeline',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: 4),
                      _buildTimelineItem(
                        context,
                        'Dibuat',
                        DateFormat(
                          'dd MMM yyyy HH:mm',
                          'id_ID',
                        ).format(booking.createdAt),
                      ),
                      _buildTimelineItem(
                        context,
                        'Terakhir Diperbarui',
                        DateFormat(
                          'dd MMM yyyy HH:mm',
                          'id_ID',
                        ).format(booking.updatedAt),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
      // Bottom Button
      bottomNavigationBar: Obx(() {
        final booking = controller.booking.value;
        if (!booking.isPending) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: controller.isCancelling.value
                  ? null
                  : () => _showCancelConfirmation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: controller.isCancelling.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel_outlined, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Batalkan Pesanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLongText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: isLongText
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.grey[700]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_outlined;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'in_progress':
        return Icons.sync;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  void _showCancelConfirmation(BuildContext context) {
    final booking = controller.booking.value;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Batalkan Pesanan?'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pesanan ${booking.bookingNumber}?\n\nTindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Tidak',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Ya, Batalkan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
