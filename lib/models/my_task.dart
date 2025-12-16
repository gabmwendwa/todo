import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'my_task.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class MyTask {
  MyTask();

  @JsonKey(name: 'id')
  late String? id;

  @JsonKey(name: 'category_list_id')
  late String? category_list_id;

  @JsonKey(name: 'title')
  late String? title;

  @JsonKey(name: 'notes')
  late String? notes;

  @JsonKey(name: 'status')
  late String? status;

  @JsonKey(name: 'level')
  late String? level;

  @JsonKey(name: 'the_time')
  late String? the_time;

  @JsonKey(name: 'the_date')
  late String? the_date;

  @JsonKey(name: 'timestamp')
  late String? timestamp;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory MyTask.fromJson(Map<String, dynamic> json) => _$MyTaskFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$MyTaskToJson(this);
}
