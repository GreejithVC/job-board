import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
abstract class JobModel with _$JobModel {
  const factory JobModel({
    @Default("") String id,
    required String title,
    required String company,
    required String location,
    required String description,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);

}


