import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/controller/auth/auth.dart';
import 'package:getx_pattern/app/ui/android/splash_screen/splash_screen.dart';
import 'package:http/http.dart';
import 'app/ui/android/auth_screen/auth_screen.dart';
import 'package:getx_pattern/app/ui/android/products_overview/products_overview.dart';
import 'app/controller/auth/app_services.dart';

import 'app/routes/app_pages.dart';
import 'app/ui/theme/app_theme.dart';

void main() async {
  final Auth auth = Get.put(Auth());
  await initializeAppServices();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: '/auth-screen',
      theme: appThemeData,
      defaultTransition: Transition.fade,
      getPages: AppPages.pages,
      home: GetBuilder(
        init: auth,
        builder: (ctx) => auth.isAuth
            ? ProductsOverviewScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen()),
      ),
    ),
  );
}
