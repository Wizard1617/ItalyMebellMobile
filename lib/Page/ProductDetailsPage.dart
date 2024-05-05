import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Models/Product.dart';
import 'package:mebel_shop/Models/ProductComment.dart';
import 'package:mebel_shop/Models/UserProfile.dart';
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
  bool isPhoto = false;
  String? emailUser;
  List<ProductComment> _comments = [];
  TextEditingController _descriptionController = TextEditingController();
  int _ratingValue = 3; // Начальное значение рейтинга
  String _commentDescription = '';

  List<String> _productImages = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadProductComments();
    _productImages.add(widget.product.imageUrl);

    _fetchProductImages(widget.product.id).then((images) {
      setState(() {
        if(isPhoto)

        _productImages = images;
        _productImages.add(widget.product.imageUrl);

      });
    }).catchError((error) {
      print('Error loading product images: $error');
    });
  }

  _loadProductComments() async {
    try {
      List<ProductComment> comments =
          await fetchProductComments(widget.product.id);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      print('Error loading product comments: $e');
    }
  }

  _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      emailUser = prefs.getString('email_user');
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
          "email_user": emailUser, // Получите почту пользователя откуда-то
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

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData iconData = rating >= i + 1 ? Icons.star : Icons.star_border;
      stars.add(Icon(iconData, color: Colors.yellow));
    }
    return Row(children: stars);
  }

  Widget _buildRating(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData iconData = rating >= i + 1 ? Icons.star : Icons.star_border;
      stars.add(Icon(iconData, color: Colors.yellow));
    }
    return Row(children: stars);
  }

  Future<List<ProductComment>> fetchProductComments(int productId) async {
    try {
      final response = await Dio().get('$api/api/product_comment/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        List<ProductComment> allComments =
            data.map((comment) => ProductComment.fromJson(comment)).toList();
        List<ProductComment> filteredComments = allComments
            .where((comment) => comment.idProduct == productId)
            .toList();
        return filteredComments;
      } else {
        throw Exception('Failed to load product comments');
      }
    } catch (e) {
      print('Error fetching product comments: $e');
      throw Exception('Failed to load product comments');
    }
  }

  Future<UserProfile> fetchUserProfile(String email) async {
    try {
      final response = await Dio().get('$api/api/user_profile/$email');
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Failed to load user profile');
    }
  }

  Future<List<String>> _fetchProductImages(int productId) async {
    try {
      final response =
          await Dio().get('$api/api/product_image/?id_product=$productId');
      if (response.statusCode == 200) {
        if(response.data == null){
         isPhoto == false;
         return [];

        }
        else {
          isPhoto = true;
          final List<dynamic> data = response.data;

          List<String> imageUrls =
          data.map((image) => image['url_image'] as String).toList();
          return imageUrls;
        }

      } else {
        throw Exception('Failed to load product images');
      }
    } catch (e) {
      print('Error fetching product images: $e');
      throw Exception('Failed to load product images');
    }
  }

  void _addProductComment() async {
    if (_commentDescription.isEmpty) {
      // Проверка на пустое описание
      return;
    }

    try {
      // Отправка запроса на сервер
      var response = await Dio().post(
        '$api/api/product_comment/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "mark_comment": _ratingValue.toString(),
          "description_comment": _commentDescription,
          "id_product": widget.product.id.toString(),
          "email_user": emailUser,
        },
      );

      if (response.statusCode == 200) {
        // Обработка успешного ответа
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Отзыв успешно добавлен")),
        );
        // Очистка полей ввода
        _descriptionController.clear();
        setState(() {
          // Обновление списка отзывов
          _loadProductComments();
        });
      } else {
        // Обработка ошибки
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка при добавлении отзыва")),
        );
      }
    } catch (e) {
      print(e);
      // Обработка ошибки сети
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Отзыв успешно добавлен")),
      );
      // Очистка полей ввода
      _descriptionController.clear();
      setState(() {
        // Обновление списка отзывов
        _loadProductComments();
      });
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
                if (_productImages.isNotEmpty && isPhoto == true) ...[

                  SizedBox(
                    height: 200, // Высота списка фотографий
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      // Прокрутка по горизонтали
                      itemCount: _productImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            '$api/${_productImages[index]}',
                            width: 150, // Ширина каждой фотографии
                            height: 150, // Высота каждой фотографии
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),

                ]
                else ...[
                  SizedBox(
                    height: 200, // Высота списка фотографий
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // Прокрутка по горизонтали
                      itemCount: _productImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            '$api/${_productImages[index]}',
                            width: 150, // Ширина каждой фотографии
                            height: 150, // Высота каждой фотографии
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                                  style: Theme.of(context).textTheme.headline5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Артикул: ' + widget.product.articleProduct,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${widget.product.price} ₽',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Рейтинг:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                _buildRatingStars(widget.product.rating),
                                SizedBox(height: 10),
                                if (widget.product.attributes != null)
                                  Text(
                                    'Атрибуты: ${widget.product.attributes!.join(", ")}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                SizedBox(height: 10),
                                if (widget.product.specifications != null)
                                  Text(
                                    'Спецификации: ${widget.product.specifications!.join(", ")}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Описание: ' + widget.product.description,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _addToCart();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue[700], // цвет текста
                          minimumSize: Size(
                              double.infinity, 50), // минимальный размер кнопки
                        ),
                        child:
                            Text('В корзину', style: TextStyle(fontSize: 18)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'Добавить отзыв:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Описание отзыва',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _commentDescription = value;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Рейтинг:'),
                          Slider(
                            value: _ratingValue.toDouble(),
                            // Преобразуйте int в double
                            onChanged: (double newValue) {
                              setState(() {
                                _ratingValue = newValue
                                    .toInt(); // Преобразуйте double в int
                              });
                            },
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: _ratingValue.toString(),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _addProductComment();
                            },
                            child: Text('Добавить отзыв'),
                          ),
                        ],
                      ),
                      if (_comments.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            'Отзывы о товаре:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          children: _comments.map((comment) {
                            return FutureBuilder<UserProfile>(
                              future: fetchUserProfile(comment.emailUser),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Или другой индикатор загрузки
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Ошибка загрузки профиля пользователя');
                                } else {
                                  final userProfile = snapshot.data;
                                  final userAvatarUrl =
                                      '$api/user_photo/${userProfile?.imageUserProfile ?? ''}';
                                  final avatarWidget =
                                      userProfile?.imageUserProfile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(userAvatarUrl),
                                            )
                                          : CircleAvatar(
                                              child: Text(
                                                '${userProfile?.firstNameUser?.isNotEmpty ?? false ? userProfile!.firstNameUser![0] : ''}${userProfile?.secondNameUser?.isNotEmpty ?? false ? userProfile!.secondNameUser![0] : ''}',
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            );
                                  return ListTile(
                                    leading: avatarWidget,
                                    title: Text(comment.description),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildRating(comment.mark),
                                        Text(
                                            'Пользователь: ${userProfile?.firstNameUser ?? 'Неизвестно'} ${userProfile?.secondNameUser ?? 'Неизвестно'}'),
                                        // Другие детали отзыва, такие как дата, могут быть добавлены здесь
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
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
