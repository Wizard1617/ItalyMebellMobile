import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String api = "http://192.168.1.69:5000";

class AuthService {
  Dio dio = new Dio();

  Future<String?> register(String email, String password) async {
    try {
      Response response = await dio.post(
        '$api/api/user_profile/registration',
        data: {"email_user": email, "password_user": password},
        options: Options(
          headers: {"accept": "application/json", "Content-Type": "application/json"},
        ),
      );
      if (response.statusCode == 200) {
        return response.data["token"];
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      Response response = await dio.post(
        '$api/api/user_profile/login',
        data: {"email_user": email, "password_user": password},
        options: Options(
          headers: {"accept": "application/json", "Content-Type": "application/json"},
        ),
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data["token"]);
        await prefs.setString('email_user', email);
        return response.data["token"];

      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
