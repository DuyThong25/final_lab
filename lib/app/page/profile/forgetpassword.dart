import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/data/sharepre.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _accountIDController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

    // Hàm forget password
  Future<String?> forgetPassword() async {
    return await APIRepository().forgetPassword(
        _accountIDController.text, _numberIDController.text ,_newPasswordController.text);
  }

  String? checkMessageErrorTextField(
      String label, TextEditingController controller) {
    final text = controller.text;
    if (text.trim().isEmpty) {
      if (label.trim().contains("Account")) {
        return "Vui lòng nhập tài khoản";
      } else if (label.trim().contains("Password")) {
        return "Vui lòng nhập mật khẩu";
      } else if (label.trim().contains("NumberID")) {
        return "Vui lòng nhập Number ID";
      } else {
        return null;
      }
    } else {
      // Nếu không empty
      if (_newPasswordController.text.length < 6 &&
          label.trim().contains("Password")) {
        return "Mật khẩu không phải từ 6 ký tự trở lên ";
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quên mật khẩu"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _itemTextFieldFunction(
                  _accountIDController, "Account", Icons.person),
              _itemTextFieldFunction(
                  _numberIDController, "NumberID", Icons.key),
              _itemTextFieldFunction(
                  _newPasswordController, "Password", Icons.password),

              // submit
              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String? responeToken = await forgetPassword();

                    if (responeToken != "update fail") {
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
        ),
      ),
    );
  }

  Widget _itemTextFieldFunction(controller, label, icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        // obscureText: label.contains('word'),
        onChanged: (value) {
          setState(() {
            // temp = value;
          });
        },
        decoration: InputDecoration(
            labelText: label,
            icon: Icon(icon),
            border: const OutlineInputBorder(),
            errorText: checkMessageErrorTextField(label, controller),
            focusedErrorBorder: controller.text.isEmpty
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red))
                : null,
            errorBorder: controller.text.isEmpty
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red))
                : null),
      ),
    );
  }
}
