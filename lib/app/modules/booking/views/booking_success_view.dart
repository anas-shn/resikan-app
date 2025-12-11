import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resikan_app/app/routes/app_pages.dart';

class BookingSuccessView extends StatefulWidget {
  final String bookingNumber;
  final String serviceName;
  final double totalPrice;

  const BookingSuccessView({
    super.key,
    required this.bookingNumber,
    required this.serviceName,
    required this.totalPrice,
  });

  @override
  State<BookingSuccessView> createState() => _BookingSuccessViewState();
}

class _BookingSuccessViewState extends State<BookingSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon with Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[400]!, Colors.green[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withAlpha(80),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Success Title
              const Text(
                'Pesanan Berhasil!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Success Subtitle
              Text(
                'Terima kasih telah memesan layanan kami',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Booking Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Nomor Pesanan', widget.bookingNumber),
                    const Divider(height: 24),
                    _buildDetailRow('Layanan', widget.serviceName),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Total Biaya',
                      'Rp ${widget.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Mohon tunggu konfirmasi dari admin kami',
                        style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              Row(
                children: [
                  // Back to Services Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.until((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Go to History Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to navigation and switch to history tab (index 2)
                        Get.offAllNamed(
                          Routes.NAVIGATION,
                          arguments: {'tab': 2},
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('Lihat Riwayat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlighted ? 18 : 15,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            color: isHighlighted ? Colors.green[700] : Colors.black87,
          ),
        ),
      ],
    );
  }
}
