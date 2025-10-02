import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';

class HomeStates {
  final bool isLoading;
  final List<OrderEntity>? orders;
  String? errorMessage;
  bool? orderStarted;
  bool? addedToRemote;
  bool? processCompleted;
  RemoteDataEntity? remoteData;

  HomeStates({
    this.isLoading = true,
    this.orders,
    this.errorMessage,
    this.orderStarted = false,
    this.addedToRemote = false,
    this.processCompleted = false,
    this.remoteData ,

  });

  HomeStates copyWith({
    bool? isLoading,
    List<OrderEntity>? orders,
    String? errorMessage,
    bool? orderStarted,
    bool? addedToRemote,
    bool? processCompleted,
    RemoteDataEntity? remoteData,
  }) {
    return HomeStates(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      errorMessage: errorMessage, // update to be false
      orderStarted: orderStarted, // update to be false
      addedToRemote: addedToRemote, // update to be false
      processCompleted: processCompleted, // update to be false
      remoteData: remoteData,
    );
  }
}
