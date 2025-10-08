import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_response_entity.dart';
import 'package:tracking_app/feature/home/domain/usecase/add_data_to_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/delete_local_order.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_pending_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_saved_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_data_from_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/save_data_to_local.dart';
import 'package:tracking_app/feature/home/domain/usecase/start_order_state.dart';
import 'package:tracking_app/feature/home/domain/usecase/update_order_state.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:url_launcher/url_launcher.dart';

@singleton
class HomeViewModel extends Bloc<HomeEvents, HomeStates> {
  final GetAllPendingOrdersUseCase _getAllPendingOrdersUseCase;
  final SaveDataToLocalUseCase _saveDataToLocalUseCase;
  final GetAllSavedOrdersUseCase _getAllSavedOrdersUseCase;
  final DeleteLocalOrderUseCase _deleteLocalOrderUseCase;
  final StartOrderUseCase _startOrderStateUseCase;
  final AddDataToRemoteUseCase _addDataToRemoteUseCase;
  final GetDataFromRemoteUseCase _getDataFromRemoteUseCase;
  final UpdateOrderStateUseCase _updateOrderStateUseCase;
  
  bool firtTime = true;
  HomeViewModel(
    this._getAllPendingOrdersUseCase,
    this._saveDataToLocalUseCase,
    this._getAllSavedOrdersUseCase,
    this._deleteLocalOrderUseCase,
    this._startOrderStateUseCase,
    this._addDataToRemoteUseCase,
    this._getDataFromRemoteUseCase,
    this._updateOrderStateUseCase,
  ) : super(HomeStates()) {
    on<GetAllPaindingOrdersEvent>(_getAllPedningOrders);
    on<GetAllLocalOrdersEvent>(_getLocalOrders);
    on<GetOrdersEvent>(_getOrders);
    on<DeleteOrderLocalyEvent>(_deleteOrderLocaly);
    on<RefreshOrdersEvent>(_refreshOrders);
    on<StartOrderEvent>(_startOrder);
    on<AddDataToRemoteEvent>(_addDataToRemote);
    on<StartProgressEvnet>(_startOrderProcess);
    on<GetDataFromRemoteEvent>(_getDataFromRemote);
    on<CallUserEvent>(_callUser);
    on<WhatsAppUserEvent>(_openWhatsApp);
    on<UpdateOrderStateEvnet>(_updateOrderState);
  }

  // add to firebase
  //--> if sucess then go and call startorderendpoint
  //---> if sucess then go and call getallpending orders to update screen for user
  //--->if sucess go to anthor screen
  //----> else go to home page and say that somthing went wrong please reload the page
  //----> else go and delete data from firebase
  //--else  show wrong

  Future<void> _startOrderProcess(
    StartProgressEvnet event,
    Emitter<HomeStates> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final res = await _addDataToRemoteUseCase.addDateToRemote(
      event.remoteDataEntity,
    );
    //final res = FailedResult("error in remote");   to test if error happened

    switch (res) {
      case SucessResult<void>():
        emit(state.copyWith(addedToRemote: true)); //1
        final startRes = await _startOrderStateUseCase.startOrder(
          event.remoteDataEntity.orderEntity.id,
        );

        // final startRes = FailedResult<StartOrderResponseEntity>("error in start order ");   to test if error happend

        switch (startRes) {
          case SucessResult<StartOrderResponseEntity>():
            emit(state.copyWith(orderStarted: true)); //2

            final ordersRes = await _getAllPendingOrdersUseCase
                .getAllPendingOrders();
            // final ordersRes = FailedResult<List<OrderEntity>?>("error");  to test error

            switch (ordersRes) {
              case SucessResult<List<OrderEntity>?>():
                _saveDataToLocalUseCase.saveDataToLocalStorage(
                  ordersRes.sucessResult,
                );
                emit(
                  //3
                  state.copyWith(
                    isLoading: true,
                    orders: ordersRes.sucessResult,
                    processCompleted: true,
                    remoteData: event.remoteDataEntity,
                  ),
                );

              case FailedResult<List<OrderEntity>?>():
                emit(
                  state.copyWith(
                    isLoading: false,
                    processCompleted: false,
                    errorMessage:
                        "Order started but refreshing orders failed. Please reload.",
                  ),
                );
            }

          case FailedResult<StartOrderResponseEntity>():
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: startRes.errorMessage,
                orderStarted: false,
              ),
            );
        }

      case FailedResult<void>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: res.errorMessage,
            addedToRemote: false,
          ),
        );
    }
  }

  void _getOrders(GetOrdersEvent event, Emitter<HomeStates> emit) async {
    if (firtTime) {
      await _getAllPedningOrders(GetAllPaindingOrdersEvent(), emit);
      firtTime = false;
    } else {
      await _getLocalOrders(GetAllLocalOrdersEvent(), emit);
    }
  }

  Future<void> _getAllPedningOrders(
    GetAllPaindingOrdersEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final res = await _getAllPendingOrdersUseCase.getAllPendingOrders();

    switch (res) {
      case SucessResult<List<OrderEntity>?>():
        _saveDataToLocalUseCase.saveDataToLocalStorage(res.sucessResult);
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: null,
            orders: res.sucessResult,
          ),
        );
      case FailedResult<List<OrderEntity>?>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: res.errorMessage,
            orders: null,
          ),
        );
    }
  }

  Future<void> _getLocalOrders(
    GetAllLocalOrdersEvent event,
    Emitter emit,
  ) async {
    final res = await _getAllSavedOrdersUseCase.getAllSavedOrders();
    switch (res) {
      case SucessResult<List<OrderEntity>?>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: null,
            orders: res.sucessResult,
          ),
        );
      case FailedResult<List<OrderEntity>?>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: res.errorMessage,
            orders: null,
          ),
        );
    }
  }

  Future<void> _deleteOrderLocaly(
    DeleteOrderLocalyEvent event,
    Emitter emit,
  ) async {
    final res = await _deleteLocalOrderUseCase.deleteOrder(event.orderId);

    switch (res) {
      case SucessResult():
        await _getLocalOrders(GetAllLocalOrdersEvent(), emit);

      case FailedResult():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: res.errorMessage,
            orders: null,
          ),
        );
    }
  }

  void _refreshOrders(RefreshOrdersEvent event, emit) async {
    await _getAllPedningOrders(GetAllPaindingOrdersEvent(), emit);
  }

  Future<void> _startOrder(StartOrderEvent event, Emitter emit) async {
    final res = await _startOrderStateUseCase.startOrder(event.orderId);
    switch (res) {
      case SucessResult<StartOrderResponseEntity>():
        emit(state.copyWith(orderStarted: true));

      // await _getAllPedningOrders(GetAllPaindingOrdersEvent(), emit);
      case FailedResult<StartOrderResponseEntity>():
        emit(state.copyWith(errorMessage: res.errorMessage));
    }
  }

  Future<void> _addDataToRemote(
    AddDataToRemoteEvent event,
    Emitter emit,
  ) async {
    final res = await _addDataToRemoteUseCase.addDateToRemote(
      event.remoteDataEntity,
    );
    switch (res) {
      case SucessResult<void>():
        emit(state.copyWith(addedToRemote: true));
      case FailedResult<void>():
        emit(state.copyWith(errorMessage: res.errorMessage));
    }
  }

  Future<void> _getDataFromRemote(
    GetDataFromRemoteEvent event,
    Emitter emit,
  ) async {
    await emit.forEach<Result<RemoteDataEntity>>(
      _getDataFromRemoteUseCase.getOrderFromRemote(event.orderId),
      onData: (data) {
        switch (data) {
          case SucessResult<RemoteDataEntity>():
            return state.copyWith(
              remoteData: data.sucessResult,
              isLoading: false,
            );
          case FailedResult<RemoteDataEntity>():
            return state.copyWith(
              errorMessage: data.errorMessage,
              isLoading: false,
            );
        }
      },
    );
  }

  Future<void> _callUser(CallUserEvent event, Emitter<HomeStates> emit) async {
    final Uri uri = Uri(scheme: 'tel', path: "0${event.phoneNumber}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      emit(state.copyWith(errorMessage: Constants.callError));
    }
  }

  Future<void> _openWhatsApp(
    WhatsAppUserEvent event,
    Emitter<HomeStates> emit,
  ) async {
    final phone = event.phoneNumber.startsWith("0")
        ? "2${event.phoneNumber.substring(1)}"
        : event.phoneNumber;

    final Uri uri = Uri.parse(
      "https://wa.me/$phone${event.message != null ? "?text=${Uri.encodeComponent(event.message!)}" : ""}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      emit(state.copyWith(errorMessage: Constants.whatsAppError));
    }
  }

  Future<void> _updateOrderState(
    UpdateOrderStateEvnet event,
    Emitter emit,
  ) async {
    final res = await _updateOrderStateUseCase.updateOrderState(
      event.orderId,
      event.newState,
    );
    switch (res) {
      case SucessResult<void>():
        emit(state);
      case FailedResult<void>():
        emit(state.copyWith(errorMessage: res.errorMessage));
    }
  }
}
