import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/feature/order/api/models/remote_driver_order_container.dart';
import 'package:tracking_app/feature/order/api/models/remote_order_model.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import '../../../../core/constants/json_serlization_constants.dart';
import '../../../home/api/models/metadata_model.dart';

part 'order_driver_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDriverResponse {
  @JsonKey(name: JsonSerlizationConstants.message)
  String? message;

  @JsonKey(name: JsonSerlizationConstants.metadata)
  MetadataModel? metadata;

  @JsonKey(name: JsonSerlizationConstants.orders)
  List<RemoteDriverOrderContainer>? orders;

  OrderDriverResponse({this.message, this.metadata, this.orders});

  factory OrderDriverResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDriverResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDriverResponseToJson(this);

  OrderDriverEntity toEntity() {
    return OrderDriverEntity(
      orders: orders!.map((order) => order.toEntity()).toList(),
    );
  }
}
