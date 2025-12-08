import 'package:get/get.dart';
import 'package:resikan_app/app/modules/service/controllers/service_controller.dart';
import 'package:resikan_app/app/modules/account/controllers/account_controller.dart';
import 'package:resikan_app/app/modules/history/controllers/history_controller.dart';
import 'package:resikan_app/app/modules/home/controllers/home_controller.dart';
import 'package:resikan_app/app/modules/navigation/controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<ServiceController>(ServiceController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
