import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../util/json_converters/union_timestamp.dart';

part 'like.freezed.dart';
part 'like.g.dart';

@freezed
class Like with _$Like {
  const factory Like({
    required String userId,
    required String name,
    required String postsId,
    required String postImageUrl,
    required String targetUserId,
    required String pushToken,
    required String category,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Like;

  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);

  factory Like.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Like.fromJson(<String, dynamic>{
      ...data,
      'userId': ds.id,
    });
  }

}