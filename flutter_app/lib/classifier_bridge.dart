import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef InitDbNative = Int32 Function(Pointer<Utf8>);
typedef InitDbDart = int Function(Pointer<Utf8>);

typedef ClassifyNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef ClassifyDart = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef SaveNative = Int32 Function(
    Pointer<Utf8>, Pointer<Utf8>, Float);
typedef SaveDart = int Function(
    Pointer<Utf8>, Pointer<Utf8>, double);

typedef CloseDbNative = Void Function();
typedef CloseDbDart = void Function();

final dylib = DynamicLibrary.open(
    'libclassifier_lib.dll');

final initDbFunc =
    dylib.lookupFunction<InitDbNative, InitDbDart>(
        'init_db');

final classifyFunc =
    dylib.lookupFunction<ClassifyNative, ClassifyDart>(
        'classify_bookmark');

final saveFunc =
    dylib.lookupFunction<SaveNative, SaveDart>(
        'save_bookmark');

final closeDbFunc =
    dylib.lookupFunction<CloseDbNative, CloseDbDart>(
        'close_db');

void initDatabase() {
  final path = 'data/bookmarks.db'.toNativeUtf8();
  initDbFunc(path);
  malloc.free(path);
}

Map<String, dynamic> classifyBookmark(
    String caption, String hashtags) {
  final captionPtr = caption.toNativeUtf8();
  final hashtagsPtr = hashtags.toNativeUtf8();

  final resultPtr = classifyFunc(
      captionPtr, hashtagsPtr);
  final result = resultPtr.toDartString();

  malloc.free(captionPtr);
  malloc.free(hashtagsPtr);

  final parts = result.split(':');
  return {
    'category': parts[0],
    'confidence': double.parse(parts[1]),
  };
}

void saveBookmark(String postId,
    String category, double confidence) {
  final postIdPtr = postId.toNativeUtf8();
  final categoryPtr = category.toNativeUtf8();

  saveFunc(postIdPtr, categoryPtr, confidence);

  malloc.free(postIdPtr);
  malloc.free(categoryPtr);
}

void closeDatabase() {
  closeDbFunc();
}