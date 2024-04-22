import 'package:flutter/material.dart';
import 'package:mebel_shop/Service/AuthService.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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

                var token = await AuthService().register(email, password);
                if (token != null) {
                  print("Регистрация прошла успешно, токен: $token");
                  // Переход на другую страницу
                } else {
                  print("Ошибка регистрации");
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
