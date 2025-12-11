import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme_config.dart';
import '../../../data/models/address_model.dart';
import '../../../data/providers/addresses_provider.dart';

class AddressListView extends GetView<AddressProvider> {
  const AddressListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Addresses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ThemeConfig.primary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: ThemeConfig.primary),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasAddresses) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return _buildAddressCard(address);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddAddress,
        backgroundColor: ThemeConfig.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No Addresses Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first address to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _goToAddAddress,
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () => _goToEditAddress(address),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with label and default badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeConfig.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.label,
                          size: 16,
                          color: ThemeConfig.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          address.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThemeConfig.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (address.isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'DEFAULT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, address),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      if (!address.isDefault)
                        const PopupMenuItem(
                          value: 'set_default',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 20),
                              SizedBox(width: 8),
                              Text('Set as Default'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Full address
              Text(
                address.fullAddress,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),

              // City and state
              if (address.city != null || address.state != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_city,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      [
                        address.city,
                        address.state,
                      ].where((e) => e != null && e.isNotEmpty).join(', '),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],

              // Postal code
              if (address.postalCode != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.markunread_mailbox,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      address.postalCode!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],

              // Notes
              if (address.notes != null && address.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, size: 14, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address.notes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Location indicator
              if (address.hasValidCoordinates) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Location saved',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action, AddressModel address) async {
    switch (action) {
      case 'edit':
        _goToEditAddress(address);
        break;
      case 'set_default':
        await _setAsDefault(address);
        break;
      case 'delete':
        await _deleteAddress(address);
        break;
    }
  }

  Future<void> _setAsDefault(AddressModel address) async {
    try {
      await controller.setDefaultAddress(address.id);
      Get.snackbar(
        'Success',
        '${address.label} set as default address',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to set default address: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> _deleteAddress(AddressModel address) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.label}"?'),
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
        await controller.deleteAddress(address.id);
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
      }
    }
  }

  void _goToAddAddress() {
    Get.toNamed('/address/add');
  }

  void _goToEditAddress(AddressModel address) {
    Get.toNamed('/address/edit', arguments: address);
  }
}
