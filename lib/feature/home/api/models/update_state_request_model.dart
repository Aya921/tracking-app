// To parse this JSON data, do
//
//     final updateStateRequestModel = updateStateRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';

import 'package:tracking_app/feature/home/domain/entity/start_order_request_entity.dart';

part 'update_state_request_model.g.dart';

@JsonSerializable()
class UpdateStateRequestModel {
  @JsonKey(name: JsonSerlizationConstants.state)
  String state;

  UpdateStateRequestModel({required this.state});

  factory UpdateStateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateStateRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateStateRequestModelToJson(this);

  static UpdateStateRequestModel entityToModel(
    UpdateOrderRequestEntity entity,
  ) {
    return UpdateStateRequestModel(state: entity.orderState);
  }
}
