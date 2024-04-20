import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab10/app/page/profile/updateprofile.dart';
import '../../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailInfor extends StatefulWidget {
  const DetailInfor({super.key});

  @override
  State<DetailInfor> createState() => _DetailInforState();
}

class _DetailInforState extends State<DetailInfor> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  // create style
  TextStyle mystyle1 = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black54,
  );
  TextStyle mystyle2 = const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Image(
            //   image: NetworkImage(user.imageURL!),
            //   height: 200,
            //   width: 200,
            // ),
            // Text("NumberID: ${user.idNumber}", style: mystyle),
            // Text("Fullname: ${user.fullName}", style: mystyle),
            // Text("Phone Number: ${user.phoneNumber}", style: mystyle),
            // Text("Gender: ${user.gender}", style: mystyle),
            // Text("birthDay: ${user.birthDay}", style: mystyle),
            // Text("schoolYear: ${user.schoolYear}", style: mystyle),
            // Text("schoolKey: ${user.schoolKey}", style: mystyle),
            // Text("dateCreated: ${user.dateCreated}", style: mystyle),
            CircleAvatar(
              backgroundColor: Colors.blue.shade900,
              radius: 90,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 86,
                child: CircleAvatar(
                  backgroundImage: user.imageURL != null
                      ? NetworkImage(user.imageURL!)
                      : const AssetImage("assets/images/hlphone_logo.png")
                          as ImageProvider,
                  radius: 84,
                ),
              ),
            ),
            const SizedBox(
                width: 320,
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 50,
                )),
            textInformation("Mã sinh viên: ", user.idNumber ?? ""),
            textInformation("Tên: ", user.fullName ?? ""),
            textInformation("Số điện thoại: ", user.phoneNumber ?? ""),
            textInformation("Giới tính: ", user.gender ?? ""),
            textInformation("Ngày sinh: ", user.birthDay ?? ""),
            textInformation("Năm học: ", user.schoolYear ?? ""),
            textInformation("Mã năm học: ", user.schoolKey ?? ""),
            textInformation("Ngày tạo: ", user.dateCreated ?? ""),

            // Button update profile
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => UpdateProfile(user: user))).then((value) {
                      setState(() {
                        getDataUser();
                      });
                    });
              },
              child: Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(
                    color: Colors.amber[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget textInformation(title, textValue) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: mystyle1,
          ),
          Container(
              alignment: Alignment.centerRight,
              width: 200,
              child: Text(
                textValue,
                style: mystyle2,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}
