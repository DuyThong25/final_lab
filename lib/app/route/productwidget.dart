import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:intl/intl.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/model/cart.dart';
import 'package:lab10/app/model/user.dart';
import 'package:lab10/app/page/product/productwidget.dart';
import 'package:lab10/app/route/cartwidget.dart';
import 'package:lab10/app/route/product/pruductadd.dart';
import 'package:badges/badges.dart' as badges;
import 'package:lab10/mainpage.dart';

class ProductDefault extends StatefulWidget {
  const ProductDefault({super.key, required this.user, this.isAdmin = false});
  final User user;
  final isAdmin;
  @override
  State<ProductDefault> createState() => _ProductDefaultState();
}

class _ProductDefaultState extends State<ProductDefault> {
  int quantityCarrt = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityCarrt = FlutterCart().cartLength;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách sản phẩm"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: badges.Badge(
              badgeContent: Text(quantityCarrt.toString()),
              child: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const Mainpage(selectedIndex: 2,)
                  ),
                ).then((value) => {setState(() {})});
              
              },
              // Navigator.popUntil(context);
              
            ),
          )
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductAdd(accountID: widget.user.accountId!),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              backgroundColor: Colors.blue[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80)),
              tooltip: 'Thêm loại sản phẩm mới',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      body: FutureBuilder<List<ProductModel>>(
        future: APIRepository().getListProduct(widget.user.accountId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Hãy thêm sản phẩm vào nhé !!!",
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final itemCat = snapshot.data![index];
                  return _buildCategory(itemCat, index, context);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategory(ProductModel product, int index, BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: "vi");

    _onDelete() {
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
                      String accountId = widget.user.accountId!;
                      int idCategory = product.id!;
                      var respone = await APIRepository()
                          .removeProduct(idCategory, accountId);
                      if (respone != "remove fail") {
                        showToastMessage("Xóa thành công");
                        setState(() {});
                      } else {
                        showToastMessage("Xóa thất bại");
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: (product.imageURL == null ||
                            product.imageURL == "")
                        ? BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10))
                        : BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                    height: 60,
                    width: 60,
                    child: (product.imageURL == null || product.imageURL == "")
                        ? const Icon(
                            Icons.image,
                            size: 36,
                          )
                        : Image.network(
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                            product.imageURL!,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.image,
                                  size: 36,
                                )),
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '(${product.categoryName})',
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        product.desc ?? "",
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      formatCurrency.format(product.price),
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.isAdmin == true) ...[
                  IconButton(
                      onPressed: () {
                        _onDelete();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade900,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) => ProductAdd(
                                    isUpdate: true,
                                    productModel: product,
                                    accountID: widget.user.accountId!,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              )
                              .then((_) => setState(() {}));
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.yellow.shade800,
                      ))
                ] else ...[
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ElevatedButton.icon(
                    style: ButtonStyle(
                      iconColor:
                          MaterialStatePropertyAll(Colors.yellow.shade800),
                      fixedSize: const MaterialStatePropertyAll(Size(20, 20)),
                    ),
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    label: Text("Thêm vào giỏ hàng",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.yellow.shade800,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      addToCart(product);
                      setState(() {
                        quantityCarrt = FlutterCart().cartLength;
                      });
                      showToastMessage("Thêm thành công");
                    },
                  ))
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
