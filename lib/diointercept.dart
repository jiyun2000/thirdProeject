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

  static Future<dynamic> getHttp(String path) async {
    dio.interceptors.clear();
    getInterceptor().then((item) {
      dio.interceptors.add(item);
    });
    Response res = await dio.get(path);
    return res.data;
  }

  static Future<dynamic> postHttp(String path) async {
    dio.interceptors.clear();
    getInterceptor().then((item) {
      dio.interceptors.add(item);
    });
    return await dio.post(path);
  }

  static Future<InterceptorsWrapper> getInterceptor() async {
    var perf = await SharedPreferences.getInstance();
    return InterceptorsWrapper(onRequest: (req, handler) {
      String? token = perf.getString("accessToken");
      if (token != null) {
        req.headers['Autorization'] = 'bearer $token';
      }
      return handler.next(req);
    }, onError: (error, handler) {
      print(error);
    });
  }

  void storeToken(dynamic data) async {
    var perf = await SharedPreferences.getInstance();
    perf.setString("accessToken", data['accessToken']);
    perf.setString("refreshToken", data['refreshToken']);
  }
}
