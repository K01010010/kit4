part of 'extensions.dart';

extension ExtendingDio on Dio {
  static String? _dioToken;

  String? get dioToken => _dioToken;

  set dioToken(String? val) => _dioToken = val;

  void setToken(String? token, {String prefix = "Bearer "}) {
    dioToken = token;
    if (token == null) {
      options.headers.remove('Authorization');
    } else {
      options.headers['Authorization'] = '$prefix$token';
    }
  }
}

extension ResponseExtension on Response {
  String get describe => "\n"
      "  REQUEST was on ${requestOptions.path}\n"
      "  REQUEST TYPE ${requestOptions.method}\n"
      "  DATA of Response : ${jsonEncode(data ?? "")}\n";
}

extension RequestOptionsExtension on RequestOptions {
  String get describeOnError => "\n"
      "  REQUEST was on $path\n"
      "  REQUEST TYPE $method\n"
      "  DATA of Request : ${jsonEncode(data ?? "")}\n";
}

extension DioExceptionExtension on DioException {
  String get describe => "\n"
      "  REQUEST was on ${requestOptions.path}\n"
      "  REQUEST TYPE ${requestOptions.method}\n"
      "  DATA of Error : ${jsonEncode(requestOptions.data ?? "")}\n"
      "  ERROR of Error : $errorMessage\n"
      "  TYPE of Error  : $type\n"
      "  RESPONSE of Error : $response\n";

  String? get errorMessage {
    try {
      return response?.data["msg"];
    } catch (e) {
      return null;
    }
  }
}
