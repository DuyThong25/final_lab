import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab10/app/page/profile/changepassword.dart';
import 'package:lab10/app/page/profile/detailinfor.dart';
import 'package:lab10/app/route/categorywidget.dart';
import 'package:lab10/app/route/productwidget.dart';

class DetailMain extends StatelessWidget {
  const DetailMain({super.key, this.nameWidget, this.user, this.isAdmin = true,});
  final nameWidget;
  final user;
  final isAdmin;
  onPressToInfo(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const DetailInfor(),
      ),
    );
  }

  onPressToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ChangePassword(),
      ),
    );
  }

  onPressToListCategory(BuildContext context) {
    if (isAdmin) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CategoryDefault(
            user: user,
            isAdmin: isAdmin,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CategoryDefault(
            user: user,
            
          ),
        ),
      );
    }
  }

    onPressToListProduct(BuildContext context) {
    if (isAdmin) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ProductDefault(
            user: user,
            isAdmin: isAdmin,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ProductDefault(
            user: user,
            
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (nameWidget == 'Detail') ...[
              _itemContainerFunction(
                  "Xem thông tin cá nhân", context, onPressToInfo),
              _itemContainerFunction(
                  "Đổi mật khẩu", context, onPressToChangePassword),
            ],
            if (nameWidget == 'Home') ...[
              _itemContainerFunction(
                  "Loại sản phẩm", context, onPressToListCategory),
              _itemContainerFunction(
                  "Danh sách sản phẩm", context, onPressToListProduct),
            ]
          ],
        ),
      ),
    );
  }

  Widget _itemContainerFunction(
      String title, BuildContext context, onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,
      height: 60.0,
      child: ElevatedButton(
        onPressed: () {
          onPressed(context);
        }, // Sử dụng hàm ẩn danh
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
