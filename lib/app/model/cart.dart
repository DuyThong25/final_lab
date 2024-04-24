import 'package:flutter_cart/flutter_cart.dart';
import 'package:lab10/app/page/product/productwidget.dart';


void addToCart(ProductModel product) {
  var cart = FlutterCart();
  ProductVariant variant = ProductVariant(price: product.price);
  cart.addToCart(
      cartModel: CartModel(
    productId: product.id.toString(),
    productName: product.name,
    variants: [variant],
    productImages: [product.imageURL!],
    productDetails: product.desc!,
  ));
  print(cart.cartLength);
}
