import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioInterceptor {
  static final DioInterceptor dioIn = DioInterceptor._internal();
  static final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.51:8080/api',
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 10), // 응답 타임아웃 (10초)
    receiveTimeout: const Duration(seconds: 10), // 응답 타임아웃 (10초)
    sendTimeout: const Duration(seconds: 10), // 전송 타임아웃 (10초)
  ));
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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        log("⚠️ Connection Timeout: 서버에 연결할 수 없습니다.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        log("⚠️ Receive Timeout: 서버 응답이 지연되고 있습니다.");
      } else if (e.type == DioExceptionType.badResponse) {
        log("⚠️ 서버 오류: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        log("⚠️ DioException 발생: ${e.message}");
      }
      return false;
    } catch (e) {
      log("⚠️ 알 수 없는 오류 발생: ${e.toString()}");
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
        //   dio.get("http://192.168.0.51:8080/auth/refresh",data:{"refreshToken":perf.get("refreshToken")}).then((item) {
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
