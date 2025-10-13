import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/home/api/models/metadata_model.dart';
import 'package:tracking_app/feature/order/api/models/remote_order_model.dart';


part 'pending_order_response_model.g.dart';

@JsonSerializable()
class PendingOrderResponseModel {
  @JsonKey(name: JsonSerlizationConstants.message)
  String? message;

  @JsonKey(name: JsonSerlizationConstants.metadata)
  MetadataModel? metadata;

  @JsonKey(name: JsonSerlizationConstants.orders) 
  List<RemoteOrderModel>? orders;

  PendingOrderResponseModel({this.message, this.metadata, this.orders});

  factory PendingOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PendingOrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PendingOrderResponseModelToJson(this);
}