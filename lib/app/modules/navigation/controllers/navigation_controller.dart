import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if there's a tab argument to navigate to
    final args = Get.arguments;
    if (args != null && args is Map && args['tab'] != null) {
      currentIndex.value = args['tab'] as int;
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
