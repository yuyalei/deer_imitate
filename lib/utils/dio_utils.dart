import 'dart:convert';

import 'package:deer_imitate/net/base_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../net/error_handle.dart';
import '../res/constant.dart';
import 'log_utils.dart';

Duration _connectTimeout = const Duration(seconds: 15);
Duration _receiveTimeout = const Duration(seconds: 15);
Duration _sendTimeout = const Duration(seconds: 10);
String _baseUrl = '';
List<Interceptor> _interceptors = [];

void configDio(
    {Duration? connectionTimeout, Duration? receiveTimeout, Duration? sendTimeout, String? baseUrl, List<
        Interceptor>? interceptors}) {
  _connectTimeout = connectionTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

typedef NetSuccessCallback<T> = void Function(T data);
typedef NetSuccessListCallback<T> = void Function(List<T> data);
typedef NetErrorCallback = void Function(int code, String msg);

class DioUtils {
  factory DioUtils() => _singleton;

  DioUtils._(){
    final BaseOptions options = BaseOptions(
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        responseType: ResponseType.plain,
        validateStatus: (_) {
          // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
          return true;
        },
        baseUrl: _baseUrl
    );
    _dio = Dio(options);

    void addInterceptor(Interceptor interceptor) {
      _dio.interceptors.add(interceptor);
    }
    _interceptors.forEach(addInterceptor);
  }

  static final DioUtils _singleton = DioUtils._();

  static DioUtils get instance => DioUtils();

  static late Dio _dio;

  Dio get dio => _dio;

  Future<BaseEntity<T>> _request<T>(String method, String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,);

    try {
      final String data = response.data.toString();
      /// 集成测试无法使用 isolate https://github.com/flutter/flutter/issues/24703
      /// 使用compute条件：数据大于10KB（粗略使用10 * 1024）且当前不是集成测试（后面可能会根据Web环境进行调整）
      /// 主要目的减少不必要的性能开销
      final bool isCompute = !Constant.isDriverTest && data.length > 10 * 1024;
      debugPrint('isCompute:$isCompute');
      final Map<String, dynamic> map = isCompute ? await compute(parseData, data) : parseData(data);
      return BaseEntity<T>.fromJson(map);
    } catch(e) {
      debugPrint(e.toString());
      return BaseEntity<T>(ExceptionHandle.parse_error, '数据解析错误！', null);
    }
  }

  Future<dynamic> requestNetwork<T>(Method method, String url, {
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _request<T>(method.value, url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then<void>((BaseEntity<T> result) {
      if (result.code == 0) {
        onSuccess?.call(result.data);
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  Map<String, dynamic> parseData(String data) {
    return json.decode(data) as Map<String, dynamic>;
  }

  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioException && CancelToken.isCancel(e)) {
      Log.e('取消请求接口： $url');
    }
  }

  void _onError(int? code, String msg, NetErrorCallback? onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    Log.e('接口请求异常： code: $code, mag: $msg');
    onError?.call(code, msg);
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

enum Method {
  get,
  post,
  put,
  patch,
  delete,
  head
}

/// 使用拓展枚举替代 switch判断取值
/// https://zhuanlan.zhihu.com/p/98545689
extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}