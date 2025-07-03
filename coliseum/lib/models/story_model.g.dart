// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
  id: json['id'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user.toJson(),
  'imageUrl': instance.imageUrl,
  'timestamp': instance.timestamp.toIso8601String(),
};
