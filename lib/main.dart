import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/BottomNavigationPage.dart';
import 'package:mebel_shop/Page/ProductsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mebel_shop/Page/LoginPage.dart';
import 'package:mebel_shop/Page/MainScreen.dart'; // Убедитесь, что путь к MainScreen корректен
String? email_user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Обязательно для асинхронных операций перед runApp
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  email_user = prefs.getString('email_user');

  runApp(MyApp(startPage: token == null ? LoginPage() : BottomNavigationPage()));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  MyApp({required this.startPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мебельный магазин',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: startPage, // Стартовая страница в зависимости от наличия токена
    );
  }
}
