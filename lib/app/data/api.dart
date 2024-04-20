// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:lab10/app/model/register.dart';
import 'package:lab10/app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      if (ex is DioError && ex.response?.statusCode == 400) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        return "400";
      } else {
        print(ex);
        rethrow;
      }
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        final tokenData = res.data['data']['token'];
        print("ok login");
        print("token: $tokenData");
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      if (ex is DioError && ex.response?.statusCode == 500) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        return "500";
      } else {
        // Xử lý các ngoại lệ khác
        print(ex);
        rethrow;
      }
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<String?> UpdateProfile(User user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.idNumber,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "gender": user.gender,
        "birthDay": user.birthDay,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "imageURL": user.imageURL,
      });
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.put('/Auth/updateProfile',
          options: Options(headers: header('$token')), data: body);
      if (res.statusCode == 200) {
        // final tokenData = res.data['data']['token'];
        print("ok update");
        return token;
      } else {
        return "update fail";
      }
    } catch (ex) {
      if (ex is DioError) {
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return "update fail";
      }
      print(ex);
      return "update fail";
    }
  }
}
