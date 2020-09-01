import 'package:get/get.dart';
import 'package:getx_pattern/app/bindings/details_binding.dart';
import 'package:getx_pattern/app/ui/android/auth_screen/auth_screen.dart';
import 'package:getx_pattern/app/ui/android/details/details_page.dart';
import 'package:getx_pattern/app/ui/android/orders_screen/orders_screen.dart';
import 'package:getx_pattern/app/ui/android/products_overview/widgets/product_details.dart';
import 'package:getx_pattern/app/ui/android/user_products_screen/edit_products_screen.dart';
import 'package:getx_pattern/app/ui/android/user_products_screen/user_products_screen.dart';
import '../ui/android/products_overview/products_overview.dart';
import '../ui/android/cart_screen/cart_screen.dart';
part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => ProductsOverviewScreen(),
    ),
    GetPage(
        name: Routes.DETAILS,
        page: () => DetailsPage(),
        binding: DetailsBinding()),
    GetPage(
      name: Routes.PRODUCTDETAIL,
      page: () => ProductDetailScreen(),
    ),
    GetPage(
      name: Routes.CARTSCREEN,
      page: () => CartScreen(),
    ),
    GetPage(
      name: Routes.ORDERSCREEN,
      page: () => OrdersScreen(),
    ),
    GetPage(
      name: Routes.USERPRODUCTSSCREEN,
      page: () => UserProductsScreen(),
    ),
    GetPage(
      name: Routes.EDITPRODUCTSSCREEN,
      page: () => EditProductScreen(),
    ),
    GetPage(
      name: Routes.AUTHSCREEN,
      page: () => AuthScreen(),
    ),
  ];
}
