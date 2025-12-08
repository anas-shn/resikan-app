import 'package:get/get.dart';
import 'package:resikan_app/app/data/models/service_model.dart';
import 'package:resikan_app/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;

  final services = <ServiceModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  // Load services from database
  Future<void> loadServices() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('services')
          .select()
          .eq('active', true)
          .order('created_at', ascending: false);

      services.value = (response as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat layanan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate directly to service detail
  void goToServiceDetail(ServiceModel service) {
    Get.toNamed(Routes.SERVICE_DETAIL, arguments: service);
  }
}
