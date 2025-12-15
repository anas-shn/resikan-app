import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resikan_app/app/data/models/service_model.dart';
import 'package:resikan_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:resikan_app/app/widgets/service_icon_widget.dart';

class CreateBookingView extends GetView<BookingController> {
  const CreateBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Safe argument handling
    final ServiceModel? serviceArg = Get.arguments as ServiceModel?;

    if (serviceArg == null) {
      // If no service provided, go back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
        Get.snackbar(
          'Error',
          'Service not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ServiceModel service = serviceArg;

    return Scaffold(
      appBar: AppBar(title: Text('Pesan Layanan')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Info Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ServiceIconCircular(
                      service: service,
                      size: 50,
                      color: Colors.blue[700],
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${service.formattedPrice} • ${service.durationDisplay}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Date Selection
              Text(
                'Pilih Tanggal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Obx(
                () => InkWell(
                  onTap: () => controller.selectDate(context),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue[700]),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.selectedDate.value != null
                                ? DateFormat(
                                    'dd MMM yyyy',
                                  ).format(controller.selectedDate.value!)
                                : 'Pilih tanggal',
                            style: TextStyle(
                              fontSize: 15,
                              color: controller.selectedDate.value != null
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Time Selection
              Text(
                'Pilih Waktu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // Time Grid Selection
              Obx(
                () => Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.blue[700]),
                          SizedBox(width: 12),
                          Text(
                            'Waktu',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Hour Selection
                      Text(
                        'Jam',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(14, (index) {
                          final hour = index + 7; // 7 AM to 8 PM
                          final isSelected =
                              controller.selectedHour.value == hour;
                          return InkWell(
                            onTap: () => controller.selectHour(hour),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue[700]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue[700]!
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                '${hour.toString().padLeft(2, '0')}:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 16),

                      // Minute Selection
                      Text(
                        'Menit',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [0, 15, 30, 45].map((minute) {
                          final isSelected =
                              controller.selectedMinute.value == minute;
                          return InkWell(
                            onTap: () => controller.selectMinute(minute),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue[700]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue[700]!
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                minute.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 12),

                      // Selected Time Display
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.blue[700],
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Waktu dipilih: ${controller.selectedHour.value.toString().padLeft(2, '0')}:${controller.selectedMinute.value.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Address Selection
              Text(
                'Alamat Layanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // Address Selection Card
              Obx(
                () => InkWell(
                  onTap: controller.selectAddressFromList,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.hasSelectedAddress
                            ? Colors.blue[700]!
                            : Colors.grey[300]!,
                        width: controller.hasSelectedAddress ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: controller.hasSelectedAddress
                          ? Colors.blue[50]
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.hasSelectedAddress
                              ? Icons.location_on
                              : Icons.location_on_outlined,
                          color: controller.hasSelectedAddress
                              ? Colors.blue[700]
                              : Colors.grey[600],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.hasSelectedAddress
                                    ? controller.selectedAddress.value!.label
                                    : 'Pilih Alamat',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: controller.hasSelectedAddress
                                      ? Colors.blue[700]
                                      : Colors.grey[600],
                                ),
                              ),
                              if (controller.hasSelectedAddress) ...[
                                SizedBox(height: 4),
                                Text(
                                  controller.selectedAddress.value!.fullAddress,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),
              // Add New Address Button
              if (!controller.hasAddresses) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange[700],
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Belum ada alamat tersimpan',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],

              OutlinedButton.icon(
                onPressed: () => Get.toNamed('/address/add'),
                icon: Icon(Icons.add_location),
                label: Text('Tambah Alamat Baru'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Notes (Optional)
              Text(
                'Catatan Tambahan (Opsional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: controller.notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tambahkan catatan khusus',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Price Summary
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Biaya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      service.formattedPrice,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.createBooking(service),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Konfirmasi Pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
