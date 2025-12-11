import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/address_model.dart';
import 'supabase_provider.dart';

class AddressProvider extends GetxController {
  static AddressProvider get to => Get.find();

  final _supabase = SupabaseProvider.to;
  SupabaseClient get client => _supabase.client;

  // Observable lists
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rx<AddressModel?> defaultAddress = Rx<AddressModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserAddresses();
  }

  /// Get current user ID
  String? get currentUserId => _supabase.currentUser?.id;

  /// Load all addresses for current user
  Future<void> loadUserAddresses() async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      isLoading.value = true;

      final response = await client
          .from('addresses')
          .select()
          .eq('user_id', currentUserId!)
          .order('is_default', ascending: false)
          .order('created_at', ascending: false);

      addresses.value = (response as List)
          .map((json) => AddressModel.fromJson(json))
          .toList();

      // Set default address
      final defaultAddr = addresses.firstWhereOrNull((addr) => addr.isDefault);
      defaultAddress.value = defaultAddr;
    } catch (e) {
      print('Error loading addresses: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get address by ID
  Future<AddressModel?> getAddressById(String addressId) async {
    try {
      final response = await client
          .from('addresses')
          .select()
          .eq('id', addressId)
          .maybeSingle();

      if (response != null) {
        return AddressModel.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      rethrow;
    }
  }

  /// Create new address
  Future<AddressModel> createAddress(AddressModel address) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final response = await client
          .from('addresses')
          .insert(address.toInsertJson())
          .select()
          .single();

      final newAddress = AddressModel.fromJson(response);

      // Add to list
      addresses.insert(0, newAddress);

      // Update default address if this is default
      if (newAddress.isDefault) {
        defaultAddress.value = newAddress;
      }

      // If this is the first address, make it default automatically
      if (addresses.length == 1) {
        await setDefaultAddress(newAddress.id);
      }

      return newAddress;
    } catch (e) {
      print('Error creating address: $e');
      rethrow;
    }
  }

  /// Update existing address
  Future<AddressModel> updateAddress(
    String addressId,
    AddressModel address,
  ) async {
    try {
      final response = await client
          .from('addresses')
          .update(address.toUpdateJson())
          .eq('id', addressId)
          .select()
          .single();

      final updatedAddress = AddressModel.fromJson(response);

      // Update in list
      final index = addresses.indexWhere((addr) => addr.id == addressId);
      if (index != -1) {
        addresses[index] = updatedAddress;
      }

      // Update default address if needed
      if (updatedAddress.isDefault) {
        defaultAddress.value = updatedAddress;
      }

      return updatedAddress;
    } catch (e) {
      print('Error updating address: $e');
      rethrow;
    }
  }

  /// Delete address
  Future<void> deleteAddress(String addressId) async {
    try {
      // Check if this is the default address
      final addressToDelete = addresses.firstWhereOrNull(
        (addr) => addr.id == addressId,
      );
      final wasDefault = addressToDelete?.isDefault ?? false;

      await client.from('addresses').delete().eq('id', addressId);

      // Remove from list
      addresses.removeWhere((addr) => addr.id == addressId);

      // If deleted address was default and there are other addresses, set first one as default
      if (wasDefault && addresses.isNotEmpty) {
        await setDefaultAddress(addresses.first.id);
      } else if (wasDefault) {
        defaultAddress.value = null;
      }
    } catch (e) {
      print('Error deleting address: $e');
      rethrow;
    }
  }

  /// Set address as default
  Future<void> setDefaultAddress(String addressId) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // The database trigger will automatically unset other default addresses
      final response = await client
          .from('addresses')
          .update({'is_default': true})
          .eq('id', addressId)
          .select()
          .single();

      final updatedAddress = AddressModel.fromJson(response);

      // Update all addresses in the list
      for (var i = 0; i < addresses.length; i++) {
        if (addresses[i].id == addressId) {
          addresses[i] = updatedAddress;
        } else {
          addresses[i] = addresses[i].copyWith(isDefault: false);
        }
      }

      // Update default address
      defaultAddress.value = updatedAddress;

      // Reload to ensure consistency
      await loadUserAddresses();
    } catch (e) {
      print('Error setting default address: $e');
      rethrow;
    }
  }

  /// Get default address for current user
  Future<AddressModel?> getDefaultAddress() async {
    try {
      if (currentUserId == null) {
        return null;
      }

      final response = await client
          .from('addresses')
          .select()
          .eq('user_id', currentUserId!)
          .eq('is_default', true)
          .maybeSingle();

      if (response != null) {
        final addr = AddressModel.fromJson(response);
        defaultAddress.value = addr;
        return addr;
      }

      return null;
    } catch (e) {
      print('Error getting default address: $e');
      return null;
    }
  }

  /// Search addresses by query (label, city, etc)
  List<AddressModel> searchAddresses(String query) {
    if (query.isEmpty) return addresses;

    final lowerQuery = query.toLowerCase();
    return addresses.where((address) {
      return address.label.toLowerCase().contains(lowerQuery) ||
          address.fullAddress.toLowerCase().contains(lowerQuery) ||
          (address.city?.toLowerCase().contains(lowerQuery) ?? false) ||
          (address.state?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get addresses count
  int get addressesCount => addresses.length;

  /// Check if user has any addresses
  bool get hasAddresses => addresses.isNotEmpty;

  /// Check if user has default address
  bool get hasDefaultAddress => defaultAddress.value != null;

  /// Get formatted default address for display
  String get defaultAddressDisplay {
    if (defaultAddress.value != null) {
      return defaultAddress.value!.shortAddress;
    }
    return 'No address set';
  }

  /// Get full default address
  String get defaultAddressFullDisplay {
    if (defaultAddress.value != null) {
      return defaultAddress.value!.fullAddress;
    }
    return 'No address set';
  }

  /// Refresh addresses
  Future<void> refresh() async {
    await loadUserAddresses();
  }

  /// Clear all data
  void clear() {
    addresses.clear();
    defaultAddress.value = null;
  }
}
