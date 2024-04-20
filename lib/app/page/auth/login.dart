import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/page/profile/forgetpassword.dart';
import 'package:lab10/mainpage.dart';

import '../register.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessageAccount;
  String? errorMessagePassword;

  login() async {
    if (accountController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      //lấy token (lưu share_preference)
      String token = await APIRepository()
          .login(accountController.text, passwordController.text);
      if (token != "login fail") {
        var user = await APIRepository().current(token);
        // save share
        saveUser(user);
        // save token;
        saveToken(token);
        showToastMessage("Đăng nhập thành công");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Mainpage()));
        return token;
      } else {
        // 500 là server error khi sai pass hoặc account
        setState(() {
          errorMessagePassword = "Sai tài khoản hoặc mật khẩu";
          errorMessageAccount = "Sai tài khoản hoặc mật khẩu";
        });
        showToastMessage("Lỗi đăng nhập");
        return "";
      }
    } else {
      setState(() {
        if (accountController.text.trim().isEmpty &&
            passwordController.text.trim().isEmpty) {
          errorMessageAccount = "Vui lòng không để trống tên đăng nhập";
          errorMessagePassword = "Vui lòng không để trống mật khẫu";
        } else if (accountController.text.trim().isEmpty &&
            passwordController.text.trim().isNotEmpty) {
          errorMessageAccount = "Vui lòng không để trống tên đăng nhập";
          errorMessagePassword = null;
        } else {
          errorMessageAccount = null;
          errorMessagePassword = "Vui lòng không để trống mật khẫu";
        }
        showToastMessage("Lỗi đăng nhập");
      });
    }
  }

  // String? _errorText(messageError, controller) {
  //   final text = controller.value.text;
  //   if (text.isEmpty) {
  //     return messageError;
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    urlLogo,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  const Text(
                    "LOGIN INFORMATION",
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  TextFormField(
                    controller: accountController,
                    decoration: InputDecoration(
                        labelText: "Account",
                        icon: const Icon(Icons.person),
                        errorText: errorMessageAccount),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        icon: const Icon(Icons.password),
                        errorText: errorMessagePassword),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: login,
                        child: const Text("Login"),
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: const Text("Register"),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: 
                          (context) => const ForgetPassword(),
                        )
                      );
                    },
                    child: const Text(
                      'Quên mật khẩu ?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        decorationThickness: 1,
                        // Tạo khoảng cách giữa chữ và đường gạch
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
