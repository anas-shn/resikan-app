import 'package:get/get.dart';
import '../../../data/providers/addresses_provider.dart';
import '../controllers/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put AddressProvider (singleton)
    Get.lazyPut<AddressProvider>(() => AddressProvider(), fenix: true);

    // Put AddressController
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
