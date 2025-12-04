import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../history/controllers/history_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../subscription/controllers/subscription_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
