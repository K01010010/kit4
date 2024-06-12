part of '../kit4.dart';

class CustomInterceptor extends InterceptorsWrapper {
  RequestOptions lastRequest = RequestOptions(path: "EMPTY_REQ");

  @override
  void onError(DioException err, [ErrorInterceptorHandler? handler]) {
    if(lastRequest.path != "EMPTY_REQ") {
      lastRequest.describeOnError.log("_REQUEST_");
    }
    err.describe.log("NETWORK_ERROR");

    handler?.next(err);
    // super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ApiConfig.authError = false;
    // print("TOKEN IN DIO ${ApiConfig.dio.dioToken}");
    // print("TOKEN IN DIO ${ApiConfig.dio.options.headers["Authorization"]}");

    "Request to ${options.path}\n"
    "Request data ${options.data}\n"
    "Request query ${options.queryParameters.encode}".log();

    lastRequest = options;
    if (!kDebugMode) {
      lastRequest.describeOnError.log();
    }

    handler.next(options);
    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // if (!(response.data["success"] as bool)) {
    //   // if ((response.data["msg"] as String?)?.contains('Ошибка авторизации') ??
    //   //     false) {
    //   //   print("TOKEN IN DIO ${ApiConfig.dio.options.headers["Authorization"]}");
    //   //   ApiConfig.authError = true;
    //   // }
    //
    //   onError(DioException(
    //     requestOptions: response.requestOptions,
    //     response: response,
    //     error: response,
    //     type: DioExceptionType.unknown,
    //     message: response.data["msg"],
    //   ));
    // }
    response.describe.log("_RESPONSE_");
    handler.next(response);
    // super.onResponse(response, handler);
  }
}