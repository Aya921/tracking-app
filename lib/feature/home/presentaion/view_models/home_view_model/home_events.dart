import 'package:equatable/equatable.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';

abstract class HomeEvents extends Equatable {
  const HomeEvents();

  @override
  List<Object?> get props => [];
}

class GetAllPaindingOrdersEvent extends HomeEvents {}

class SaveDataToLocalEvent extends HomeEvents {
  final List<OrderEntity>? orders;

  const SaveDataToLocalEvent(this.orders);

  @override
  List<Object?> get props => [orders];
}

class GetAllLocalOrdersEvent extends HomeEvents {}

class GetOrdersEvent extends HomeEvents {}

class DeleteOrderLocalyEvent extends HomeEvents {
  final String orderId;
  const DeleteOrderLocalyEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class RefreshOrdersEvent extends HomeEvents {}

class StartOrderEvent extends HomeEvents {
  final String orderId;
  const StartOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class AddDataToRemoteEvent extends HomeEvents {
  final RemoteDataEntity remoteDataEntity;
  const AddDataToRemoteEvent(this.remoteDataEntity);

  @override
  List<Object?> get props => [remoteDataEntity];
}

class StartProgressEvnet extends HomeEvents {
  final RemoteDataEntity remoteDataEntity;
  const StartProgressEvnet(this.remoteDataEntity);

  @override
  List<Object?> get props => [remoteDataEntity];
}

class GetDataFromRemoteEvent extends HomeEvents {
  final String orderId;
  const GetDataFromRemoteEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CallUserEvent extends HomeEvents {
  final String phoneNumber;
  const CallUserEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class WhatsAppUserEvent extends HomeEvents {
  final String phoneNumber;
  final String? message;
  const WhatsAppUserEvent(this.phoneNumber, {this.message});

  @override
  List<Object?> get props => [phoneNumber, message];
}
