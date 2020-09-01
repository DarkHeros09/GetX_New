import 'package:get/get.dart';
import 'app_setting_storage.dart';

Future<void> initializeAppServices() async {
  await Get.put(AppSettingsStorage()).init();
}
