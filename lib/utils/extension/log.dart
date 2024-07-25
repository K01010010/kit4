part of 'extensions.dart';

extension StringExtension on String {

  void recordError([dynamic err, StackTrace? st]) {
    if (kDebugMode) {
      if (err is DioException && err.message != null) {
        err = err.message;
      }
      "$err\n\nSTACKTRACE: $st".printFull(debugTag: this);
    } else {
      BaseLoggerService.recordError(
          "######$this######\n$err\n######$this######", st);
    }
  }

  void log([String? debugTag]) =>
      // ignore: avoid_print
      kDebugMode
          ? printFull(debugTag: debugTag ?? "DEBUG_TAG")
          : BaseLoggerService.log(this, debugTag);

  // ignore: avoid_print
  void logConsole() => print(this);

  ///Was 1023 before adding \n in printing
  void printFull({String debugTag = "DEBUG_TAG", int maxSymbols = 1020}) {
    var str = "######$debugTag######\n$this\n######$debugTag######\n";
    if (kDebugMode) {
      while (str.length > maxSymbols) {
        String segment = str.substring(0, maxSymbols);
        print("\n$segment");
        str = str.substring(maxSymbols);
      }

      if (str.isNotEmpty) {
        print("\n$str");
      }
    } else {
      BaseLoggerService.log(this,debugTag);
    }
  }
}

extension StringDecodingExtension on String {
  Map<String, dynamic> get decode => jsonDecode(this);
}

extension MapEncodingExtension on Map {
  String get encode => jsonEncode(this);
}
