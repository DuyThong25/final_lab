// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cart/cart.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:intl/intl.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/model/user.dart';
import 'package:lab10/app/route/billwidget.dart';
import 'package:lab10/app/route/productwidget.dart';
import 'package:lab10/mainpage.dart';

class CartDefault extends StatefulWidget {
  const CartDefault(
      {super.key, required this.listCartItems, required this.user});
  final List<CartModel> listCartItems;
  final User user;

  @override
  State<CartDefault> createState() => _CartDefaultState();
}

class _CartDefaultState extends State<CartDefault> {
  int totalItem = 0;
  var formatCurrency = NumberFormat.simpleCurrency(locale: 'vi');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.listCartItems.isNotEmpty) {
      widget.listCartItems.forEach((item) => totalItem += item.quantity);
    }
  }

  updateTotalQuantity() {
    totalItem = 0;
    widget.listCartItems.forEach((item) => totalItem += item.quantity);
  }

  showAlertDialog(onDelete, bool isDeleteAll, CartModel? product) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    if (isDeleteAll) {
                      onDelete();
                      setState(() {
                        updateTotalQuantity();
                      });
                      showToastMessage("Xóa tất cả thành công !");
                    } else {
                      onDelete(product!.productId, product.variants);
                      setState(() {
                        updateTotalQuantity();
                      });
                      showToastMessage("Xóa một sản phẩm thành công !");
                    }
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.listCartItems.isEmpty
        ? Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProductDefault(
                      user: widget.user,
                    ),
                  ),
                ).then((value) => {setState(() {})});
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.only(left: 10, right: 10))),
              child: const Text(
                "+ Giỏ hàng trống !!",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          )
        : Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Giỏ hàng'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ProductDefault(
                                    user: widget.user,
                                  ),
                                ),
                              ).then((value) => {setState(() {})});
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green),
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.only(left: 10, right: 10))),
                            child: const Text(
                              "Sản phẩm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.white,
                            ),
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red),
                            ),
                            label: const Text(
                              "Xóa tất cả",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              showAlertDialog(
                                  FlutterCart().clearCart, true, null);
                            },
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.listCartItems.length,
                      padding: const EdgeInsets.only(bottom: 60),
                      itemBuilder: (context, index) {
                        var item = widget.listCartItems[index];
                        return itemCard(item, index);
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Số lượng:",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              totalItem.toString(),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tổng cộng:",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatCurrency.format(FlutterCart().total),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            print(" gửi api bill");
                            var respone = await APIRepository()
                                .sendBill(widget.listCartItems);
                            if (respone != "add bill fail") {
                              showToastMessage("Đặt hàng thành công");
                              FlutterCart().clearCart();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const Mainpage(
                              //         selectedIndex: 1,
                              //       ),
                              //     ));
                              setState(() {});
                            } else {}
                          },
                          icon: const Icon(Icons.check_circle_outline_outlined),
                          label: const Text(
                            "Đặt hàng",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21),
                          ),
                          style: ButtonStyle(
                              iconSize: const MaterialStatePropertyAll(30),
                              iconColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blue.shade900)),
                        ),
                      )
                    ],
                  )),
            ],
          );
  }
// Container(

  Widget itemCard(CartModel item, index) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Màu của đường viền
            width: 1.0, // Độ rộng của đường viền
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.productName.toString()),
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 30,
              alignment: Alignment.center,
              color: Colors.red,
              onPressed: () {
                print("Xóa 1 item");
                showAlertDialog(FlutterCart().removeItem, false, item);
              },
              icon: const Icon(Icons.highlight_remove_sharp),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatCurrency.format(item.variants.first.price),
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    int currentQuantityProductInCart = item.quantity;
                    FlutterCart().updateQuantity(item.productId, item.variants,
                        currentQuantityProductInCart - 1);
                    showToastMessage("Xóa số lượng thành công");

                    setState(() {
                      updateTotalQuantity();
                    });
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.blue.shade900,
                    size: 24,
                  ),
                ),
                Text(
                  item.quantity.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    int currentQuantityProductInCart = item.quantity;
                    FlutterCart().updateQuantity(item.productId, item.variants,
                        currentQuantityProductInCart + 1);
                    showToastMessage("Thêm số lượng thành công");
                    setState(() {
                      updateTotalQuantity();
                    });
                  },
                  icon: Icon(
                    Icons.add_circle_outline_sharp,
                    color: Colors.blue.shade900,
                    size: 24,
                  ),
                ),
              ],
            )
          ],
        ),
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: (item.productImages!.first == null ||
                    item.productImages!.first == "")
                ? BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(10))
                : BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
            height: 65,
            width: 65,
            child: (item.productImages!.first == null ||
                    item.productImages!.first == "")
                ? const Icon(
                    Icons.image,
                    size: 35,
                  )
                : Image.network(
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    item.productImages!.first,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image,
                          size: 35,
                        )),
          ),
        ),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
