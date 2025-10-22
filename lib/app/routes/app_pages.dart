import 'package:get/get.dart';

import '../modules/app_settings/bindings/app_settings_binding.dart';
import '../modules/app_settings/views/app_settings_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/search_product/bindings/search_product_binding.dart';
import '../modules/search_product/views/search_product_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),

    // Nested Navigation
    // GetPage(
    //   name: _Paths.PRODUCT,
    //   page: () => const ProductView(),
    //   binding: ProductBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CART,
    //   page: () => const CartView(),
    //   binding: CartBinding(),
    // ),
    // GetPage(
    //   name: _Paths.SEARCH_PRODUCT,
    //   page: () => const SearchProductView(),
    //   binding: SearchProductBinding(),
    // ),
    // GetPage(
    //   name: _Paths.APP_SETTINGS,
    //   page: () => const AppSettingsView(),
    //   binding: AppSettingsBinding(),
    // ),
  ];
}
