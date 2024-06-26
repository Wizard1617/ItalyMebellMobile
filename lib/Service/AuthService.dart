import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String api = "http://192.168.1.69:5000";

class AuthService {
  Dio dio = new Dio();

  Future<void> registerAndCreateCart(String email, String password) async {
    try {
      // Регистрация пользователя
      final String? token = await register(email, password);

      if (token != null) {
        // Успешно зарегистрирован, отправляем запрос на создание корзины
        await createCart(email, token);
      } else {
        // Если токен не получен, обработка ошибки регистрации
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error during registration and cart creation: $e');
      // Обработка ошибки, например, показ сообщения пользователю
    }
  }

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

  Future<void> createCart(String email, String token) async {
    try {
      Response response = await dio.post(
        '$api/api/cart/create',
        data: {"email_user": email},
        options: Options(
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token", // Передача токена в заголовке
          },
        ),
      );
      if (response.statusCode == 200) {
        // Корзина успешно создана
        print('Cart created successfully');
      } else {
        throw Exception('Failed to create cart');
      }
    } catch (e) {
      print('Error creating cart: $e');
      // Обработка ошибки, например, показ сообщения пользователю
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
