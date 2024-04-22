import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Models/Product.dart';
import 'package:mebel_shop/Service/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? token;
  String? email_user;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      email_user = prefs.getString('email_user');
    });
  }

  _addToCart() async {
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Вы не авторизованы")),
      );
      return;
    }

    try {
      var response = await Dio().post(
        '$api/api/cart/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "id_product": widget.product.id.toString(),
          "email_user": email_user // Получите почту пользователя откуда-то
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Товар добавлен в корзину")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка добавления в корзину")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка сети")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50.0),
            // Добавляем отступ для кнопки
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: Image.network(
                    '$api/${widget.product.imageUrl}',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('Артикул: ' + widget.product.article_product,
                                    style: TextStyle(fontSize: 16)
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${widget.product.price} ₽',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Описание: ' + widget.product.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16)
                      ),
                      // Можно добавить другие детали о продукте
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _addToCart();
                  },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue[700], // цвет текста
                  minimumSize: Size(
                      double.infinity, 50), // минимальный размер кнопки
                ),
                child: Text('В корзину', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
