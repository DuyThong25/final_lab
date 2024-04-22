import 'package:flutter/material.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/model/user.dart';
import 'package:lab10/app/page/category/categorywidget.dart';
import 'package:lab10/app/route/category/categoryadd.dart';

class CategoryDefault extends StatefulWidget {
  const CategoryDefault({super.key, required this.user, this.isAdmin = false});
  final User user;
  final isAdmin;

  @override
  State<CategoryDefault> createState() => _CategoryDefaultState();
}

class _CategoryDefaultState extends State<CategoryDefault> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách loại sản phẩm"),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryAdd(accountID: widget.user.accountId!),
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
      body: FutureBuilder<List<CategoryModel>>(
        future: APIRepository().getListCategory(widget.user.accountId!),
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
                "Hãy thêm vài loại sản phẩm nhé !!!",
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

  Widget _buildCategory(CategoryModel breed, int index, BuildContext context) {
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
                      int idCategory = breed.id!;
                      var respone = await APIRepository()
                          .removeCategory(idCategory, accountId);
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
        child: Row(
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
                decoration: (breed.imageURL == null || breed.imageURL == "")
                    ? BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10))
                    : BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                height: 60,
                width: 60,
                child: (breed.imageURL == null || breed.imageURL == "")
                    ? const Icon(
                        Icons.image,
                        size: 36,
                      )
                    : Image.network(
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                        breed.imageURL,
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
                    breed.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    breed.desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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
                              builder: (_) => CategoryAdd(
                                isUpdate: true,
                                categoryModel: breed,
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
            ]
          ],
        ),
      ),
    );
  }
}
