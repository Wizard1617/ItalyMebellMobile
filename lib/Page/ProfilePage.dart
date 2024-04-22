import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/CartPage.dart';
import 'package:mebel_shop/Page/OrdersPage.dart';
import 'package:mebel_shop/Page/SettingsPage.dart';
import 'package:mebel_shop/Service/AuthService.dart';
import 'package:mebel_shop/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Замените эти значения на данные пользователя
   String userAvatarUrl = 'https://via.placeholder.com/150';


    @override
    void initState() {
      super.initState();
      fetchUserProfile();
    }

    Future<void> fetchUserProfile() async {
      try {
        var response = await Dio().get('$api/api/user_profile/$email_user');
        if (response.statusCode == 200) {
          setState(() {
            userAvatarUrl = '$api/user_photo/${response.data['image_user_profile']}';
          });
        } else {
          print('Ошибка получения профиля: ${response.statusCode}');
        }
      } catch (e) {
        print('Ошибка при выполнении запроса: $e');
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Settings':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50, // Размер аватарки
            backgroundImage: NetworkImage(userAvatarUrl),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(height: 10),
          Text(
            email_user!,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Заказы'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersPage()), // Переход на страницу корзины
              );            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Корзина'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()), // Переход на страницу корзины
              );
            },
          ),
          // Расширение списка можно реализовать добавлением новых ListTile
        ],
      ),
    );
  }
}
