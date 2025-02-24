import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../util/json_converters/union_timestamp.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String userId,
    required String name,
    required String imagePath,
    required String postImageUrl,
    required String pushToken,
    required String category,
    @Default('') String? message,
    @Default(0) int? likeCount,
    @Default(0) int? commentCount,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Post.fromJson(<String, dynamic>{
      ...data,
      'userId': ds.id,
    });
  }

}