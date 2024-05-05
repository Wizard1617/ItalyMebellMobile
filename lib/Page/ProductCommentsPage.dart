import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/EditCommentModal.dart';
import 'package:mebel_shop/Service/AuthService.dart';
import 'package:mebel_shop/main.dart';

class ProductCommentsPage extends StatefulWidget {
  @override
  _ProductCommentsPageState createState() => _ProductCommentsPageState();
}
class _ProductCommentsPageState extends State<ProductCommentsPage> {
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final response = await Dio().get('$api/api/product_comment/');
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> allComments = List<Map<String, dynamic>>.from(response.data);
        final filteredComments = allComments.where((comment) => comment['email_user'] == email_user).toList();
        setState(() {
          _comments = filteredComments;
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('Error loading comments: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchProductInfo(int productId) async {
    try {
      final response = await Dio().get('$api/api/product/');
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(response.data['rows']);
        final productInfo = products.firstWhere((product) => product['id_product'] == productId, orElse: () => {});
        return productInfo;
      } else {
        throw Exception('Failed to load product info');
      }
    } catch (e) {
      print('Error loading product info: $e');
      return {};
    }
  }

  Widget _buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData iconData = rating >= i + 1 ? Icons.star : Icons.star_border;
      stars.add(Icon(iconData, color: Colors.yellow));
    }
    return Row(children: stars);
  }

  void _openEditModal(BuildContext context, Map<String, dynamic> comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCommentModal(
          comment: comment,
          initialRating: comment['mark_comment'],
        );
      },
    );
  }

  void _deleteComment(int commentId) async {
    try {
      final response = await Dio().delete(
        '$api/api/product_comment/$commentId',
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Успешно удалено
        // Можно выполнить какие-то действия, например, обновить список отзывов
        _loadComments();
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      _loadComments();
      // Обработка ошибки, например, показать сообщение пользователю
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отзывы о товаре'),
      ),
      body: ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          final comment = _comments[index];
          return ListTile(
            title: Text(comment['description_comment']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingStars(comment['mark_comment']),
                FutureBuilder<Map<String, dynamic>>(
                  future: _fetchProductInfo(comment['id_product']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Ошибка загрузки информации о продукте');
                    } else {
                      final productInfo = snapshot.data ?? {};
                      return Text('Продукт: ${productInfo['name_product'] ?? 'Неизвестно'}');
                    }
                  },
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteComment(comment['id_product_comment']);
              },
            ),
            onTap: () {
              _openEditModal(context, comment);
            },
          );
        },
      ),
    );
  }
}
