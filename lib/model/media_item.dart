part of '../kit4.dart';

class MediaItem extends _MediaItemBase {
  // ignore: library_private_types_in_public_api
  final _MediaItemBase item;

  MediaItem._(this.item);

  // ignore: library_private_types_in_public_api
  factory MediaItem.withBasic(_MediaItemBase base) => MediaItem._(base);

  factory MediaItem.bytes(Uint8List bytes, String mimeType, String url) =>
      MediaItem._(
        ByteMediaItem(
          bytes,
          // url,
        ),
      );

  factory MediaItem.url(String url) => MediaItem._(UrlMediaItem(url));

  factory MediaItem.file(File file) => MediaItem._(FileMediaItem(file));

  factory MediaItem.png(String name) => MediaItem._(PngMediaItem(name));


  @override
  Widget getImage({BoxFit? fit, double? height, double? width}) =>
      item.getImage(fit: fit, height: height, width: width);

  @override
  ImageProvider<Object> getProvider() => item.getProvider();

  factory MediaItem.fromRawJson(String str) =>
      MediaItem.fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(toJson());

  factory MediaItem.fromJson(Map<dynamic, dynamic> json) => MediaItem._(
        json.containsKey('bytes')
            ? ByteMediaItem.fromJson(json)
            : (json.containsKey('url')
                ? UrlMediaItem.fromJson(json)
                : PngMediaItem.fromJson(json)),
        //json.containsKey('')
      );

  @override
  Map<String, dynamic> toJson() => item.toJson();
}

class PngMediaItem extends _MediaItemBase {
  final String namePng;

  PngMediaItem(this.namePng);

  @override
  Widget getImage({BoxFit? fit, double? height, double? width}) {
    return Image.asset(
      'assets/png/$namePng.png',
      height: height,
      width: width,
      fit: fit,
    );
  }

  @override
  ImageProvider<Object> getProvider() => AssetImage('assets/png/$namePng.png');

  @override
  Map<String, dynamic> toJson() => {"path": namePng};

  factory PngMediaItem.fromJson(Map<dynamic, dynamic> json) =>
      PngMediaItem(json["path"]);
}

class ByteMediaItem extends _MediaItemBase {
  final Uint8List bytes;
  // final String? url;

  ByteMediaItem(this.bytes);//, this.url);

  @override
  Widget getImage({BoxFit? fit, double? height, double? width}) {
    return Image.memory(
      bytes,
      height: height,
      width: width,
      fit: fit,
    );
  }

  @override
  ImageProvider<Object> getProvider() => MemoryImage(bytes);

  @override
  Map<String, dynamic> toJson() => {
        "bytes": List<dynamic>.from(bytes.map((x) => x)),
        // if (url != null)
        // "url": ur/l,
      };

  // bytes: Uint8List.fromList(json["bytes"] == null ? [] : List<int>.from(json["bytes"]!.map((x) => x))),
  factory ByteMediaItem.fromJson(Map<dynamic, dynamic> json) => ByteMediaItem(
        Uint8List.fromList(json["bytes"] == null
            ? []
            : List<int>.from(json["bytes"]!.map((x) => x))),
        // json.containsKey("url") ? json["url"] : "",
      );

  static Future<ByteMediaItem?> fromUrl(String url) => UrlMediaItem(url).urlItem2byteItem();
}

class UrlMediaItem extends _MediaItemBase {
  static String baseImageUrl = "";
  final String url;

  UrlMediaItem(this.url);

  Future<ByteMediaItem?> urlItem2byteItem() async {
    try{
      var bytes = (await NetworkAssetBundle(Uri.parse(fullUrl))
          .load(fullUrl))
          .buffer
          .asUint8List();
      return ByteMediaItem(bytes);//, url);
    } catch (e,st) {
      "UrlMediaItem2ByteMediaItem() CONVERT_ERROR".recordError(e,st);
    }
    return null;
  }

  @override
  Widget getImage({BoxFit? fit, double? height, double? width}) {
    return CachedNetworkImage(
        height: height, width: double.maxFinite, imageUrl: fullUrl, fit: fit);
  }

  String get fullUrl => "$baseImageUrl/$url";

  @override
  Map<String, dynamic> toJson() => {"url": url};

  factory UrlMediaItem.fromJson(Map<dynamic, dynamic> json) =>
      UrlMediaItem(json["url"]);

  @override
  ImageProvider<Object> getProvider() => CachedNetworkImageProvider(fullUrl);
}

class FileMediaItem extends _MediaItemBase {
  final File file;

  FileMediaItem(this.file);

  // String get fullUrl{
  //   if(url?.isEmpty ?? true) return '';
  //   return "${ApiConfig.imageUrl}/${url!}";
  // }
  // List<String> get urls {
  //   return pictures.map((pic) => "${ApiConfig.imageUrl}/$pic").toList();
  // }

  @override
  Widget getImage({BoxFit? fit, double? height, double? width}) {
    return Image.file(file, height: height, width: width, fit: fit);
  }

  // String get mimeString => file.mimeString;
  // 'image/${file.mimeString.split('.')
  // .last
  // .toLowerCase()}';

  @override
  Map<String, dynamic> toJson() =>
      throw Exception("Media Item Files - не приготовлено к сериализации");

  factory FileMediaItem.fromJson(Map<dynamic, dynamic> json) =>
      throw Exception("Media Item Files - не приготовлено к десериализации");

  @override
  ImageProvider<Object> getProvider() => FileImage(file);
}

abstract class _MediaItemBase {
  Widget getImage({BoxFit? fit, double? height, double? width});

  Map<String, dynamic> toJson();

  ImageProvider<Object> getProvider();
}
// extension FileExtension on File {
//   String get pathMimeString => 'image/${path
//       .split('.')
//       .last
//       .toLowerCase()}';
//
//   // String get mimeString => lookupMimeType(path) ?? pathMimeString;
// }
