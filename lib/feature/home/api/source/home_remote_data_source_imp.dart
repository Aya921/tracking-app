import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/safe_api_call/safe_api_call.dart';
import 'package:tracking_app/feature/home/api/client/api%20_service/home_api_service.dart';
import 'package:tracking_app/feature/home/data/source/home_remote_data_source.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_response_entity.dart';
import 'package:tracking_app/feature/home/api/client/firebase_service/home_firebase_service.dart';
import 'package:tracking_app/feature/home/api/models/remote_data_model.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final HomeApiService _homeApiService;
  final HomeFirebaseService _homeFirebaseService;

  HomeRemoteDataSourceImp(this._homeApiService, this._homeFirebaseService);

  @override
  Future<Result<List<OrderEntity>?>> getAllPendingOrders() async {
    return safeCall(() async {
      final pendingOrderResponse = await _homeApiService.getAllPendingOrders();
      return pendingOrderResponse.orders!
          .map((order) => order.toEntity())
          .toList();
    });
  }

  @override
  Future<Result<StartOrderResponseEntity>> startOrder(String orderId) async {
    return safeCall(() async {
      final orderResponse = await _homeApiService.startOrder(orderId);
      return orderResponse.orders.toEntity();
    });
  }

  @override
  Future<Result<void>> addDateToRemote(RemoteDataEntity remoteData) async {
    return await safeCall(() async {
      await _homeFirebaseService.addOrders(
        RemoteDataModel.fromEntity(remoteData),
      );
    });
  }

  @override
  Stream<Result<RemoteDataEntity>> getOrderFromRemote(String orderId) async* {
    try {
      final res = _homeFirebaseService.getDataFromRemote(orderId);
      await for (final data in res) {
        final orderEntity = data.toEntity();

        yield SucessResult(orderEntity);
      }
    } catch (error) {
      yield FailedResult(error.toString());
    }
  }

  @override
  Future<Result<void>> updateOrderState(String orderId, String newState) async {
    try {
      await _homeFirebaseService.updateOrderState(orderId, newState);
      return SucessResult(null);
    } catch (e) {
      return FailedResult(e.toString());
    }
  }
}
