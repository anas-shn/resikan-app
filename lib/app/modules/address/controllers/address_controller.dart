import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/address_model.dart';
import '../../../data/providers/addresses_provider.dart';

class AddressController extends GetxController {
  final addressProvider = Get.find<AddressProvider>();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  // Form controllers
  final labelController = TextEditingController();
  final fullAddressController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController(text: 'Indonesia');
  final notesController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Observable for form fields
  final RxBool isDefault = false.obs;
  final Rx<double?> latitude = Rx<double?>(null);
  final Rx<double?> longitude = Rx<double?>(null);

  // Form key
  final formKey = GlobalKey<FormState>();

  // Predefined labels
  final List<String> addressLabels = [
    'Rumah',
    'Kantor',
    'Apartemen',
    'Kos',
    'Rumah Orang Tua',
    'Lainnya',
  ];
  final RxString selectedLabel = 'Rumah'.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to label selection
    ever(selectedLabel, (label) {
      labelController.text = label;
    });

    // Check if editing existing address
    if (Get.arguments != null && Get.arguments is AddressModel) {
      selectedAddress.value = Get.arguments as AddressModel;
      _populateFormFields();
    }
  }

  @override
  void onClose() {
    labelController.dispose();
    fullAddressController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    notesController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }

  /// Populate form fields with existing address data
  void _populateFormFields() {
    if (selectedAddress.value != null) {
      final address = selectedAddress.value!;
      labelController.text = address.label;
      selectedLabel.value = address.label;
      fullAddressController.text = address.fullAddress;
      streetAddressController.text = address.streetAddress ?? '';
      cityController.text = address.city ?? '';
      stateController.text = address.state ?? '';
      postalCodeController.text = address.postalCode ?? '';
      countryController.text = address.country ?? 'Indonesia';
      notesController.text = address.notes ?? '';

      if (address.latitude != null) {
        latitude.value = address.latitude;
        latitudeController.text = address.latitude.toString();
      }
      if (address.longitude != null) {
        longitude.value = address.longitude;
        longitudeController.text = address.longitude.toString();
      }

      isDefault.value = address.isDefault;
    }
  }

  /// Set location from maps
  void setLocationFromMaps(double lat, double lng, String address) {
    latitude.value = lat;
    longitude.value = lng;
    latitudeController.text = lat.toString();
    longitudeController.text = lng.toString();

    // If full address is empty, use the address from maps
    if (fullAddressController.text.isEmpty) {
      fullAddressController.text = address;
    }

    // Try to parse city and state from address
    _parseAddressComponents(address);
  }

  /// Parse address components from full address string
  void _parseAddressComponents(String address) {
    // Simple parsing logic - can be improved with geocoding API
    final parts = address.split(',').map((e) => e.trim()).toList();

    if (parts.length >= 2) {
      // Last part is usually postal code or state
      if (parts.last.contains(RegExp(r'\d{5}'))) {
        postalCodeController.text = parts.last;
        if (parts.length >= 3) {
          stateController.text = parts[parts.length - 2];
        }
      } else {
        stateController.text = parts.last;
      }

      // Second to last is usually city
      if (parts.length >= 3) {
        cityController.text = parts[parts.length - 3];
      } else if (parts.length >= 2) {
        cityController.text = parts[parts.length - 2];
      }

      // First part is street address
      if (parts.isNotEmpty) {
        streetAddressController.text = parts.first;
      }
    }
  }

  /// Open maps to select location
  void openMaps() {
    Get.toNamed(
      '/address/map',
      arguments: {
        'latitude': latitude.value,
        'longitude': longitude.value,
        'onLocationSelected': (double lat, double lng, String address) {
          setLocationFromMaps(lat, lng, address);
        },
      },
    );
  }

  /// Save address
  Future<void> saveAddress() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSaving.value = true;

      final userId = addressProvider.currentUserId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();
      final addressData = AddressModel(
        id: selectedAddress.value?.id ?? '',
        userId: userId,
        label: labelController.text.trim(),
        fullAddress: fullAddressController.text.trim(),
        streetAddress: streetAddressController.text.trim().isEmpty
            ? null
            : streetAddressController.text.trim(),
        city: cityController.text.trim().isEmpty
            ? null
            : cityController.text.trim(),
        state: stateController.text.trim().isEmpty
            ? null
            : stateController.text.trim(),
        postalCode: postalCodeController.text.trim().isEmpty
            ? null
            : postalCodeController.text.trim(),
        country: countryController.text.trim().isEmpty
            ? null
            : countryController.text.trim(),
        latitude: latitude.value,
        longitude: longitude.value,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        isDefault: isDefault.value,
        createdAt: selectedAddress.value?.createdAt ?? now,
        updatedAt: now,
      );

      AddressModel savedAddress;
      if (selectedAddress.value != null) {
        // Update existing address
        savedAddress = await addressProvider.updateAddress(
          selectedAddress.value!.id,
          addressData,
        );

        Get.snackbar(
          'Success',
          'Address updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        // Create new address
        savedAddress = await addressProvider.createAddress(addressData);

        Get.snackbar(
          'Success',
          'Address added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      }

      // Go back to address list
      Get.back(result: savedAddress);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save address: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete address
  Future<void> deleteAddress() async {
    if (selectedAddress.value == null) return;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        isLoading.value = true;
        await addressProvider.deleteAddress(selectedAddress.value!.id);

        Get.back(result: true); // Go back with result

        Get.snackbar(
          'Success',
          'Address deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete address: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Set as default address
  Future<void> toggleDefault(bool value) async {
    isDefault.value = value;

    // If this is existing address and being set as default, update immediately
    if (selectedAddress.value != null && value) {
      try {
        await addressProvider.setDefaultAddress(selectedAddress.value!.id);
        Get.snackbar(
          'Success',
          'Default address updated',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        isDefault.value = !value; // Revert on error
        Get.snackbar(
          'Error',
          'Failed to update default address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Validators
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateLabel(String? value) {
    return validateRequired(value, 'Label');
  }

  String? validateFullAddress(String? value) {
    return validateRequired(value, 'Full address');
  }

  String? validatePostalCode(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^\d{5}$').hasMatch(value)) {
        return 'Postal code must be 5 digits';
      }
    }
    return null;
  }

  // Getters
  bool get isEditMode => selectedAddress.value != null;
  String get pageTitle => isEditMode ? 'Edit Address' : 'Add New Address';
  String get submitButtonText => isEditMode ? 'Update Address' : 'Save Address';
}
