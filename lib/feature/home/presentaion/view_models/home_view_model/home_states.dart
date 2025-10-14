import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';

class HomeStates extends Equatable {
  final bool isLoading;
  final List<OrderEntity>? orders;
  final String? errorMessage;
  final bool? orderStarted;
  final bool? addedToRemote;
  final bool? processCompleted;
  final bool? updateState;
  final RemoteDataEntity? remoteData;

  const HomeStates({
    this.isLoading = true,
    this.orders,
    this.errorMessage,
    this.orderStarted = false,
    this.addedToRemote = false,
    this.processCompleted = false,
    this.updateState=false,
    this.remoteData,
  });

  HomeStates copyWith({
    bool? isLoading,
    List<OrderEntity>? orders,
    String? errorMessage,
    bool? orderStarted,
    bool? addedToRemote,
    bool? processCompleted,
    bool? updateState,
    RemoteDataEntity? remoteData,
  }) {
    return HomeStates(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      orderStarted: orderStarted ?? this.orderStarted,
      addedToRemote: addedToRemote ?? this.addedToRemote,
      processCompleted: processCompleted ?? this.processCompleted,
      updateState: updateState??this.updateState,
      remoteData: remoteData ?? this.remoteData,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        orders,
        errorMessage,
        orderStarted,
        addedToRemote,
        processCompleted,
        updateState,
        remoteData,
      ];
}