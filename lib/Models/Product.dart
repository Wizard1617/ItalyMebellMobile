class Product {
  final int id;
  final int? countProduct;
  final String name;
  final String price;
  final String imageUrl;
  final String description;
  final String articleProduct;
  final bool isEnabled;
  final String createdAt;
  final String updatedAt;
  final String idCategory;
  final double rating;
  final List<dynamic>? attributes;
  final List<dynamic>? attributeGroups;
  final List<dynamic>? specifications;
  int userSelectedCount = 1; // Количество выбранное пользователем

  Product({
    required this.id,
    this.countProduct,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.articleProduct,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.idCategory,
    required this.rating,
    this.attributes,
    this.attributeGroups,
    this.specifications,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_product'] ?? -1,
      countProduct: json['count_product'],
      name: json['name_product'] ?? '',
      price: json['price_product'] ?? '',
      imageUrl: json['url_main_image_product'] ?? '',
      description: json['description_product'] ?? '',
      articleProduct: json['article_product'] ?? '',
      isEnabled: json['is_enabled'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      idCategory: json['id_category'] ?? '',
      rating: json['rating'] != null ? double.parse(json['rating']) : 0.0,
      attributes: json['attributes'],
      attributeGroups: json['attribute_groups'],
      specifications: json['specifications'],
    );
  }

}
