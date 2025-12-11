import 'package:get/get.dart';
import '../../../data/providers/addresses_provider.dart';

import '../controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AddressProvider is available
    Get.lazyPut<AddressProvider>(() => AddressProvider(), fenix: true);

    Get.lazyPut<BookingController>(() => BookingController());
  }
}
