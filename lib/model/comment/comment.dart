import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../util/json_converters/union_timestamp.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String userId,
    required String name,
    required String postsId,
    required String postImageUrl,
    required String targetUserId,
    required String pushToken,
    required String message,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Comment.fromJson(<String, dynamic>{
      ...data,
      'userId': ds.id,
    });
  }

}