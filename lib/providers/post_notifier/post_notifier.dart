import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/post/post.dart';
import '../../repository/post_repository/post_repository.dart';

part 'post_notifier.g.dart';

@Riverpod(keepAlive: true)
class PostNotifier extends _$PostNotifier {
  @override
  PostState build() => PostState.notPress;

  Future<void> upload({
    required String category,
    required String name,
    required XFile image,
    required String pushToken,
    String? message,
  }) async {
    state = PostState.loading;

    final img.Image? originalImage =
    img.decodeImage(File(image.path).readAsBytesSync());
    final img.Image resizedImage =
    img.copyResize(originalImage!, width: 300);

    final List<int> resizedBytes = img.encodeBmp(resizedImage);
    final Uint8List resizedUint8List =
    Uint8List.fromList(resizedBytes);

    final postRepository = ref.read(postRepositoryProvider);
    await postRepository.upload(
        category: category,
        name: name,
        imagePath: image.path,
        pushToken: pushToken,
        resizedUint8List: resizedUint8List,
        message: message
    );

    state = PostState.notPress;
  }

}

enum PostState {
  loading,
  notPress
}

@Riverpod(keepAlive: true)
Stream<List<Post>> fetchPost(ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return postRepository.fetch();
}

@Riverpod(keepAlive: true)
Stream<List<Post>> fetchPostCategory(ref, {
  required String category
}) {
  final postRepository = ref.read(postRepositoryProvider);
  return postRepository.fetchCategory(category: category);
}