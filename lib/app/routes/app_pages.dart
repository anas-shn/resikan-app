import 'package:get/get.dart';

import '../modules/account/views/account_view.dart';
import '../modules/account/views/edit_profile_view.dart';
import '../modules/address/bindings/address_binding.dart';
import '../modules/address/views/address_list_view.dart';
import '../modules/address/views/address_form_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/booking/views/create_booking_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/history_detail/bindings/history_detail_binding.dart';
import '../modules/history_detail/views/history_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/service/bindings/service_binding.dart';
import '../modules/service/views/service_view.dart';
import '../modules/service/views/service_detail_view.dart';
import '../modules/subscription/bindings/subscription_binding.dart';
import '../modules/subscription/views/subscription_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => const NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION,
      page: () => const SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(name: _Paths.ACCOUNT, page: () => const AccountView()),
    GetPage(name: _Paths.EDIT_PROFILE, page: () => const EditProfileView()),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE,
      page: () => const ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_BOOKING,
      page: () => const CreateBookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_DETAIL,
      page: () => const ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_LIST,
      page: () => const ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_DETAIL,
      page: () => const ServiceDetailView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_DETAIL,
      page: () => const HistoryDetailView(),
      binding: HistoryDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS_LIST,
      page: () => const AddressListView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS_ADD,
      page: () => const AddressFormView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS_EDIT,
      page: () => const AddressFormView(),
      binding: AddressBinding(),
    ),
  ];
}
