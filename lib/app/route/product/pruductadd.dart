import 'package:flutter/material.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/page/category/categorywidget.dart';
import 'package:lab10/app/page/product/productwidget.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd(
      {super.key,
      this.isUpdate = false,
      this.productModel,
      required this.accountID});

  final bool isUpdate;
  final ProductModel? productModel;
  final String accountID;
  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int? categoryID;
  String nameCategory = "";
  String titleText = "";
  Future<List<CategoryModel>>? listCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCategory = APIRepository().getListCategory(widget.accountID);
    if (widget.productModel != null && widget.isUpdate) {
      _nameController.text = widget.productModel!.name;
      _descController.text = widget.productModel!.desc!;
      _imageURLController.text = widget.productModel!.imageURL!;
      _priceController.text = widget.productModel!.price.toString();
      // Cập nhật category id
      nameCategory = widget.productModel!.categoryName!;
      categoryID = widget.productModel!.categoryID!;
    }
    if (widget.isUpdate) {
      titleText = "Cập nhật sản phẩm";
    } else {
      titleText = "Thêm sản phẩm mới";
    }
  }

  _onSave() async {
    String name = _nameController.text;
    String description = _descController.text;
    String imageUrl = _imageURLController.text;
    String priceText = _priceController.text;

    if (name.trim().isEmpty ||
        description.trim().isEmpty ||
        priceText.isEmpty ||
        categoryID == null ||
        nameCategory.isEmpty) {
      showToastMessage("Vui lòng nhập thông tin");
    } else {
      double price = double.parse(priceText);
      var respone = await APIRepository().addOrupdateProduct(
          null,
          name,
          description,
          imageUrl,
          price,
          categoryID!,
          widget.accountID,
          widget.isUpdate);
      if (respone != "update fail") {
        showToastMessage("Thêm loại sản phẩm thành công");
        setState(() {});
        Navigator.pop(context);
      } else {
        showToastMessage("Thêm loại sản phẩm thất bại");
      }
    }
  }

  _onUpdate() async {
    String name = _nameController.text;
    String description = _descController.text;
    String imageUrl = _imageURLController.text;
    String priceText = _priceController.text;

    if (name.trim().isEmpty ||
        description.trim().isEmpty ||
        priceText.isEmpty ||
        categoryID == null ||
        nameCategory.isEmpty) {
      showToastMessage("Vui lòng nhập thông tin");
    } else {
      double price = double.parse(priceText);

      var respone = await APIRepository().addOrupdateProduct(
          widget.productModel!.id,
          name,
          description,
          imageUrl,
          price,
          categoryID!,
          widget.accountID,
          widget.isUpdate);
      if (respone != "update fail") {
        showToastMessage("Cập nhật thành công");
        setState(() {});
        Navigator.pop(context);
      } else {
        showToastMessage("Cập nhật thất bại");
      }
    }
  }

  String? checkMessageErrorTextField(
      String label, TextEditingController controller) {
    final text = controller.text;
    if (text.trim().isEmpty) {
      if (label.trim().contains("Tên")) {
        return "Vui lòng nhập tên sản phẩm";
      } else if (label.trim().contains("Mô tả")) {
        return "Vui lòng nhập mô tả";
      } else if (label.trim().contains("Giá")) {
        return "Vui lòng nhập giá sản phẩm";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titleText),
        ),
        body: FutureBuilder(
          future: listCategory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Lỗi"),
              );
            } else if (snapshot.data!.length == 0) {
              return const Center(
                child: Text(
                  "Cần ít nhất 1 loại sản phẩm để thêm sản phẩm mới !",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {
                            // temp = value;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Tên sản phẩm"),
                            border: const OutlineInputBorder(),
                            // hintText: 'Nhập tên sản phẩm',
                            errorText: checkMessageErrorTextField(
                                "Tên sản phẩm", _nameController)),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _descController,
                        maxLines: 7,
                        onChanged: (value) {
                          setState(() {
                            // temp = value;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Mô tả"),
                            border: const OutlineInputBorder(),
                            // hintText: 'Nhập mô tả',
                            errorText: checkMessageErrorTextField(
                                "Mô tả", _descController),
                            focusedErrorBorder: _descController.text.isEmpty
                                ? const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))
                                : null,
                            errorBorder: _descController.text.isEmpty
                                ? const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))
                                : null),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _imageURLController,
                        decoration: const InputDecoration(
                          label: Text("Đường dẫn hình (có thể để trống)"),
                          border: OutlineInputBorder(),
                          hintText: 'Nhập đường dẫn hình',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        onChanged: (value) {
                          setState(() {
                            // temp = value;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Giá sản phẩm"),
                            border: const OutlineInputBorder(),
                            // hintText: 'Nhập tên sản phẩm',
                            errorText: checkMessageErrorTextField(
                                "Giá sản phẩm", _priceController)),
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButton<CategoryModel>(
                        padding: const EdgeInsets.all(16),
                        items: snapshot.data!.map((item) {
                          return DropdownMenuItem<CategoryModel>(
                            value: item,
                            child: Text(item.name),
                          );
                        }).toList(),
                        isExpanded: true,
                        hint: nameCategory.isEmpty
                            ? const Text('Danh sách loại sản phẩm')
                            : Text(
                                nameCategory,
                                style: TextStyle(color: Colors.black),
                              ),
                        onChanged: (value) {
                          categoryID = value!.id;
                          nameCategory = value.name;
                          print(categoryID);
                          print(nameCategory);
                          setState(() {});
                        },
                      ),
                      nameCategory.isEmpty
                          ? const Padding(
                              padding: EdgeInsetsDirectional.only(start: 16),
                              child: Text(
                                "Vui lòng chọn loại sản phẩm",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ))
                          : Container(),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 45.0,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.isUpdate ? _onUpdate() : _onSave();
                          },
                          child: Text(
                            widget.isUpdate ? 'Cập nhật' : "Thêm sản phẩm",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
