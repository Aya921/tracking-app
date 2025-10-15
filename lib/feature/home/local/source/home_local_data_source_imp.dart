import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/data/source/home_local_data_source.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/feature/home/local/models/order_local_model.dart';
//import 'package:collection/collection.dart';

@Injectable(as: HomeLocalDataSource)
class HomeLocalDataSourceImp implements HomeLocalDataSource {
  final Isar _isar;
  HomeLocalDataSourceImp(this._isar);
  @override
  Future<Result<void>> saveDataToLocalStorage(List<OrderEntity>? orders) async {
    try {
      final localModels =
          orders?.map(OrderLocalModel.toLocalModel).
          toList() ?? [];
      await _isar.write((isar) async {
        isar.orderLocalModels.clear();
        isar.orderLocalModels.putAll(localModels);
      });
      return SucessResult(null);
    } catch (e) {
      return FailedResult(e.toString());
    }
  }

  @override
  Future<Result<List<OrderEntity>?>> getAllSavedOrders() async {
    try {
      final orders = _isar.orderLocalModels.where().findAll();
      final entities = orders.map((e) => e.toEntity()).toList();
      return SucessResult(entities);
    } catch (e) {
      return FailedResult(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteOrder(String orderId) async {
    try {
      final orders = _isar.orderLocalModels.where().findAll();
      final target = orders.firstWhere((e) => e.orderId == orderId);

      await _isar.write((isar) async {
        isar.orderLocalModels.delete(target.id);
      });
          return SucessResult(null);
    } catch (e) {
      return FailedResult(e.toString());
    }
  }
}
