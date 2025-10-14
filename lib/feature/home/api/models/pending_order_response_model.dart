import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/core/common/models/metadata_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_model.dart';

part 'pending_order_response_model.g.dart';

@JsonSerializable()
class PendingOrderResponseModel {
  @JsonKey(name: JsonSerlizationConstants.message)
  String? message;

  @JsonKey(name: JsonSerlizationConstants.metadata)
  MetadataModel? metadata;

  @JsonKey(name: JsonSerlizationConstants.orders)
  List<OrderModel>? orders;

  PendingOrderResponseModel({this.message, this.metadata, this.orders});

  factory PendingOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PendingOrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PendingOrderResponseModelToJson(this);
}
