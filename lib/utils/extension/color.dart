part of 'extensions.dart';

extension ColorToStringExtension on Color {
  String get hashString => "0x${value.toRadixString(16).padLeft(8, '0')}";
}

// extension StringToColorExtension on String {
//   Color get hexToColor => Color(int.parse(this));
// }

extension FilterExtension on Color {
  ColorFilter get filter => ColorFilter.mode(this, BlendMode.srcIn);
}
