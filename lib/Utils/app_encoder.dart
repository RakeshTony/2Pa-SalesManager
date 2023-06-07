import 'package:encrypt/encrypt.dart';
import 'package:twopa_sales_manager/Utils/app_settings.dart';
import 'package:twopa_sales_manager/main.dart';

class Encoder {
  Encoder._();
  static String encode(String params) {
    if (params.isEmpty) return "";
    final key = Key.fromUtf8(mPreference.value.userToken);
    final iv = IV.fromUtf8(mPreference.value.userIV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(params, iv: iv);
    return encrypted.base64;
  }

  static String decode(String data, {bool isLocalIv = false}) {
    if (data.isEmpty) return "";
    final key = Key.fromUtf8(mPreference.value.userToken);
    final iv =
        IV.fromUtf8(isLocalIv ? AppSettings.USER_IV : mPreference.value.userIV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = Encrypted.from64(data);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
