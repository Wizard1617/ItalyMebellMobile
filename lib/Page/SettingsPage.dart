import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/LoginPage.dart';
import 'package:mebel_shop/Page/UserProfileEditPage.dart';  // Make sure you have this page created
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Очистка всех данных
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()), // Переход на страницу входа
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Настройки"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserProfileEditPage()), // Navigate to UserProfileEditPage
                );
              },
              child: Text('Редактировать профиль'),
            ),
            SizedBox(height: 20), // Provide some spacing between the buttons
            ElevatedButton(
              onPressed: () async {
                // Вызов функции выхода
                await logOut(context);
              },
              child: Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
    );
  }
}
