import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resikan_app/app/data/models/booking_model.dart';
import 'package:resikan_app/app/data/models/service_model.dart';
import 'package:resikan_app/app/data/models/address_model.dart';
import 'package:resikan_app/app/data/providers/addresses_provider.dart';
import 'package:resikan_app/app/routes/app_pages.dart';
import 'package:resikan_app/app/modules/booking/utils/booking_error_handler.dart';
import 'package:resikan_app/app/modules/booking/utils/booking_validation.dart';
import 'package:resikan_app/app/modules/booking/views/booking_success_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class BookingController extends GetxController {
  final supabase = Supabase.instance.client;
  final uuid = Uuid();

  // Address Provider
  AddressProvider? _addressProvider;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  // Observable states
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();

  // Hour and minute selection (for time picker grid)
  final selectedHour = 9.obs;
  final selectedMinute = 0.obs;

  // Address selection
  final selectedAddress = Rxn<AddressModel>();
  final selectedLocation = Rxn<Map<String, double>>();
  final isLoading = false.obs;
  final myBookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initAddressProvider();
  }

  @override
  void onReady() {
    super.onReady();
    // Load after UI is ready
    _loadDefaultAddress();
    loadMyBookings();
  }

  /// Initialize AddressProvider
  void _initAddressProvider() {
    try {
      _addressProvider = Get.find<AddressProvider>();
      print('✅ AddressProvider initialized successfully');
    } catch (e) {
      print('⚠️ AddressProvider not yet available: $e');
      // Try to initialize it
      try {
        Get.lazyPut<AddressProvider>(() => AddressProvider(), fenix: true);
        _addressProvider = Get.find<AddressProvider>();
        print('✅ AddressProvider created and initialized');
      } catch (e2) {
        print('❌ Failed to create AddressProvider: $e2');
      }
    }
  }

  /// Load default address and set to form
  Future<void> _loadDefaultAddress() async {
    // Wait a bit for AddressProvider to be fully ready
    await Future.delayed(const Duration(milliseconds: 100));

    if (_addressProvider == null) {
      print('⚠️ AddressProvider still null, retrying...');
      _initAddressProvider();
    }

    if (_addressProvider == null) {
      print('❌ Cannot load default address: AddressProvider is null');
      return;
    }

    try {
      // Ensure addresses are loaded
      if (_addressProvider!.addresses.isEmpty) {
        await _addressProvider!.loadUserAddresses();
      }

      if (_addressProvider!.hasDefaultAddress) {
        final defaultAddr = _addressProvider!.defaultAddress.value;
        if (defaultAddr != null) {
          selectAddress(defaultAddr);
          print('✅ Default address loaded: ${defaultAddr.label}');
        }
      } else {
        print('ℹ️ No default address found');
      }
    } catch (e) {
      print('❌ Error loading default address: $e');
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // ==================== Time Selection Methods ====================

  /// Select hour from time grid
  void selectHour(int hour) {
    if (hour < 7 || hour > 20) {
      BookingErrorHandler.showWarning(
        title: 'Jam Tidak Valid',
        message: 'Jam operasional adalah 07:00 - 20:00',
      );
      return;
    }
    selectedHour.value = hour;
  }

  /// Select minute from time grid
  void selectMinute(int minute) {
    if (![0, 15, 30, 45].contains(minute)) {
      BookingErrorHandler.showWarning(
        title: 'Menit Tidak Valid',
        message: 'Pilih menit: 00, 15, 30, atau 45',
      );
      return;
    }
    selectedMinute.value = minute;
  }

  // Date picker with error handling
  Future<void> selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 90)),
        helpText: 'Pilih Tanggal Layanan',
        cancelText: 'Batal',
        confirmText: 'Pilih',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue[700]!,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        // Validate the picked date
        final dateError = BookingValidation.validateDate(picked);
        if (dateError != null) {
          BookingErrorHandler.handleValidationError('Tanggal', dateError);
          return;
        }

        selectedDate.value = picked;

        // Removed popup notification
      }
    } catch (e) {
      BookingErrorHandler.handleError(e, context: 'Memilih Tanggal');
    }
  }

  // Time picker (alternative to grid selection)
  Future<void> selectTime(BuildContext context) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: selectedHour.value,
          minute: selectedMinute.value,
        ),
        helpText: 'Pilih Waktu Layanan',
        cancelText: 'Batal',
        confirmText: 'Pilih',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue[700]!,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        selectedTime.value = picked;
        selectedHour.value = picked.hour;
        selectedMinute.value = picked.minute;

        // Validate the picked time
        final timeError = BookingValidation.validateTime(
          selectedDate: selectedDate.value,
          selectedHour: picked.hour,
          selectedMinute: picked.minute,
        );

        if (timeError != null) {
          BookingErrorHandler.handleValidationError('Waktu', timeError);
          selectedTime.value = null;
          return;
        }
      }
    } catch (e) {
      BookingErrorHandler.handleError(e, context: 'Memilih Waktu');
    }
  }

  // ==================== Address Selection Methods ====================

  /// Navigate to address selection
  Future<void> selectAddressFromList() async {
    if (_addressProvider == null) {
      BookingErrorHandler.showWarning(
        title: 'Address Provider',
        message: 'Silakan restart aplikasi',
      );
      return;
    }

    // Check if user has addresses
    if (!_addressProvider!.hasAddresses) {
      final confirm = await BookingErrorHandler.showConfirmDialog(
        title: 'Belum Ada Alamat',
        message: 'Anda belum memiliki alamat. Tambahkan alamat sekarang?',
        confirmText: 'Tambah Alamat',
        cancelText: 'Batal',
      );

      if (confirm) {
        Get.toNamed('/address/add');
      }
      return;
    }

    // Show address selection dialog
    final selected = await Get.bottomSheet<AddressModel>(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Alamat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _addressProvider!.addresses.length,
                itemBuilder: (context, index) {
                  final address = _addressProvider!.addresses[index];
                  return ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: address.isDefault ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      address.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      address.fullAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: address.isDefault
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                    onTap: () => Get.back(result: address),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.toNamed('/address/add');
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Alamat Baru'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );

    if (selected != null) {
      selectAddress(selected);
    }
  }

  /// Select address and populate form
  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
    addressController.text = address.fullAddress;

    // Set location if available
    if (address.hasValidCoordinates) {
      selectedLocation.value = {
        'latitude': address.latitude!,
        'longitude': address.longitude!,
      };
    }

    // Removed popup notification
  }

  /// Clear selected address
  void clearAddress() {
    selectedAddress.value = null;
    addressController.clear();
    selectedLocation.value = null;
  }

  // Location picker with error handling
  Future<void> pickLocation() async {
    try {
      // TODO: Implement with google_maps_flutter or other map package
      BookingErrorHandler.showInfo(
        title: 'Info',
        message: 'Fitur pemilihan lokasi dari peta akan segera tersedia',
        duration: const Duration(seconds: 3),
      );

      // Example of setting location manually (for testing)
      // selectedLocation.value = {
      //   'latitude': -6.2088,
      //   'longitude': 106.8456,
      // };
    } catch (e) {
      BookingErrorHandler.handleError(e, context: 'Memilih Lokasi');
    }
  }

  // Validate booking form with comprehensive validation
  bool validateBooking() {
    // Validate form fields (TextFormField validators)
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Use comprehensive validation utility
    final errors = BookingValidation.validateBookingForm(
      selectedDate: selectedDate.value,
      selectedHour: selectedHour.value,
      selectedMinute: selectedMinute.value,
      address: addressController.text,
      notes: notesController.text,
    );

    // Show first error if any
    if (errors.isNotEmpty) {
      final firstError = errors.values.first;
      BookingErrorHandler.handleValidationError('', firstError);
      return false;
    }

    return true;
  }

  // Create booking with comprehensive error handling
  Future<void> createBooking(ServiceModel service) async {
    // Validate form first
    if (!validateBooking()) return;

    try {
      isLoading.value = true;

      // Check authentication
      final user = supabase.auth.currentUser;
      if (user == null) {
        BookingErrorHandler.handleAuthError(
          'Anda harus login terlebih dahulu untuk membuat pesanan',
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // Check if service is active
      if (!service.active) {
        BookingErrorHandler.showError(
          title: 'Layanan Tidak Tersedia',
          message: 'Layanan ${service.name} sedang tidak tersedia',
        );
        return;
      }

      // Combine date and time using hour and minute
      final scheduledAt = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedHour.value,
        selectedMinute.value,
      );

      // Double check if time is still valid
      if (scheduledAt.isBefore(DateTime.now().add(const Duration(hours: 1)))) {
        BookingErrorHandler.showError(
          title: 'Waktu Tidak Valid',
          message: 'Waktu booking minimal 1 jam dari sekarang',
        );
        return;
      }

      // Generate booking number
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final bookingNumber = 'BK-$timestamp';

      // Prepare booking data
      final booking = BookingModel(
        id: uuid.v4(),
        bookingNumber: bookingNumber,
        userId: user.id,
        scheduledAt: scheduledAt,
        durationMinutes: service.defaultDurationMinutes,
        totalPrice: service.basePrice,
        status: 'pending',
        address: addressController.text.trim(),
        location: selectedLocation.value,
        extras: {
          'service_id': service.id,
          'service_name': service.name,
          'service_category': service.category,
          'notes': notesController.text.trim(),
          if (selectedAddress.value != null) ...{
            'address_id': selectedAddress.value!.id,
            'address_label': selectedAddress.value!.label,
          },
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Insert to database
      await supabase.from('bookings').insert(booking.toJson());

      // Create booking item
      await supabase.from('booking_items').insert({
        'id': uuid.v4(),
        'booking_id': booking.id,
        'service_id': service.id,
        'quantity': 1,
        'price': service.basePrice,
        'notes': notesController.text.trim(),
      });

      // Clear form
      _clearForm();

      // Reload bookings
      await loadMyBookings();

      // Navigate to success screen
      Get.off(
        () => BookingSuccessView(
          bookingNumber: bookingNumber,
          serviceName: service.name,
          totalPrice: service.basePrice,
        ),
      );
    } on PostgrestException catch (e) {
      // Database specific errors
      if (e.message.toLowerCase().contains('duplicate')) {
        BookingErrorHandler.showError(
          title: 'Pesanan Duplikat',
          message: 'Anda sudah memiliki pesanan pada waktu yang sama',
        );
      } else {
        BookingErrorHandler.handleDatabaseError(
          'Gagal menyimpan pesanan: ${e.message}',
        );
      }
    } on AuthException catch (e) {
      // Authentication errors
      BookingErrorHandler.handleAuthError(e.message);
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      // Generic booking creation errors
      BookingErrorHandler.handleBookingCreationError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Load user bookings with error handling
  Future<void> loadMyBookings() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) {
        // Don't show error if user is not logged in
        myBookings.clear();
        return;
      }

      final response = await supabase
          .from('bookings')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      myBookings.value = (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();

      debugPrint('Loaded ${myBookings.length} bookings');
    } on PostgrestException catch (e) {
      BookingErrorHandler.handleDatabaseError(
        'Gagal memuat riwayat pesanan: ${e.message}',
      );
    } on AuthException catch (e) {
      BookingErrorHandler.handleAuthError(e.message);
    } catch (e) {
      BookingErrorHandler.handleError(e, context: 'Memuat Riwayat Pesanan');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Cancel Booking ====================

  /// Cancel booking with confirmation
  Future<void> cancelBooking(BookingModel booking) async {
    // Check if booking can be cancelled
    if (booking.status == 'cancelled') {
      BookingErrorHandler.showWarning(
        title: 'Pesanan Sudah Dibatalkan',
        message: 'Pesanan ini sudah dibatalkan sebelumnya',
      );
      return;
    }

    if (booking.status == 'completed') {
      BookingErrorHandler.showWarning(
        title: 'Tidak Dapat Dibatalkan',
        message: 'Pesanan yang sudah selesai tidak dapat dibatalkan',
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await BookingErrorHandler.showConfirmDialog(
      title: 'Batalkan Pesanan',
      message:
          'Apakah Anda yakin ingin membatalkan pesanan ini?\n\nNomor: ${booking.bookingNumber}',
      confirmText: 'Ya, Batalkan',
      cancelText: 'Tidak',
      confirmColor: Colors.red[700],
    );

    if (!confirmed) return;

    try {
      isLoading.value = true;

      await supabase
          .from('bookings')
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
            'extras': {
              ...?booking.extras,
              'cancelled_at': DateTime.now().toIso8601String(),
              'cancelled_by': 'user',
            },
          })
          .eq('id', booking.id);

      BookingErrorHandler.showSuccess(
        title: 'Pesanan Dibatalkan',
        message: 'Pesanan berhasil dibatalkan',
      );

      // Reload bookings
      await loadMyBookings();
    } on PostgrestException catch (e) {
      BookingErrorHandler.handleDatabaseError(
        'Gagal membatalkan pesanan: ${e.message}',
      );
    } catch (e) {
      BookingErrorHandler.handleError(e, context: 'Membatalkan Pesanan');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Helper Methods ====================

  /// Clear form after successful booking
  void _clearForm() {
    addressController.clear();
    notesController.clear();
    selectedDate.value = null;
    selectedTime.value = null;
    selectedHour.value = 9;
    selectedMinute.value = 0;
    selectedLocation.value = null;
    selectedAddress.value = null;
  }

  /// Get formatted selected time
  String get selectedTimeDisplay {
    return BookingValidation.formatTime(
      selectedHour.value,
      selectedMinute.value,
    );
  }

  /// Get formatted selected date
  String? get selectedDateDisplay {
    if (selectedDate.value == null) return null;
    return BookingValidation.formatDate(selectedDate.value!);
  }

  /// Check if booking form is complete
  bool get isFormComplete {
    return selectedDate.value != null &&
        addressController.text.trim().isNotEmpty;
  }

  /// Get booking status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[700]!;
      case 'confirmed':
        return Colors.blue[700]!;
      case 'in_progress':
        return Colors.purple[700]!;
      case 'completed':
        return Colors.green[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  /// Get booking status text
  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'in_progress':
        return 'Sedang Dikerjakan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  // ==================== Address Helper Methods ====================

  /// Get selected address display
  String get selectedAddressDisplay {
    if (selectedAddress.value != null) {
      return selectedAddress.value!.label;
    }
    return 'Pilih Alamat';
  }

  /// Check if address is selected
  bool get hasSelectedAddress => selectedAddress.value != null;

  /// Get address provider
  AddressProvider? get addressProvider => _addressProvider;

  /// Check if user has addresses
  bool get hasAddresses => _addressProvider?.hasAddresses ?? false;
}
