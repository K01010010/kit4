part of '../kit4.dart';

class Storage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> writeToSecureStorage(Enum key, String? value) async {
    await _secureStorage.write(key: key.toString(), value: value);
  }

  static Future<String?> readFromSecureStorage(Enum key) async {
    return await _secureStorage.read(key: key.toString());
  }

  static Future<void> deleteFromSecureStorage(Enum key) async {
    await _secureStorage.delete(key: key.toString());
  }

  static Future<void> writeToSharedPreferences<T>(
      Enum key, dynamic value) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (T == String) {
      await sharedPrefs.setString(key.toString(), value);
      return;
    }
    if (T == int) {
      await sharedPrefs.setInt(key.toString(), value);
      return;
    }
    if (T == double) {
      await sharedPrefs.setDouble(key.toString(), value);
      return;
    }
    if (T == bool) {
      await sharedPrefs.setBool(key.toString(), value);
      return;
    }
    if (T == List<String>) {
      await sharedPrefs.setStringList(key.toString(), value);
      return;
    }

    if (T == Uint8List) {
      await sharedPrefs.setString(key.toString(), base64Encode(value));
      return;
    }
    if (T == List<Uint8List>) {
      List<String> encoded = [];
      for (var element in (value as List<Uint8List>)) {
        encoded.add(base64Encode(element));
      }
      await sharedPrefs.setStringList(key.toString(), encoded);
      return;
    }
    if (T == Map) {
      await sharedPrefs.setString(key.toString(), jsonEncode(value));
      return;
    }

    try {
      throw Exception("type = $T not handled : write handle in writeToSharedPreferences<T>()");
      // sharedPrefs.setString(key.toString(), jsonEncode(value));
    } catch (e, st) {
      "Storage.writeToSharedPreferences -> ".recordError(e,st);
    }
  }

  static Future<T?> readFromSharedPreferences<T>(Enum key) async {
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      if (T == int) return sharedPrefs.getInt(key.toString()) as T?;
      if (T == double) return sharedPrefs.getDouble(key.toString()) as T?;
      if (T == bool) return sharedPrefs.getBool(key.toString()) as T?;
      if (T == String) {
        //print(sharedPrefs.getString(key.toString()));
        return sharedPrefs.getString(key.toString()) as T?;
      }
      if (T == List<String>) {
        return (sharedPrefs.getStringList(key.toString()) ?? []) as T?;
      }
      if (T == Uint8List) {
        var str = sharedPrefs.getString(key.toString());
        return (str != null ? base64Decode(str) : null) as T?;
      }
      if (T == List<Uint8List>) {
        var str = sharedPrefs.getStringList(key.toString());
        return (str?.map((e) => base64Decode(e)).toList() ?? <Uint8List>[])
            as T?;
      }
      if (T == Map) {
        var json = sharedPrefs.getString(key.toString());
        return (json == null ? null : jsonDecode(json));
      }

      return jsonDecode(sharedPrefs.getString(key.toString()) ?? "");
    } catch (e, st) {
      "Storage.readFromSharedPreferences -> ".recordError(e,st);
      return null;
    }
  }

  static Future<void> deleteFromSharedPreferences(Enum key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove(key.toString());
  }
}
