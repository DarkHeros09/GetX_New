import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsStorage extends GetxService {
  GetStorage _box;

  static AppSettingsStorage get instance => Get.find<AppSettingsStorage>();
  bool _inited = false;

  Future<void> init() async {
    // avoid initializing multiple times.
    if (_inited) return;
    await GetStorage.init('settings');
    _box = GetStorage('settings');
    _inited = true;
  }

  // Theme stuffs
  set themeMode(ThemeMode mode) {
    _box.write(_BoxKeys.themeMode, ThemeMode.values.indexOf(mode));
  }

  ThemeMode get themeMode {
    final index = _box.read<int>(_BoxKeys.themeMode) ?? 0;
    return ThemeMode.values[index];
  }

  // Token stuffs
  set token(String value) => _box.write(_BoxKeys.token, value);
  String get token => _box.read(_BoxKeys.token);
  bool get hasToken => token != null && token.isNotEmpty;
  void deleteToken() => _box.erase();
}

// use a class to keep ur keys consistent.
abstract class _BoxKeys {
  static const token = 'userData';
  static const themeMode = 'themeMode';
}
