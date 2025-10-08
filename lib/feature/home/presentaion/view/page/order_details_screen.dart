import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/enums/address_type.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/widgets/common_loading.dart';
import 'package:tracking_app/feature/home/api/client/firebase_service/home_firebase_service.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/address_container.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/order_details_card.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/status_container.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/step_progress_indicator.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/total_and_payment_container.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({required this.orderId, super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentStep = -1;

  late final List<String> buttonLabels;
  final HomeViewModel _homeViewModel = getIt.get<HomeViewModel>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    buttonLabels = [
      context.loc.arrivedAtPickupPoint,
      context.loc.startDeliver,
      context.loc.arrivedToUser,
      context.loc.deliverToUser,
    ];
  }

  void _nextStep() async {
    if (currentStep < buttonLabels.length - 1) {
      setState(() {
        currentStep++;
      });

      // update state in firebase
      final newState = _mapStepToState(currentStep);
       _homeViewModel.add(UpdateOrderStateEvnet(newState: newState, orderId:widget.orderId));

      
    }
  }

  @override
  void initState() {
    super.initState();
    getIt<HomeFirebaseService>().getDataFromRemote(widget.orderId).listen((
      data,
    ) {
      setState(() {
        currentStep = _mapStateToStep(data.orderDeliveryStatus ?? 'waiting');
      });
    });
  }

  int _mapStateToStep(String state) {
    switch (state) {
      case 'received':
        return 0;
      case 'preparing':
        return 1;
      case 'outForDelivery':
        return 2;
      case 'delivered':
        return 3;
      default:
        return -1;
    }
  }

  String _mapStepToState(int step) {
    switch (step) {
      case 0:
        return 'received';
      case 1:
        return 'preparing';
      case 2:
        return 'outForDelivery';
      case 3:
        return 'delivered';
      default:
        return 'Placed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.orderDetailsTitle),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Padding(
            padding: EdgeInsets.only(right: context.setWidth(2)),
            child: Icon(Icons.arrow_back_ios, size: context.setSp(20)),
          ),
        ),
      ),
      body: BlocProvider.value(
        value: getIt<HomeViewModel>()
          ..add(GetDataFromRemoteEvent(widget.orderId)),
        child: BlocConsumer<HomeViewModel, HomeStates>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const CommonLoading();
            }

            if (state.remoteData == null) {
              return Center(child: Text(context.loc.noOrdersFound));
            }

            final order = state.remoteData!.orderEntity;
            final driver = state.remoteData!.driverEntity;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(context.setHight(15)),
                  child: StepIndicator(
                    currentStep: currentStep,
                    stepsLength: buttonLabels.length,
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StatusContainer(order: order),
                        SizedBox(height: context.setHight(15)),

                        Text(
                          context.loc.pickupAddress,
                          style: getMediumStyle(
                            color: AppColors.black,
                            fontSize: context.setSp(FontSize.s18),
                          ),
                        ),
                        AddressContainer(
                          addressType: AddressType.store,
                          orderEntity: order,
                          phoneNum: order.store.phoneNumber,
                          fromOrderDetails: true,
                        ),
                        SizedBox(height: context.setHight(15)),

                        Text(
                          context.loc.userAddress,
                          style: getMediumStyle(
                            color: AppColors.black,
                            fontSize: context.setSp(FontSize.s18),
                          ),
                        ),
                        AddressContainer(
                          addressType: AddressType.user,
                          orderEntity: order,
                          phoneNum: driver.phone,
                          fromOrderDetails: true,
                        ),
                        SizedBox(height: context.setHight(15)),

                        Text(
                          context.loc.orderDetailsTitle,
                          style: getMediumStyle(
                            color: AppColors.black,
                            fontSize: context.setSp(FontSize.s18),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.orderItems.length,
                          itemBuilder: (context, index) {
                            return OrderDetailsCard(
                              orderItemEntity: order.orderItems[index],
                            );
                          },
                        ),
                        SizedBox(height: context.setHight(15)),

                        TotalAndPaymentContainer(
                          containerName: context.loc.total,
                          containerValue:
                              "${context.loc.egp} ${order.orderInfoEntity.totalPrice.toString()}",
                        ),
                        SizedBox(height: context.setHight(15)),

                        TotalAndPaymentContainer(
                          containerName: context.loc.paymentMethod,
                          containerValue: order.paymentInfoEntity.paymentType,
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: getMediumStyle(
                              color: AppColors.white,
                              fontSize: context.setSp(FontSize.s16),
                            ),
                            backgroundColor:
                                currentStep == buttonLabels.length - 1
                                ? AppColors.gray
                                : AppColors.pink,
                          ),
                          onPressed: currentStep == buttonLabels.length - 1
                              ? null
                              : _nextStep,
                          child: Text(
                            currentStep == -1
                                ? context.loc.arrivedAtPickupPoint
                                : buttonLabels[currentStep],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
