// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:lab10/app/model/bill.dart';
import 'package:lab10/app/model/register.dart';
import 'package:lab10/app/model/user.dart';
import 'package:lab10/app/page/category/categorywidget.dart';
import 'package:lab10/app/page/product/productwidget.dart';
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
      if (ex is DioError) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        return "login fail";
      } else {
        // Xử lý các ngoại lệ khác
        print(ex);
        return "login fail";
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

  Future<String?> updateProfile(User user) async {
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

  Future<String?> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final body = FormData.fromMap({
        "OldPassword": currentPassword,
        "NewPassword": newPassword,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.put('/Auth/ChangePassword',
          options: Options(headers: header('$token')), data: body);
      if (res.statusCode == 200) {
        print("ok update password");
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

  Future<String?> forgetPassword(
      String accountID, String numberID, String newPassword) async {
    try {
      final body = FormData.fromMap({
        "accountID": accountID,
        "numberID": numberID,
        "newPass": newPassword,
      });

      Response res = await api.sendRequest.put('/Auth/forgetPass',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok forget password");
        return "ok";
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

  Future<List<CategoryModel>>? getListCategory(String accountID) async {
    try {
      var dataQuery = {"accountID": accountID};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.get('/Category/getList',
          options: Options(headers: header('$token')),
          queryParameters: dataQuery);

      if (res.statusCode == 200) {
        final data = res.data as List;
        List<CategoryModel> results =
            data.map((item) => CategoryModel.fromMap(item)).toList();
        print("ok get list category");
        return results;
      } else {
        return Future.value([]);
      }
    } catch (ex) {
      if (ex is DioError) {
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return Future.error(ex);
      }
      print(ex);
      return Future.error(ex);
    }
  }

  Future<String?> addOrupdateCategory(
      int? idCategory,
      String name,
      String description,
      String imageUrl,
      String accountId,
      bool isUpdate) async {
    try {
      final body;
      if (isUpdate == false) {
        body = FormData.fromMap({
          'Name': name,
          'Description': description,
          'ImageURL': imageUrl,
          'AccountID': accountId
        });
      } else {
        body = FormData.fromMap({
          'id': idCategory,
          'Name': name,
          'Description': description,
          'ImageURL': imageUrl,
          'AccountID': accountId
        });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Response res;

      if (isUpdate == false) {
        res = await api.sendRequest.post('/addCategory',
            options: Options(headers: header("$token")), data: body);
      } else {
        res = await api.sendRequest.put('/updateCategory',
            options: Options(headers: header("$token")), data: body);
      }

      if (res.statusCode == 200) {
        if (isUpdate == false) {
          print("ok add category");
        } else {
          print("ok update category");
        }
        return "ok";
      } else {
        return "update fail";
      }
    } catch (ex) {
      if (ex is DioError) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return "update fail";
      } else {
        // Xử lý các ngoại lệ khác
        print(ex);
        return "update fail";
      }
    }
  }

  Future<String?> removeCategory(
    int idCategory,
    String accountId,
  ) async {
    try {
      final body =
          FormData.fromMap({'categoryID': idCategory, 'accountID': accountId});

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.delete('/removeCategory',
          options: Options(headers: header("$token")), data: body);

      if (res.statusCode == 200) {
        print("ok remove category");
        return "ok";
      } else {
        return "remove fail";
      }
    } catch (ex) {
      if (ex is DioError) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return "remove fail";
      } else {
        // Xử lý các ngoại lệ khác
        print(ex);
        return "remove fail";
      }
    }
  }

  Future<List<ProductModel>>? getListProduct(String accountID) async {
    try {
      var dataQuery = {"accountID": accountID};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.get('/Product/getList',
          options: Options(headers: header('$token')),
          queryParameters: dataQuery);

      if (res.statusCode == 200) {
        final data = res.data as List;
        List<ProductModel> results =
            data.map((item) => ProductModel.fromMap(item)).toList();
        print("ok get list products");
        return results;
      } else {
        return Future.value([]);
      }
    } catch (ex) {
      if (ex is DioError) {
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return Future.error(ex);
      }
      print(ex);
      return Future.error(ex);
    }
  }

  Future<String?> removeProduct(int idProduct, String accountId) async {
    try {
      final body =
          FormData.fromMap({'productID': idProduct, 'accountID': accountId});

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.delete('/removeProducct',
          options: Options(headers: header("$token")), data: body);

      if (res.statusCode == 200) {
        print("ok remove product");
        return "ok";
      } else {
        return "remove fail";
      }
    } catch (ex) {
      if (ex is DioError) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return "remove fail";
      } else {
        // Xử lý các ngoại lệ khác
        print(ex);
        return "remove fail";
      }
    }
  }

  Future<String?> addOrupdateProduct(
      int? idProduct,
      String name,
      String description,
      String imageUrl,
      double price,
      int categoryId,
      String accountId,
      bool isUpdate) async {
    try {
      final body;
      if (isUpdate == false) {
        body = FormData.fromMap({
          'Name': name,
          'Description': description,
          'ImageURL': imageUrl,
          'Price': price,
          'CategoryID': categoryId,
        });
      } else {
        body = FormData.fromMap({
          'id': idProduct,
          'Name': name,
          'Description': description,
          'ImageURL': imageUrl,
          'Price': price,
          'CategoryID': categoryId,
          'accountID': accountId
        });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Response res;

      if (isUpdate == false) {
        res = await api.sendRequest.post('/addProduct',
            options: Options(headers: header("$token")), data: body);
      } else {
        res = await api.sendRequest.put('/updateProduct',
            options: Options(headers: header("$token")), data: body);
      }

      if (res.statusCode == 200) {
        if (isUpdate == false) {
          print("ok add product");
        } else {
          print("ok update product");
        }
        return "ok";
      } else {
        return "update fail";
      }
    } catch (ex) {
      if (ex is DioError) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return "update fail";
      } else {
        // Xử lý các ngoại lệ khác
        print(ex);
        return "update fail";
      }
    }
  }

  Future<String?> sendBill(List<CartModel> listCartModel) async {
    try {
      final body = listCartModel.map((cartModel) {
        return {"productID": cartModel.productId, "count": cartModel.quantity};
      }).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.post('/Order/addBill',
          options: Options(headers: header('$token')), data: body);

      if (res.statusCode == 200) {
        print("ok add bill");
        return "ok";
      } else {
        return "add bill fail";
      }
    } catch (ex) {
      if (ex is DioError) {
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return "add bill fail";
      }
      print(ex);
      return "add bill fail";
    }
  }

  Future<List<BillModel>>? getHistoryBill() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest
          .get('/Bill/getHistory', options: Options(headers: header('$token')));

      if (res.statusCode == 200) {
        final data = res.data as List;
        List<BillModel> results =
            data.map((item) => BillModel.fromMap(item)).toList();
        print("ok get history bill");
        return results;
      } else {
        return Future.value([]);
      }
    } catch (ex) {
      if (ex is DioError) {
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return Future.error(ex);
      }
      print(ex);
      return Future.error(ex);
    }
  }

  Future<String?> removeBill(String idBill) async {
    try {
      final body = {'billID': idBill};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.delete('/Bill/remove',
          options: Options(headers: header("$token")), queryParameters: body);

      if (res.statusCode == 200) {
        print("ok remove bill");
        return "ok";
      } else {
        return "remove fail";
      }
    } catch (ex) {
      if (ex is DioError) {
        // Xử lý khi có lỗi máy chủ
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return "remove fail";
      } else {
        // Xử lý các ngoại lệ khác
        print(ex);
        return "remove fail";
      }
    }
  }

  Future<List<BillDetailModel>>? getBillByID(String idBill) async {
    try {
      final body = {'billID': idBill};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Response res = await api.sendRequest.post('/Bill/getByID',
          options: Options(headers: header("$token")), queryParameters: body);

      if (res.statusCode == 200) {
        final data = res.data as List;
        List<BillDetailModel> results =
            data.map((item) => BillDetailModel.fromMap(item)).toList();
        print("ok get bill detail");
        return results;
      } else {
        return Future.value([]);
      }
    } catch (ex) {
      if (ex is DioError) {
        print(ex);
        print("status code: ${ex.response?.statusCode.toString()}");
        return Future.error(ex);
      }
      print(ex);
      return Future.error(ex);
    }
  }
}
