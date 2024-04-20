import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab10/app/page/profile/changepassword.dart';
import 'package:lab10/app/page/profile/detailinfor.dart';

class DetailMain extends StatelessWidget {
  const DetailMain({super.key});

  void onPressToInfor(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const DetailInfor(),
      ),
    );
  }

  void onPressToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ChangePassword(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            itemContainerFunction(
                "Xem thông tin cá nhân", context, onPressToInfor),
            itemContainerFunction(
                "Đổi mật khẩu", context, onPressToChangePassword),
          ],
        ),
      ),
    );
  }

  Widget itemContainerFunction(String title, BuildContext context, Function(BuildContext) onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,
      height: 60.0,
      child: ElevatedButton(
        onPressed: () => onPressed(context), // Sử dụng hàm ẩn danh
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
