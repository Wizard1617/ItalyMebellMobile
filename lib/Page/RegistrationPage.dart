import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/LoginPage.dart';
import 'package:mebel_shop/Service/AuthService.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Dio dio = Dio();
  Future<bool> registerAndCreateCart(String email, String password) async {
    try {
      // Регистрация пользователя
      final String? token = await register(email, password);

      if (token != null) {
        // Успешно зарегистрирован, отправляем запрос на создание корзины
        await createCart(email, token);
        return true;

      } else {
        // Если токен не получен, обработка ошибки регистрации
        return false;

      }
    } catch (e) {
      print('Error during registration and cart creation: $e');
      return false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мебельный магазин'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Регистрация',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground
              ),
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;

                bool success = await registerAndCreateCart(email, password);
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  print("Ошибка регистрации");
                  // Здесь можно добавить обработку ошибки регистрации, если нужно
                }
              },
              child: Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}
