// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatarUrl'] as String,
  profileImageUrl: json['profileImageUrl'] as String,
  followers: (json['followers'] as num?)?.toInt() ?? 0,
  following: (json['following'] as num?)?.toInt() ?? 0,
  bio: json['bio'] as String? ?? '',
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'avatarUrl': instance.avatarUrl,
  'profileImageUrl': instance.profileImageUrl,
  'followers': instance.followers,
  'following': instance.following,
  'bio': instance.bio,
};
