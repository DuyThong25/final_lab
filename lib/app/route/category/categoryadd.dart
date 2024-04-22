import 'package:flutter/material.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/page/category/categorywidget.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd(
      {super.key,
      this.isUpdate = false,
      this.categoryModel,
      required this.accountID});
  final bool isUpdate;
  final CategoryModel? categoryModel;
  final String accountID;

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  String titleText = "";

  String? checkMessageErrorTextField(
      String label, TextEditingController controller) {
    final text = controller.text;
    if (text.trim().isEmpty) {
      if (label.trim().contains("Tên")) {
        return "Vui lòng nhập tên sản phẩm";
      } else if (label.trim().contains("Mô tả")) {
        return "Vui lòng nhập mô tả";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  _onSave() async {
    String name = _nameController.text;
    String description = _descController.text;
    String imageUrl = _imageURLController.text;
    String accountId = widget.accountID;

    if (name.trim().isEmpty ||
        description.trim().isEmpty ||
        accountId.trim().isEmpty) {
      showToastMessage("Vui lòng nhập thông tin");
    } else {
      var respone = await APIRepository()
          .addOrupdateCategory(null ,name, description, imageUrl, accountId, widget.isUpdate);
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
    String accountId = widget.accountID;
    int idCategory = widget.categoryModel!.id!;

    if (name.trim().isEmpty ||
        description.trim().isEmpty ||
        accountId.trim().isEmpty) {
      showToastMessage("Vui lòng nhập thông tin");
    } else {
      var respone = await APIRepository()
          .addOrupdateCategory(idCategory, name, description, imageUrl, accountId, widget.isUpdate);
      if (respone != "update fail") {
        showToastMessage("Cập nhật thành công");
        setState(() {});
        Navigator.pop(context);
      } else {
        showToastMessage("Cập nhật thất bại");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.categoryModel != null && widget.isUpdate) {
      _nameController.text = widget.categoryModel!.name;
      _descController.text = widget.categoryModel!.desc;
      _imageURLController.text = widget.categoryModel!.imageURL;
    }
    if (widget.isUpdate) {
      titleText = "Cập nhật loại sản phẩm";
    } else {
      titleText = "Thêm loại sản phẩm mới";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titleText),
        ),
        body: SingleChildScrollView(
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
                      errorText:
                          checkMessageErrorTextField("Mô tả", _descController),
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
        ));
  }
}
