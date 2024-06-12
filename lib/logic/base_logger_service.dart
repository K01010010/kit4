part of '../kit4.dart';

abstract class BaseLoggerService {

  BaseLoggerService() {
    instance = this;
  }

  static BaseLoggerService? instance;

  void privateRecordError([dynamic err, StackTrace? st]);
  void privateLog(String msg, [String? debugTag]);

  static void recordError([dynamic err, StackTrace? st]) => instance?.privateRecordError(err, st);
  static void log(String msg, [String? debugTag]) => instance?.privateLog(msg, debugTag);
}