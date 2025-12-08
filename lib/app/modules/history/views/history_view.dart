import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resikan_app/app/data/models/booking_model.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Obx(
                () => Row(
                  children: [
                    _buildFilterChip(
                      'Semua',
                      'all',
                      controller.getBookingCountByStatus('all'),
                    ),
                    SizedBox(width: 8),
                    _buildFilterChip(
                      'Menunggu',
                      'pending',
                      controller.getBookingCountByStatus('pending'),
                    ),
                    SizedBox(width: 8),
                    _buildFilterChip(
                      'Dikonfirmasi',
                      'confirmed',
                      controller.getBookingCountByStatus('confirmed'),
                    ),
                    SizedBox(width: 8),
                    _buildFilterChip(
                      'Sedang Berjalan',
                      'in_progress',
                      controller.getBookingCountByStatus('in_progress'),
                    ),
                    SizedBox(width: 8),
                    _buildFilterChip(
                      'Selesai',
                      'completed',
                      controller.getBookingCountByStatus('completed'),
                    ),
                    SizedBox(width: 8),
                    _buildFilterChip(
                      'Dibatalkan',
                      'cancelled',
                      controller.getBookingCountByStatus('cancelled'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1),

          // Booking List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (!controller.hasBookings) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada riwayat pesanan',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              if (controller.filteredBookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list_off,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada pesanan dengan status ini',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshBookings,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: controller.filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.filteredBookings[index];
                    return _buildBookingCard(booking, context);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = controller.selectedFilter.value == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            SizedBox(width: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue[700] : Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          controller.filterBookings(value);
        }
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Get.theme.primaryColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[800],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showBookingDetailDialog(booking, context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Booking Number & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.bookingNumber,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusBadge(booking.status),
                ],
              ),
              SizedBox(height: 12),

              // Service Name
              if (booking.extras?['service_name'] != null)
                Row(
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.extras!['service_name'],
                        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),

              // Scheduled Date & Time
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'EEEE, dd MMM yyyy',
                      'id_ID',
                    ).format(booking.scheduledAt),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    DateFormat('HH:mm').format(booking.scheduledAt),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),

              // Address
              if (booking.address != null) ...[
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.address!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 12),

              // Price & Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Biaya',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(booking.totalPrice),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),

                  // Action Button
                  if (booking.isPending)
                    OutlinedButton(
                      onPressed: () {
                        _showCancelConfirmation(booking, context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Batalkan'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'pending':
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        icon = Icons.schedule;
        break;
      case 'confirmed':
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        icon = Icons.check_circle_outline;
        break;
      case 'in_progress':
        backgroundColor = Colors.purple[50]!;
        textColor = Colors.purple[700]!;
        icon = Icons.pending_actions;
        break;
      case 'completed':
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey[50]!;
        textColor = Colors.grey[700]!;
        icon = Icons.info;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Text(
            controller.getStatusDisplayName(status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetailDialog(BookingModel booking, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Pesanan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Nomor Booking', booking.bookingNumber),
              _buildDetailRow(
                'Status',
                controller.getStatusDisplayName(booking.status),
              ),
              if (booking.extras?['service_name'] != null)
                _buildDetailRow('Layanan', booking.extras!['service_name']),
              _buildDetailRow(
                'Tanggal',
                DateFormat(
                  'EEEE, dd MMMM yyyy',
                  'id_ID',
                ).format(booking.scheduledAt),
              ),
              _buildDetailRow(
                'Waktu',
                DateFormat('HH:mm').format(booking.scheduledAt),
              ),
              if (booking.durationMinutes != null)
                _buildDetailRow('Durasi', '${booking.durationMinutes} menit'),
              if (booking.address != null)
                _buildDetailRow('Alamat', booking.address!),
              if (booking.extras?['notes'] != null &&
                  booking.extras!['notes'].toString().isNotEmpty)
                _buildDetailRow('Catatan', booking.extras!['notes']),
              _buildDetailRow(
                'Total Biaya',
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(booking.totalPrice),
              ),
              _buildDetailRow(
                'Dibuat pada',
                DateFormat('dd MMM yyyy HH:mm').format(booking.createdAt),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Tutup')),
          if (booking.isPending)
            TextButton(
              onPressed: () {
                Get.back();
                _showCancelConfirmation(booking, context);
              },
              child: Text(
                'Batalkan Pesanan',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
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
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 15, color: Colors.grey[900])),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BookingModel booking, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Batalkan Pesanan?'),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pesanan ${booking.bookingNumber}?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Tidak')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelBooking(booking);
            },
            child: Text('Ya, Batalkan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
