import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/constants/end_points_constants.dart';
import 'package:tracking_app/feature/home/api/models/update_state_request_model.dart';
import 'package:tracking_app/feature/home/api/models/pending_order_response_model.dart';
import 'package:tracking_app/feature/home/api/models/update_state_response_model.dart';

part 'home_api_service.g.dart';

@RestApi(baseUrl: EndPointsConstants.baseUrl)
@injectable
abstract class HomeApiService {
  @factoryMethod
  factory HomeApiService(Dio dio) = _HomeApiService;

  @GET(EndPointsConstants.homeEndPoint)
  Future<PendingOrderResponseModel> getAllPendingOrders();

  @PUT("${EndPointsConstants.startOrderEndPoint}{orderId}")
  Future<UpdateStateResponseModel> startOrder(@Path("orderId") String orderId);


@PUT("${EndPointsConstants.updateOrderEndPoint}{orderId}")
Future<UpdateStateResponseModel> updateOrderState(
  @Path("orderId") String orderId,
  @Body() UpdateStateRequestModel newState,
);

}
