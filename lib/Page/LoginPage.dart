import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/MainScreen.dart';
import 'package:mebel_shop/Page/ProductsPage.dart';
import 'package:mebel_shop/Page/RegistrationPage.dart';
import 'package:mebel_shop/Service/AuthService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              'Авторизация',
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

                var token = await AuthService().login(email, password);
                if (token != null) {
                  print("Авторизация прошла успешно, токен: $token");
                  // Переход на страницу товаров
                  Navigator.pushReplacement( // Используйте pushReplacement, чтобы предотвратить возврат на страницу входа
                    context,
                    MaterialPageRoute(builder: (context) => ProductsPage()),
                  );
                } else {
                  print("Ошибка авторизации");
                  // Отображение сообщения об ошибке пользователю
                }
              },
              child: Text('Авторизация'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
