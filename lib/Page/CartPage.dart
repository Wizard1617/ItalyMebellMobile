import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mebel_shop/Models/CartProduct.dart';
import 'package:mebel_shop/Models/Product.dart';
import 'package:mebel_shop/Page/CheckoutPage.dart';
import 'package:mebel_shop/Service/AuthService.dart';
import 'package:mebel_shop/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartProduct> cartProducts = [];
  @override
  void initState() {
    super.initState();
    fetchCartProducts();
  }

  Future<void> updateProductCount(int productId, bool isIncrement) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Найти продукт в списке по ID и обновить его количество
    int productIndex = cartProducts.indexWhere((p) => p.product.id == productId);
    if (productIndex != -1) {
      CartProduct cartProduct = cartProducts[productIndex];
      int? currentCount = cartProduct.countCartProduct;

      currentCount = isIncrement ? currentCount + 1 : (currentCount > 1 ? currentCount - 1 : 1); // Предотвращаем уход в минус

      try {
        await Dio().put(
          '$api/api/cart/${cartProduct.idCartProduct}',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          data: {
            "count_cart_product": currentCount.toString(),
          },
        );

        setState(() {
          cartProducts[productIndex].countCartProduct = currentCount!;
        });
      } catch (e) {
        print(e);
      }
    }
  }


  double calculateTotal() {
    double total = 0.0;
    for (var cartProduct in cartProducts) {
      double price = double.tryParse(cartProduct.product.price) ?? 0.0;
      total += price * cartProduct.countCartProduct;
    }
    return total;
  }



  Future<void> fetchCartProducts() async {
    try {
      var response = await Dio().get('$api/api/cart/$email_user');
      var productsRaw = response.data['cart']['cart_products'] as List;
      setState(() {
        cartProducts = productsRaw.map((json) => CartProduct.fromJson(json)).toList();
      });
    } catch (e) {
      print(e);
    }
  }


  int calculateTotalItems() {
    int totalItems = 0;
    for (var cartProduct in cartProducts) {
      totalItems += cartProduct.countCartProduct;
    }
    return totalItems;
  }


  @override
  Widget build(BuildContext context) {
    double total = calculateTotal();
    int totalItems = calculateTotalItems();

    return Scaffold(
      appBar: AppBar(
        title: Text("Корзина"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final cartProduct = cartProducts[index];
                final product = cartProduct.product; // Получаем продукт из корзины
                final imageUrl = '$api/${product.imageUrl}';

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text('${product.price} ₽'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              color: cartProduct.countCartProduct < cartProduct.product.countProduct! ? Colors.blue : Colors.grey,
                              onPressed: () {
                                if (cartProduct.countCartProduct < cartProduct.product.countProduct!) {
                                  updateProductCount(cartProduct.product.id, true);
                                }
                              },
                            ),
                            Text('${cartProduct.countCartProduct}'),
                            IconButton(
                              icon: Icon(Icons.remove),
                              color: cartProduct.countCartProduct > 1 ? Colors.blue : Colors.grey,
                              onPressed: () {
                                if (cartProduct.countCartProduct > 1) {
                                  updateProductCount(cartProduct.product.id, false);
                                }
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          ),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Товаров: $totalItems шт.',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Итого: ${total.toStringAsFixed(2)} ₽',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, // Кнопка на всю ширину экрана
                  child: ElevatedButton(
                    onPressed: () {
                      double total = calculateTotal(); // Убедитесь, что это вызывается перед Navigator

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutPage(cartProducts: cartProducts, total: total)),
                      );


                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Цвет текста
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: Text(
                        'Оформить заказ', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
