import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/data/sharepre.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String temp = '';

  // Hàm change password
  Future<String?> changePassword() async {
    return await APIRepository().changePassword(
        _oldPasswordController.text, _newPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Đổi mật khẩu"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _oldPasswordController,
                  onChanged: (value) {
                    setState(() {
                      temp = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Mật khẩu cũ",
                      icon: const Icon(Icons.password_outlined),
                      border: const OutlineInputBorder(),
                      errorText: _oldPasswordController.text.trim().isEmpty
                          ? "Vui lòng không để trống"
                          : _oldPasswordController.text.trim().length < 6
                              ? "Mật khẩu phải có ít nhất 6 ký tự"
                              : null,
                      focusedErrorBorder: _oldPasswordController.text.isEmpty
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))
                          : null,
                      errorBorder: _oldPasswordController.text.isEmpty
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))
                          : null),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _newPasswordController,
                  onChanged: (value) {
                    setState(() {
                      temp = value;
                    });
                  },
                  validator: (value) {
                    if (_newPasswordController.text.trim().isNotEmpty &&
                        _newPasswordController.text.trim().length < 6) {
                      return "Mật khẩu phải từ 6 ký tự trở lên";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Mật khẩu mới",
                      icon: const Icon(Icons.password_outlined),
                      border: const OutlineInputBorder(),
                      errorText: _newPasswordController.text.trim().isEmpty
                          ? "Vui lòng không để trống"
                          : _newPasswordController.text.trim().length < 6
                              ? "Mật khẩu phải có ít nhất 6 ký tự"
                              : null,
                      focusedErrorBorder: _newPasswordController.text.isEmpty
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))
                          : null,
                      errorBorder: _newPasswordController.text.isEmpty
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))
                          : null),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String? responeToken = await changePassword();

                    if (responeToken != "update fail") {
                      // Cập nhật lại SharedPreferences
                      var user = await APIRepository().current(responeToken!);
                      // save share
                      saveUser(user);
                      showToastMessage("Cập nhật thành công");

                      Navigator.pop(context);
                    } else {
                      print("Cập nhật thất bại: $responeToken");
                      // Toast Message
                      showToastMessage("Cập nhật thất bại");
                    }
                  },
                  child: Text(
                    "Cập nhật mật khẩu mới",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
