import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/feature/order/api/models/remote_order_model.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import 'package:tracking_app/feature/auth/api/models/apply/response/apply_response/all_vehicles_response.dart';

part 'order_driver_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDriverResponse {
  final String message;
  final Metadata metadata;
  final List<RemoteOrderModel> orders;

  OrderDriverResponse({
    required this.message,
    required this.metadata,
    required this.orders,
  });

  factory OrderDriverResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDriverResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDriverResponseToJson(this);

  OrderDriverEntity toEntity() {
    return OrderDriverEntity(
      orders: orders.map((order) => order.toEntity()).toList(),
    );
  }
}
