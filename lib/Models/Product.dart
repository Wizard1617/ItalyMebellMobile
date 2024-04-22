class Product {
  final int id;
  late final int? count_product;
  final String name;
  final String price;
  final String imageUrl;
  final String description;
  final String article_product;
  int userSelectedCount = 1; // Количество выбранное пользователем


  Product({
    required this.id,
     this.count_product,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.article_product,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_product'],
      name: json['name_product'],
      price: json['price_product'],
      count_product: json['count_product'],
      imageUrl: json['url_main_image_product'],
      description: json['description_product'],
      article_product: json['article_product'],

    );
  }
}
