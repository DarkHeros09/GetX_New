import 'dart:convert';
import 'dart:async';

import 'package:get/get.dart';
import 'package:getx_pattern/app/controller/auth/app_setting_storage.dart';
import '../../data/model/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class Auth extends GetxController {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  final AppSettingsStorage box = Get.put(AppSettingsStorage(), permanent: true);

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCuld43SFS6iBZXa7t5Fyow2SpY1NM-ZeI';
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      update();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      box.token = userData;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    if (!box.hasToken) {
      return false;
    }
    final extractedUserData = jsonDecode(box.token) as Map<String, Object>;
    final expiryData = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryData;
    update();
    _autoLogout();
    return true;
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    update();
    box.deleteToken();
    print(box.token);
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
