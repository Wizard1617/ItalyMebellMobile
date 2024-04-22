import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mebel_shop/Service/AuthService.dart';
import 'package:mebel_shop/main.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {


    try {
      var response = await Dio().get('$api/api/orders/');
      if (response.statusCode == 200) {
        List<dynamic> allOrders = response.data as List<dynamic>;
        setState(() {
          // Фильтруем заказы по email пользователя
          orders = allOrders.where((order) =>
          order['order_address']['email_user'] == email_user
          ).toList();
        });
      } else {
        print('Ошибка получения заказов: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при выполнении запроса: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои заказы'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var order = orders[index];
          return ListTile(
            title: Text('Заказ №${order['number_order']}'),
            subtitle: Text('Сумма: ${order['price_order']}₽\nДата заказа: ${order['date_order']}'),
            onTap: () {
              // Здесь можно реализовать переход к деталям заказа, если нужно
            },
          );
        },
      ),
    );
  }
}
