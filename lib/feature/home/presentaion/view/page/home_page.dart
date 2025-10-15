import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/widgets/common_error.dart';
import 'package:tracking_app/core/widgets/common_loading.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/order_cards.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_bloc.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DriverEntity? driverEntity;
  final HomeViewModel _homeViewModel = getIt<HomeViewModel>();
  final ProfileBloc _profileBloc = getIt<ProfileBloc>();

  @override
  void initState() {
    super.initState();
    _homeViewModel.add(GetOrdersEvent());
    _profileBloc.add(GetLoggedDriverEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.setWidth(18)),
          child: Text(
            context.loc.floweryRider,
            style: getLightStyle(
              color: AppColors.pink,
              fontSize: context.setSp(FontSize.s24),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _homeViewModel.add(RefreshOrdersEvent());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: context.setHight(650),
            child: Padding(
              padding: EdgeInsets.all(context.setWidth(18)),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _homeViewModel),
                  BlocProvider.value(value: _profileBloc),
                ],
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<ProfileBloc, ProfileState>(
                      listener: (context, state) {
                        if (state.driver != null) {
                          setState(() {
                            driverEntity = state.driver;
                          });
                        }
                        if (state.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage!)),
                          );
                        }
                      },
                    ),
                    BlocListener<HomeViewModel, HomeStates>(
                      listener: (context, state) {
                        if (state.processCompleted == true) {
                         
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoute.orderDetails,
                            arguments: state.remoteData!.orderEntity.id,
                          );
                         
                        }
                        if (state.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage!)),
                          );
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<HomeViewModel, HomeStates>(
                    builder: (context, state) {
                      if (state.isLoading == true) {
                        return const CommonLoading();
                      }
                      if (state.orders != null) {
                        if (state.orders!.isEmpty) {
                          return CustumError(
                            errorMessage: context.loc.noOrdersFound,
                          );
                        }
                        return OrderCards(
                          orders: state.orders!,
                          driver: driverEntity,
                        );
                      }
                      return CustumError(
                        errorMessage: context.loc.unExpectedErrorfound,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
