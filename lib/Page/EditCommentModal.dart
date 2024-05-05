import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mebel_shop/Service/AuthService.dart';

class EditCommentModal extends StatefulWidget {
  final Map<String, dynamic> comment;
  final int initialRating;

  EditCommentModal({required this.comment, required this.initialRating});

  @override
  _EditCommentModalState createState() => _EditCommentModalState();
}

class _EditCommentModalState extends State<EditCommentModal> {
  int _rating = 0; // Переменная для хранения новой оценки отзыва
  String _newComment = ''; // Переменная для хранения нового комментария

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _newComment = widget.comment['description_comment'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Редактировать отзыв'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRatingStars(_rating), // Вывод звёздочек
          TextFormField(
            initialValue: _newComment,
            onChanged: (value) {
              setState(() {
                _newComment = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Комментарий',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            _editComment(); // Метод для отправки запроса на редактирование отзыва
            Navigator.pop(context);
          },
          child: Text('Сохранить'),
        ),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData iconData = rating >= i + 1 ? Icons.star : Icons.star_border;
      stars.add(Icon(iconData, color: Colors.yellow));
    }
    return Row(children: stars);
  }

  void _editComment() async {
    try {
      // Отправка запроса на редактирование отзыва
      final response = await Dio().put(
        '$api/api/product_comment/${widget.comment['id_product_comment']}',
        data: {
          "mark_comment": _rating.toString(),
          "description_comment": _newComment,
          "id_product": widget.comment['id_product'],
          "email_user": widget.comment['email_user'],
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Успешно отредактировано
        // Можно выполнить какие-то действия, например, обновить UI или показать сообщение об успешном сохранении
      } else {
        throw Exception('Failed to edit comment');
      }
    } catch (e) {
      print('Error editing comment: $e');
      // Обработка ошибки, например, показать сообщение пользователю
    }
  }
}
