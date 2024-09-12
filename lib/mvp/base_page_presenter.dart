import 'package:deer_imitate/mvp/base_presenter.dart';
import 'package:deer_imitate/mvp/mvps.dart';
import 'package:dio/dio.dart';

import '../net/error_handle.dart';
import '../utils/dio_utils.dart';

class BasePagePresenter<V extends IMvpView> extends BasePresenter<V> {
  late CancelToken _cancelToken;

  BasePagePresenter() {
    _cancelToken = CancelToken();
  }

  @override
  void dispose() {
    if (!_cancelToken.isCancelled)
      _cancelToken.cancel();
  }

  Future<dynamic> requestNetWork<T>(Method method, {
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options}) {
    if (isShow) {
      view.showProgress();
    }
    return DioUtils.instance.requestNetwork<T>(method, url,
        params: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onSuccess: (data) {
          if (isClose) {
            view.closeProgress();
          }
          onSuccess?.call(data);
        },
        onError: (code, msg) {
          _onError(code, msg, onError);
        }
    );
  }

  void asyncRequestNetwork<T>(Method method,{
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }){
    if(isShow){
      view.showProgress();
    }
    DioUtils.instance.asyncRequestNetwork<T>(method, url,
    params: params,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSuccess: (data){
      if(isClose){
        view.closeProgress();
      }
      onSuccess?.call(data);
    },
    onError: (code,msg){
      _onError(code, msg, onError);
    });
  }


  void _onError(int code, String msg, NetErrorCallback? onError) {
    /// 异常时直接关闭加载圈，不受isClose影响
    view.closeProgress();
    if (code != ExceptionHandle.cancel_error) {
      view.showToast(msg);
    }

    /// 页面如果dispose，则不回调onError
    if (onError != null) {
      onError(code, msg);
    }
  }
}