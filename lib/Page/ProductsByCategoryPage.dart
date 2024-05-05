import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Models/Product.dart';
import 'package:mebel_shop/Page/ProductDetailsPage.dart';
import 'package:mebel_shop/Service/AuthService.dart';

class ProductsByCategoryPage extends StatefulWidget {
  final int categoryId;

  const ProductsByCategoryPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<ProductsByCategoryPage> createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory(widget.categoryId);
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    try {
      var response = await Dio().get('$api/api/product/', queryParameters: {"id_category": categoryId});
      var productData = response.data['rows'] as List;
      List<Product> productList = productData.map((json) => Product.fromJson(json)).toList();
      setState(() {
        products = productList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Товары по категории'),
      ),
      body: GridView.builder(
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

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: Card(
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
                        width: MediaQuery.of(context).size.width / 2 - 10, // Ширина изображения равна половине ширины экрана
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
                        Text(
                          'Подробнее',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}
