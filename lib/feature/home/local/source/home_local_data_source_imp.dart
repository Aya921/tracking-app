import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/data/source/home_local_data_source.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/local/models/order_local_model.dart';

@Injectable(as: HomeLocalDataSource)
class HomeLocalDataSourceImp implements HomeLocalDataSource {
  final Isar _isar;
  HomeLocalDataSourceImp(this._isar);

  @override
  Future<Result<void>> saveDataToLocalStorage(List<OrderEntity>? orders)
  async {
    try {
      await _isar.writeTxn(() async {
        await _isar.orderLocalModels.clear();
        await _isar.orderLocalModels.putAll(
          orders?.map(OrderLocalModel.toLocalModel).toList() ?? [],
        );

     
      });
      return SucessResult(null);
    } catch (e) {
      return FailedResult(e.toString());
    }
  }
  
  @override
  Future<Result<List<OrderEntity>?>> getAllSavedOrders()async {
    try{
   
     final orders = await _isar.orderLocalModels.where().findAll();

   
    final entities = orders.map((e) => e.toEntity()).toList();


    return SucessResult(entities);
    }
   catch (e) {
    return FailedResult(e.toString());
  
   }
}

  @override
  Future<Result<void>> deleteOrder(String orderId)async {
    try{
      await _isar.writeTxn(() async {
  
      final order = await _isar.orderLocalModels
          .filter()
          .orderIdEqualTo(orderId)
          .findFirst();

      if (order != null) {
        
        await _isar.orderLocalModels.delete(order.id);
      }
    });

    return SucessResult(null);

    }
    catch(e){
       return FailedResult(e.toString());

    }
  }


  
}

