import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/presentation/view/widgets/custom_btn.dart';
import 'package:tracking_app/feature/auth/presentation/view/widgets/custom_txt_field.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_bloc.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_event.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_states.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_vehicle_request.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/edit_profile_view_model/edit_profile_bloc.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/load_image.dart';

class EditVehicleInfo extends StatefulWidget {
  final DriverEntity user;

  const EditVehicleInfo({required this.user, super.key});

  @override
  State<EditVehicleInfo> createState() => _EditVehicleInfoState();
}

class _EditVehicleInfoState extends State<EditVehicleInfo> {
  late String vehicleType;
  late TextEditingController vehicleNumber;
  File? vehicleLicense;

  Future<File> _saveTemporyFile(XFile pickedFiled) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedFile = await File(
      "${directory.path}/$fileName",
    ).writeAsBytes(await pickedFiled.readAsBytes());
    return savedFile;
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      return await _saveTemporyFile(pickedFile);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    vehicleType = widget.user.vehicle.type;
    vehicleNumber =
        TextEditingController(text: widget.user.vehicle.number );
  }

  @override
  void dispose() {
    vehicleNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => getIt<EditProfileBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.loc.editProfileTitle),
              leading: IconButton(
                onPressed: () => Navigator.of(context).
                pop(true),
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: context.setSp(24),
                  color: AppColors.black,
                ),
              ),
              actions: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Icon(
                      CupertinoIcons.bell,
                      color: AppColors.black,
                      size: context.setSp(32),
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.red,
                      radius: 10,
                      child: Text(
                        "3",
                        style: getMediumStyle(
                          color: AppColors.white,
                          fontSize: context.setSp(11),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: context.setWidth(12)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: Column(
                children: [
                  BlocProvider(
                    create: (context) =>
                    getIt<ApplyBloc>()..add(GetAllVehiclesEvent()),
                    child: BlocBuilder<ApplyBloc, ApplyStates>(
                      builder: (context, state) {
                        return DropdownButtonFormField(
                          validator: (value) =>
                          value == null ? context.loc.vehicleTypeFieldError : null,
                          decoration: InputDecoration(
                            labelText: context.loc.vehicleType,
                          ),
                          items: state.vehicle.map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(e.type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              vehicleType = value;
                              setState(() {});
                            }
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.setHight(20)),
                  CustomTxtField(
                    hintTxt: context.loc.vehicleNumber,
                    lbl: context.loc.vehicleNumber,
                    controller: vehicleNumber,
                    validator: (value) =>
                    value == null ? context.loc.vehicleNumber : null,
                  ),
                  SizedBox(height: context.setHight(20)),
                  LoadImage(
                    file: vehicleLicense,
                    networkUrl: widget.user.vehicle.license,
                    onTap: () async {
                      final file = await _pickImage();
                      if (file != null) {
                        setState(() {
                          vehicleLicense = file;
                        });
                      }
                    },
                    lbl: context.loc.vehicleNumber,
                  ),
                  SizedBox(height: sh * 0.4),
                  BlocListener<EditProfileBloc, EditProfileState>(
                    listener: (context, state) {
                      if (state.editVehicleRequestState == RequestState.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.loc.updateVehicleInformation),
                          ),
                        );
                      }
                      if (state.editVehicleRequestState
                          ==RequestState.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                      const   SnackBar(
                            content: Text("Something went Wrong"),
                          ),
                        );
                      }
                    },
                    child: CustomBtn(
                      bg: AppColors.midGray,
                      onPressed: () {
                        final request = EditVehicleRequest(
                          vehicleNumber: vehicleNumber.text,
                          vehicleType: vehicleType,
                          vehicleLicense: vehicleLicense!.path
                        );
                        context.read<EditProfileBloc>().add(
                         EditVehicleBtnSubmitEvent(request)
                        );
                      },
                      txt: context.loc.update,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
