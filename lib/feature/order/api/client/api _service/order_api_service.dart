import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/constants/end_points_constants.dart';
import 'package:tracking_app/feature/order/api/models/order_driver_response.dart';

part 'order_api_service.g.dart';

@RestApi(baseUrl: EndPointsConstants.baseUrl)
@injectable
abstract class OrderApiService {
  @factoryMethod
  factory OrderApiService(Dio dio) = _OrderApiService;

  @GET(EndPointsConstants.getAllDriverOrders)
  Future<OrderDriverResponse> getAllDriverOrders(
      @Query("page") int page,
      @Query("limit") int limit,
      );

}
