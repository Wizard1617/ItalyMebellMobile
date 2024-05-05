class ProductComment {
  final int id;
  final int mark;
  final String description;
  final String createdAt;
  final String updatedAt;
  final int idProduct;
  final String emailUser;

  ProductComment({
    required this.id,
    required this.mark,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.idProduct,
    required this.emailUser,
  });

  factory ProductComment.fromJson(Map<String, dynamic> json) {
    return ProductComment(
      id: json['id_product_comment'],
      mark: json['mark_comment'],
      description: json['description_comment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      idProduct: json['id_product'],
      emailUser: json['email_user'],
    );
  }
}
