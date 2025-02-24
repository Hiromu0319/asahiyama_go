import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../util/json_converters/union_timestamp.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required int type,
    @Default('') String? name,
    @Default('') String? email,
    @Default(0) int? postCount,
    @Default(0) int? likeCount,
    @Default(0) int? commentCount,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  factory Profile.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Profile.fromJson(<String, dynamic>{
      ...data,
      'id': ds.id,
    });
  }

}

@freezed
class Post with _$Post {
  const factory Post({
    required String category,
    required String postsId,
    required String userId,
    required String imagePath,
    required String postImageUrl,
    @Default('') String? message,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Post.fromJson(<String, dynamic>{
      ...data,
      'postsId': ds.id,
    });
  }

}

@freezed
class Like with _$Like {
  const factory Like({
    required String likesId,
    required String postsId,
    required String postImageUrl,
    required String notificationsId,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Like;

  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);

  factory Like.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Like.fromJson(data);
  }

}

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String commentsId,
    required String notificationsId,
    required String postsId,
    @Default('') String? message,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Comment.fromJson(data);
  }

}

@freezed
class Notification with _$Notification {
  const factory Notification({
    required String notificationsId,
    required String usersId,
    required int type,
    @Default('') String? name,
    @Default('') String? message,
    @unionTimestampConverter required UnionTimestamp createdAt,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  factory Notification.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Notification.fromJson(data);
  }

}