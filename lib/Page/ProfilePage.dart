import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/CartPage.dart';
import 'package:mebel_shop/Page/LoginPage.dart';
import 'package:mebel_shop/Page/OrdersPage.dart';
import 'package:mebel_shop/Page/ProductCommentsPage.dart';
import 'package:mebel_shop/Page/SettingsPage.dart';
import 'package:mebel_shop/Page/UserProfileEditPage.dart';
import 'package:mebel_shop/Service/AuthService.dart';
import 'package:mebel_shop/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userAvatarUrl = 'https://via.placeholder.com/150';
  String firstName = '';
  String secondName = '';

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
          userAvatarUrl = '$api/user_photo/${response.data['image_user_profile'] ?? 'https://via.placeholder.com/150'}';
          firstName = response.data['first_name_user'] ?? '';
          secondName = response.data['second_name_user'] ?? '';
        });
      } else {
        print('Ошибка получения профиля: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при выполнении запроса: $e');
    }
  }

  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Очистка всех данных
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> _refreshData() async {
    await fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'Выход':
                  await logOut(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Выход'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userAvatarUrl),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 10),
              Text(
                '${firstName.isNotEmpty ? firstName : ''} ${secondName.isNotEmpty ? secondName : ''}',
                style: TextStyle(fontSize: 20),
              ),

              Text(
                email_user!,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfileEditPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Изменить данные'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Действия при нажатии на кнопку "Смена пароля"
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Смена пароля'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Заказы'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Корзина'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.rate_review),
                title: Text('Отзывы'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductCommentsPage()),
                  );                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
