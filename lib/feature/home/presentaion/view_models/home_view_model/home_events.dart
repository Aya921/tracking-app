import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';

abstract class HomeEvents {}

class GetAllPaindingOrdersEvent extends HomeEvents {}

class SaveDataToLocalEvent extends HomeEvents {
  final List<OrderEntity>? orders;

  SaveDataToLocalEvent(this.orders);
}

class GetAllLocalOrdersEvent extends HomeEvents {}

class GetOrdersEvent extends HomeEvents {}

class DeleteOrderLocalyEvent extends HomeEvents {
  String orderId;
  DeleteOrderLocalyEvent(this.orderId);
}

class RefreshOrdersEvent extends HomeEvents {}

class StartOrderEvent extends HomeEvents {
  String orderId;

  StartOrderEvent(this.orderId);
}

class AddDataToRemoteEvent extends HomeEvents {
  RemoteDataEntity remoteDataEntity;
  AddDataToRemoteEvent(this.remoteDataEntity);
}

class StartProgressEvnet extends HomeEvents {
  RemoteDataEntity remoteDataEntity;
  StartProgressEvnet(this.remoteDataEntity);
}

class GetDataFromRemoteEvent extends HomeEvents {
  String orderId;
  GetDataFromRemoteEvent(this.orderId);
}

class CallUserEvent extends HomeEvents {
  final String phoneNumber;
  CallUserEvent(this.phoneNumber);
}

class WhatsAppUserEvent extends HomeEvents {
  final String phoneNumber;
  final String? message;
  WhatsAppUserEvent(this.phoneNumber, {this.message});
}

class UpdateOrderStateEvnet extends HomeEvents {
  final String orderId;
  final String newState;
  UpdateOrderStateEvnet({required this.newState, required this.orderId});
}
