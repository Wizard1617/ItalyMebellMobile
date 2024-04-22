import 'package:mebel_shop/Models/Product.dart';

class CartProduct {
  int idCartProduct;
  int countCartProduct;
  Product product;

  CartProduct({
    required this.idCartProduct,
    required this.countCartProduct,
    required this.product,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      idCartProduct: json['id_cart_product'],
      countCartProduct: json['count_cart_product'],
      product: Product.fromJson(json['product']),
    );
  }
}
