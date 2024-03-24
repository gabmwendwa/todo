// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyTask _$MyTaskFromJson(Map<String, dynamic> json) => MyTask()
  ..id = json['id'] as String?
  ..category_list_id = json['category_list_id'] as String?
  ..title = json['title'] as String?
  ..notes = json['notes'] as String?
  ..status = json['status'] as String?
  ..level = json['level'] as String?
  ..the_time = json['the_time'] as String?
  ..the_date = json['the_date'] as String?
  ..timestamp = json['timestamp'] as String?;

Map<String, dynamic> _$MyTaskToJson(MyTask instance) => <String, dynamic>{
      'id': instance.id,
      'category_list_id': instance.category_list_id,
      'title': instance.title,
      'notes': instance.notes,
      'status': instance.status,
      'level': instance.level,
      'the_time': instance.the_time,
      'the_date': instance.the_date,
      'timestamp': instance.timestamp,
    };
