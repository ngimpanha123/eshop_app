import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/admin_product/bindings/admin_product_binding.dart';
import '../modules/admin_product/views/admin_product_list_view.dart';
import '../modules/admin_user/bindings/admin_user_binding.dart';
import '../modules/admin_user/views/admin_user_list_view.dart';
import '../modules/admin_sales/bindings/admin_sales_binding.dart';
import '../modules/admin_sales/views/admin_sales_view.dart';
import '../modules/cashier_order/bindings/cashier_order_binding.dart';
import '../modules/cashier_order/views/cashier_order_view.dart';
import '../modules/cashier_sales/bindings/cashier_sales_binding.dart';
import '../modules/cashier_sales/views/cashier_sales_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/reports/views/reports_view.dart';
import '../modules/user/bindings/user_binding.dart';
import '../modules/user/views/user_view.dart';
import '../modules/cashier_order/views/product_list_view.dart';
import '../modules/cashier_order/views/cart_view.dart';
import '../modules/cashier_order/views/checkout_view.dart';

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
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      // No binding needed - DashboardController is initialized in HomeBinding
    ),
    GetPage(
      name: _Paths.ADMIN_PRODUCT,
      page: () => const AdminProductListView(),
      binding: AdminProductBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_USER,
      page: () => const AdminUserListView(),
      binding: AdminUserBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_SALES,
      page: () => const AdminSalesView(),
      binding: AdminSalesBinding(),
    ),
    GetPage(
      name: _Paths.CASHIER_ORDER,
      page: () => const CashierOrderView(),
      binding: CashierOrderBinding(),
    ),
    GetPage(
      name: _Paths.CASHIER_SALES,
      page: () => const CashierSalesView(),
      binding: CashierSalesBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListView(),
      binding: CashierOrderBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CashierOrderBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CashierOrderBinding(),
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
