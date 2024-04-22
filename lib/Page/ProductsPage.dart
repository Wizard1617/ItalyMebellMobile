import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Models/Category.dart';
import 'package:mebel_shop/Models/Product.dart';
import 'package:mebel_shop/Page/CartPage.dart';
import 'package:mebel_shop/Page/ProductDetailsPage.dart';
import 'package:mebel_shop/Page/ProfilePage.dart';
import 'package:mebel_shop/Service/AuthService.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Category> categories = [];
  List<Product> products = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      var response = await Dio().get('$api/api/category/');
      var receivedCategories = List.from(response.data)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
      setState(() {
        categories = receivedCategories;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchProducts(int categoryId) async {
    try {
      var response = await Dio().get('$api/api/product/', queryParameters: {"id_category": categoryId, "limit": 10, "page": 1});
      var productData = response.data['rows'] as List;
      List<Product> productList = productData.map((json) => Product.fromJson(json)).toList();
      setState(() {
        products = productList;
        selectedCategoryId = categoryId; // Обновляем выбранную категорию
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2 - 10; // Вычитаем 10 для отступов

    return Scaffold(
      appBar: AppBar(
        title: Text('Товары'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Открывает страницу профиля
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()), // Замените на актуальное имя вашей страницы профиля
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Открывает страницу профиля
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()), // Замените на актуальное имя вашей страницы профиля
              );
            },
          ),

        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => fetchProducts(categories[index].id),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(20),
                      border: selectedCategoryId == categories[index].id ? Border.all(color: Colors.amber, width: 2) : null,
                    ),
                    child: Center(
                      child: Text(
                        categories[index].name,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Вставьте внутри метода build в вашем ListView.builder
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Количество столбцов
                crossAxisSpacing: 4.0, // Отступ по горизонтали
                mainAxisSpacing: 4.0, // Отступ по вертикали
                childAspectRatio: 1 / 1.5, // Соотношение сторон карточек
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                  final imageUrl = '$api/${product.imageUrl}';

                return Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Image.network(
                            imageUrl,
                            width: width, // Ширина изображения равна половине ширины экрана
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${product.price} ₽',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(product: products[index]),
                                  ),
                                );
                              },
                              child: Text('Подробнее', style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}
