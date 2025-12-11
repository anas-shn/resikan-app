import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme_config.dart';
import '../controllers/address_controller.dart';

class AddressFormView extends GetView<AddressController> {
  const AddressFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.pageTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ThemeConfig.primary,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: ThemeConfig.primary),
        actions: [
          if (controller.isEditMode)
            IconButton(
              onPressed: controller.deleteAddress,
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete Address',
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildLabelSection(),
              const SizedBox(height: 24),
              _buildAddressSection(),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildDetailsSection(),
              const SizedBox(height: 24),
              _buildNotesSection(),
              const SizedBox(height: 24),
              _buildDefaultSwitch(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Label',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeConfig.primary,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.addressLabels.map((label) {
              final isSelected = controller.selectedLabel.value == label;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    controller.selectedLabel.value = label;
                  }
                },
                selectedColor: ThemeConfig.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : ThemeConfig.primary,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.white,
                side: const BorderSide(color: ThemeConfig.primary),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.labelController,
          decoration: InputDecoration(
            labelText: 'Custom Label',
            hintText: 'Enter custom label',
            prefixIcon: const Icon(Icons.label_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: controller.validateLabel,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Address Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeConfig.primary,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: controller.openMaps,
              icon: const Icon(Icons.map, size: 18),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(foregroundColor: ThemeConfig.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.fullAddressController,
          decoration: InputDecoration(
            labelText: 'Full Address *',
            hintText: 'Enter complete address',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: controller.validateFullAddress,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.streetAddressController,
          decoration: InputDecoration(
            labelText: 'Street Address',
            hintText: 'Jl. Example No. 123',
            prefixIcon: const Icon(Icons.signpost),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeConfig.primary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  hintText: 'Jakarta',
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller.stateController,
                decoration: InputDecoration(
                  labelText: 'Province',
                  hintText: 'DKI Jakarta',
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.postalCodeController,
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  hintText: '12345',
                  prefixIcon: const Icon(Icons.markunread_mailbox),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: controller.validatePostalCode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller.countryController,
                decoration: InputDecoration(
                  labelText: 'Country',
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coordinates',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeConfig.primary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.latitude.value != null &&
              controller.longitude.value != null) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location Saved',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lat: ${controller.latitude.value!.toStringAsFixed(6)}, '
                          'Lng: ${controller.longitude.value!.toStringAsFixed(6)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: controller.openMaps,
                    icon: const Icon(Icons.edit_location, color: Colors.green),
                    tooltip: 'Change Location',
                  ),
                ],
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_off, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'No Location Set',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap the map icon to select location',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: controller.openMaps,
                    icon: const Icon(Icons.add_location, color: Colors.orange),
                    tooltip: 'Add Location',
                  ),
                ],
              ),
            );
          }
        }),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeConfig.primary,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.notesController,
          decoration: InputDecoration(
            labelText: 'Notes (Optional)',
            hintText: 'e.g., Near the blue building, 2nd floor',
            prefixIcon: const Icon(Icons.note_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildDefaultSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ThemeConfig.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle, color: ThemeConfig.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Set as Default Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This will be your primary address',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: controller.isDefault.value,
              onChanged: controller.toggleDefault,
              activeColor: ThemeConfig.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isSaving.value ? null : controller.saveAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeConfig.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: controller.isSaving.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save),
                    const SizedBox(width: 8),
                    Text(
                      controller.submitButtonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
