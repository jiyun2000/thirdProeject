import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioInterceptor {
  static final DioInterceptor dioIn = DioInterceptor._internal();
  static final dio = Dio();
  factory DioInterceptor() {
    getInterceptor().then((item) {
      dio.interceptors.add(item);
    });
    return dioIn;
  }
  DioInterceptor._internal();

  static Future<bool> getHttp(String path, Map<String, dynamic> data) async {
    dio.interceptors.clear();
    getInterceptor().then((item) {
      dio.interceptors.add(item);
    });
    try {
      Response res = await dio.get(path,
          // options: Options(
          //     headers: {HttpHeaders.contentTypeHeader: "application/json"}),
          data: jsonEncode(data));
      storeToken(res.data);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> postHttp(String path, Map<String, dynamic> data) async {
    dio.interceptors.clear();
    getInterceptor().then((item) {
      dio.interceptors.add(item);
    });
    try {
      Response res = await dio.post(path,
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}),
          data: FormData.fromMap(data));
      storeToken(res.data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<InterceptorsWrapper> getInterceptor() async {
    var perf = await SharedPreferences.getInstance();
    return InterceptorsWrapper(onRequest: (req, handler) {
      String? token = perf.getString("accessToken");
      if (token != null) {
        req.headers['Authorization'] = 'bearer $token';
      }
      return handler.next(req);
    }, onError: (error, handler) {
      print(error);
    });
  }

  static void storeToken(dynamic data) async {
    var perf = await SharedPreferences.getInstance();
    perf.setString("accessToken", data['accessToken']);
    perf.setString("refreshToken", data['refreshToken']);
    perf.setString("email", data['email']);
    perf.setInt("empNo", data['empNo']);
    perf.setInt("deptNo", data['deptNo']);
  }

  static bool isLogin() {
    try {
      var perf = SharedPreferences.getInstance().then((perf) {
        perf.get("email");
        perf.get("empNo");
        perf.get("deptNo");
        // if (perf.get("accessToken") != null && perf.get("refreshToken") != null) {
        //   dio.get("http://localhost:8080/auth/refresh",data:{"refreshToken":perf.get("refreshToken")}).then((item) {
        //     perf.setString("accessToken", item.data['accessToken']);
        //     perf.setString("refreshToken", item.data['refreshToken']);
        //   });
        // }
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
