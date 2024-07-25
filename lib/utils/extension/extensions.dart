import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kit4/kit4.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

part 'color.dart';
part 'log.dart';
part 'network.dart';
part 'plural_number.dart';
part 'time.dart';

extension FutureList on List {
  Future<Iterable<T>> transform<T>(Future<T> Function(T e) method) async {
    List<T> result = <T>[];
    for (T value in this) {
      result.add(await method(value));
    }
    return result;
  }
}

extension String2StringExtension on String {
  String get svgAsset => 'assets/svg/$this.svg';
  String get pngAsset => 'assets/png/$this.png';
}
extension PaddingExtension on Widget {
  Widget padAll(double all) => Padding(
        padding: EdgeInsets.all(all),
        child: this,
      );

  Widget padSymmetric({double? h, double? v}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: h ?? 0, vertical: v ?? 0),
        child: this,
      );
}