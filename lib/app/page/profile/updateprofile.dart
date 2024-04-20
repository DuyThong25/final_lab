import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/data/sharepre.dart';
import 'package:lab10/app/model/user.dart';
import 'package:lab10/app/page/detail.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key, required this.user});
  final User user;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  int _gender = 0;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  String gendername = 'None';
  String temp = '';

  Future<String?> updateProfile() async {
    return await APIRepository().UpdateProfile(User.updateProfile(
            idNumber: widget.user.idNumber,
            fullName: _fullNameController.text,
            phoneNumber: _phoneNumberController.text,
            gender: getGender(),
            birthDay: _birthDayController.text,
            schoolYear: _schoolYearController.text,
            schoolKey: _schoolKeyController.text,
            imageURL: _imageURL.text)
        // Signup(
        //   accountID: _accountController.text,
        //   birthDay: _birthDayController.text,
        //   password: _passwordController.text,
        //   confirmPassword: _confirmPasswordController.text,
        //   fullName: _fullNameController.text,
        //   phoneNumber: _phoneNumberController.text,
        //   schoolKey: _schoolKeyController.text,
        //   schoolYear: _schoolYearController.text,
        //   gender: getGender(),
        //   imageUrl: _imageURL.text,
        //   numberID: _numberIDController.text));
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fullNameController.text = widget.user.fullName ?? "";
    _phoneNumberController.text = widget.user.phoneNumber ?? "";
    _schoolKeyController.text = widget.user.schoolKey ?? "";
    _schoolYearController.text = widget.user.schoolYear ?? "";
    _birthDayController.text = widget.user.birthDay ?? "";
    _imageURL.text = widget.user.imageURL ?? "";

    switch (widget.user.gender!.toLowerCase()) {
      case "nam" || "male":
        gendername = "Name";
        _gender = 1;
        break;
      case "nữ" || "female" || "nu":
        gendername = "Nữ";
        _gender = 2;
        break;
      default:
        gendername = "Khác";
        _gender = 3;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Cập nhật thông tin',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                ),
                const SizedBox(height: 20),
                updateProfileWidget(),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          String? responeToken = await updateProfile();

                          if (responeToken != "update fail") {
                            // Cập nhật lại SharedPreferences                   
                            var user = await APIRepository().current(responeToken!);
                            // save share
                            saveUser(user);
                            Navigator.pop(context);
                          } else {
                            print("Cập nhật thất bại: $responeToken");
                            // Toast Message
                            Fluttertoast.showToast(
                                msg: "Lỗi cập nhật",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text(
                          'Lưu',
                          style:
                              TextStyle(fontSize: 18, color: Colors.blue[900]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getGender() {
    if (_gender == 1) {
      return "Nam";
    } else if (_gender == 2) {
      return "Nữ";
    }
    return "Khác";
  }

  String? checkMessageErrorTextField(
      String label, TextEditingController controller) {
    final text = controller.text;
    if (text.trim().isEmpty) {
      if (label.trim().contains("Account")) {
        return "Vui lòng nhập tài khoản";
      } else if (label.trim().contains("Password")) {
        return "Vui lòng nhập mật khẩu";
      } else if (label.trim().contains("Confirm password")) {
        return "Vui lòng nhập xác nhận mật khẩu";
      } else if (label.trim().contains("Full Name")) {
        return "Vui lòng nhập họ tên";
      } else if (label.trim().contains("NumberID")) {
        return "Vui lòng nhập Number ID";
      } else if (label.trim().contains("PhoneNumber")) {
        return "Vui lòng nhập số điện thoại";
      } else if (label.trim().contains("BirthDay")) {
        return "Vui lòng nhập ngày sinh";
      } else if (label.trim().contains("SchoolYear")) {
        return "Vui lòng nhập năm học";
      } else if (label.trim().contains("SchoolKey")) {
        return "Vui lòng nhập School Key";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  //có thể thêm các biến cho phù hợp với từng field
  Widget textField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.contains('word'),
        onChanged: (value) {
          setState(() {
            temp = value;
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

  Widget updateProfileWidget() {
    return Column(
      children: [
        textField(_fullNameController, "Full Name", Icons.text_fields_outlined),
        textField(_phoneNumberController, "PhoneNumber", Icons.phone),
        textField(_birthDayController, "BirthDay", Icons.date_range),
        textField(_schoolYearController, "SchoolYear", Icons.school),
        textField(_schoolKeyController, "SchoolKey", Icons.school),
        const Text("What is your Gender?"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Male"),
                leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 1,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    )),
              ),
            ),
            Expanded(
              child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Female"),
                  leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 2,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  )),
            ),
            Expanded(
                child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Other"),
              leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 3,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  )),
            )),
          ],
        ),
        // Error Text of Radio
        _gender == 0
            ? const Text("Không được để trống giới tính",
                style: TextStyle(color: Colors.red))
            : Container(),
        const SizedBox(height: 16),
        TextFormField(
          controller: _imageURL,
          decoration: const InputDecoration(
            labelText: "Image URL",
            icon: Icon(Icons.image),
          ),
        ),
      ],
    );
  }
}
