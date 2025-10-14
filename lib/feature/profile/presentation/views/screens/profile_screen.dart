// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:tracking_app/config/di/di.dart';
// import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
// import 'package:tracking_app/core/responsive/size_helper_extension.dart';
// import 'package:tracking_app/core/routes/app_route.dart';
// import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
// import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_bloc.dart';
// import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_event.dart';
// import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_state.dart';
// import 'package:tracking_app/feature/profile/presentation/views/widgets/custom_logout_row.dart';
// import 'package:tracking_app/feature/profile/presentation/views/widgets/custom_row.dart';
// import 'package:tracking_app/feature/profile/presentation/views/widgets/profile_container.dart';
// import 'package:tracking_app/feature/profile/presentation/views/widgets/personal_info_card.dart';
// import 'package:tracking_app/feature/profile/presentation/views/widgets/vechical_info_card.dart';
//
// class ProfileScreen extends StatefulWidget {
//
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final ProfileBloc _profileBloc = getIt.get<ProfileBloc>();
//
//   @override
//   void initState() {
//
//     _profileBloc.add(GetLoggedDriverEvent());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         title: Padding(
//           padding:  EdgeInsets.symmetric(horizontal: context.setWidth(12)),
//           child: Text(context.loc.profile),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.notifications_none_outlined,
//               color: Theme.of(context).appBarTheme.iconTheme?.color,
//             ),
//             onPressed: () {
//               // Handle settings action
//             },
//           ),
//         ],
//       ),
//
//       body:
//       BlocProvider.value(
//         value: _profileBloc,
//         child: BlocConsumer<ProfileBloc, ProfileState>(
//           listener: (context, state) {
//             if (state.loggedOut == true) {
//               Navigator.pushNamed(context, AppRoute.loginRoute);
//             }
//           },
//           builder: (context, state) {
//             if (state.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state.driver != null) {
//               final DriverEntity driver = state.driver!;
//               return Padding(
//                 padding:  EdgeInsets.all(context.setWidth(12)),
//                 child: Column(
//                   children: [
//                     ProfileContainer(
//                       onClick: () {
//                         Navigator.pushNamed(context, AppRoute.editProfileScreen,
//                             arguments: state.driver);
//                       },
//                       containerChild: PersonalInfoCard(driverEntity: driver),
//                     ),
//                     ProfileContainer(
//                       onClick: () {
//                         Navigator.pushNamed(context,
//
//                             AppRoute.editVechicalScreen,
//                             arguments: state.driver);
//                       },
//                       containerChild:
//                       VechicalInfoCard(driverEntity: driver),
//                     ),
//                     const CustomLanguageRow(),
//                     CustomLogoutRow( profileBloc: _profileBloc),
//                   ],
//                 ),
//               );
//             }
//             if (state.errorMessage != null) {
//               return Center(child: Text(state.errorMessage!));
//             }
//             return const SizedBox(child: Text("oops"));
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_bloc.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/custom_logout_row.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/custom_row.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/profile_container.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/personal_info_card.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/vechical_info_card.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _profileBloc = getIt.get<ProfileBloc>();
  @override
  void initState() {
    _profileBloc.add(GetLoggedDriverEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.setWidth(12)),
          child: Text(context.loc.profile),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _profileBloc,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.loggedOut == true) {
              Navigator.pushNamed(context, AppRoute.loginRoute);
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.driver != null) {
              final DriverEntity driver = state.driver!;
              return Padding(
                padding: EdgeInsets.all(context.setWidth(12)),
                child: Column(
                  children: [
                    ProfileContainer(
                      onClick: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoute.editProfileScreen,
                          arguments: state.driver,
                        );
                        if (result == true) {
                          _profileBloc.add(
                            GetLoggedDriverEvent(),
                          );
                        }
                      },
                      containerChild: PersonalInfoCard(driverEntity: driver),
                    ),
                    ProfileContainer(
                      onClick: ()async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoute.editVechicalScreen,
                          arguments: state.driver,
                        );
                        if (result == true) {
                          _profileBloc.add(
                            GetLoggedDriverEvent(),
                          );
                        }
                      },
                      containerChild: VechicalInfoCard(driverEntity: driver),
                    ),
                    const CustomLanguageRow(),
                    CustomLogoutRow(profileBloc: _profileBloc),
                  ],
                ),
              );
            }
            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }
            return const SizedBox(child: Text("oops"));
          },
        ),
      ),
    );
  }
}



