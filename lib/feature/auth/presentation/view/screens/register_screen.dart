import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/validator/validator.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/apply_request.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/auth_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/location_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/personal_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/vehicle_info.dart';
import 'package:tracking_app/feature/auth/presentation/view/widgets/custom_btn.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_bloc.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_event.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_states.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final vehicleNumberCtrl = TextEditingController();
  final nidCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  // Dropdowns & Radio values
  String? country;
  String? vehicleType;
  String gender = "male";

  // Images
  File? vehicleLicenseImg;
  File? nidImg;

  Future<File> _saveTemporaryFile(XFile pickedFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedFile = await File(
      '${directory.path}/$fileName',
    ).writeAsBytes(await pickedFile.readAsBytes());
    return savedFile;
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      return await _saveTemporaryFile(pickedFile);
    }
    return null;
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    vehicleNumberCtrl.dispose();
    nidCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Widget _buildUploadBox({
    required String label,
    File? file,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: file == null
                  ? Text(label, style: const TextStyle(color: Colors.grey))
                  : Image.file(file, height: 60, fit: BoxFit.cover),
            ),
            const Icon(Icons.upload, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => getIt<ApplyBloc>()
        ..add(GetAllVehiclesEvent())
        ..add(GetAllCountriesEvent()),
      child: BlocConsumer<ApplyBloc, ApplyStates>(
        listener: (context, state) {
          if (state.applyState == RequestState.success) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(context.loc.sucessApply)));
            Navigator.of(context).pushNamed(AppRoute.approveScreen);
          }
          if (state.applyState == RequestState.error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.applyErrorMessage!)));
            Navigator.of(context).pushNamed(AppRoute.loginRoute);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: const Key(AppWidgetsKeys.applyScreen),
            appBar: AppBar(
              backgroundColor: AppColors.white,
              title: Text(
                context.loc.apply,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              centerTitle: false,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, size: context.setWidth(16)),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.05,
                  vertical: sh * 0.02,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.welcome,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: sh * 0.01),
                      Text(
                        context.loc.questionInRegister,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: sh * 0.02),

                      // Country
                      DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: context.loc.country,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: country,
                        items: state.countries.map((e) {
                          return DropdownMenuItem(
                            value: e.name,
                            child: Row(
                              children: [
                                Text(e.flag),
                                SizedBox(width: context.setWidth(10)),
                                Text(e.name, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => country = value),
                      ),
                      SizedBox(height: sh * 0.02),

                      // First name
                      TextFormField(
                        controller: firstNameCtrl,
                        decoration: InputDecoration(
                          labelText: context.loc.firstnameLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? context.loc.required
                            : null,
                      ),
                      SizedBox(height: sh * 0.02),

                      // Last name
                      TextFormField(
                        controller: lastNameCtrl,
                        decoration: InputDecoration(
                          labelText: context.loc.secondnameLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? context.loc.required
                            : null,
                      ),
                      SizedBox(height: sh * 0.02),

                      // Vehicle type
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: context.loc.vehicleType,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: vehicleType,
                        validator: (value) => value == null
                            ? context.loc.vehicleTypeFieldError
                            : null,
                        items: state.vehicle.map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Row(
                              children: [
                                Image.network(
                                  e.image,
                                  width: context.setWidth(60),
                                  height: context.setHight(50),
                                  fit: BoxFit.scaleDown,
                                ),
                                SizedBox(width: context.setWidth(10)),
                                Text(e.type),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => vehicleType = value),
                      ),
                      SizedBox(height: sh * 0.02),

                      TextFormField(
                        controller: vehicleNumberCtrl,
                        decoration: InputDecoration(
                          labelText: context.loc.vehicleNumber,
                          border: const OutlineInputBorder(),
                        ),
                        validator: Validator.validateNumber,
                      ),
                      SizedBox(height: sh * 0.02),

                      // Upload License
                      _buildUploadBox(
                        label: context.loc.uploadLicense,
                        file: vehicleLicenseImg,
                        onTap: () async {
                          final file = await _pickImage();
                          if (file != null) {
                            setState(() => vehicleLicenseImg = file);
                          }
                        },
                      ),
                      SizedBox(height: sh * 0.02),

                      // Email
                      TextFormField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          labelText: context.loc.email,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? context.loc.required
                            : null,
                      ),
                      SizedBox(height: sh * 0.02),

                      // Phone
                      TextFormField(
                        controller: phoneCtrl,
                        decoration: InputDecoration(
                          labelText: context.loc.phone,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? context.loc.required
                            : null,
                      ),
                      SizedBox(height: sh * 0.02),

                      // NID
                      TextFormField(
                        controller: nidCtrl,
                        decoration: InputDecoration(
                          labelText: context.loc.nid,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? context.loc.required
                            : null,
                      ),
                      SizedBox(height: sh * 0.02),

                      // Upload NID
                      _buildUploadBox(
                        label: context.loc.uploadNid,
                        file: nidImg,
                        onTap: () async {
                          final file = await _pickImage();
                          if (file != null) {
                            setState(() {
                              nidImg = file;
                            });
                          }
                        },
                      ),
                      SizedBox(height: sh * 0.02),

                      // Passwords
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: context.loc.password,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) => val != null && val.length < 6
                            ? context.loc.passwordTooShort
                            : null,
                      ),
                      SizedBox(height: sh * 0.02),

                      TextFormField(
                        controller: confirmPasswordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: context.loc.resetPasswordSubtitle,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val != passwordCtrl.text) {
                            return context.loc.passwordNotMatch;
                          }
                          if (val != null && val.length < 6) {
                            return context.loc.passwordTooShort;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: sh * 0.02),

                      // Gender
                      Row(
                        children: [
                          Text(
                            context.loc.gender,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 20),
                          RadioMenuButton<String>(
                            value: "female",
                            groupValue: gender,
                            onChanged: (val) => setState(() => gender = val!),
                            child: Text(context.loc.female),
                          ),
                          RadioMenuButton<String>(
                            value: "male",
                            groupValue: gender,
                            onChanged: (val) => setState(() => gender = val!),
                            child: Text(context.loc.male),
                          ),
                        ],
                      ),
                      SizedBox(height: sh * 0.02),

                      CustomBtn(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (vehicleLicenseImg == null || nidImg == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.loc.pleaseUploadBothImages,
                                  ),
                                ),
                              );
                              return;
                            }

                            context.read<ApplyBloc>().add(
                              GetApplyEvent(
                                ApplyRequest(
                                  authenticationInfo: AuthenticationInfo(
                                    password: passwordCtrl.text,
                                    rePassword: confirmPasswordCtrl.text,
                                  ),
                                  locationInfo: LocationInfo(country: country),
                                  personalInfo: PersonalInfo(
                                    gender: gender,
                                    phone: phoneCtrl.text,
                                    nid: nidCtrl.text,
                                    email: emailCtrl.text,
                                    nidimg: nidImg,

                                    firstName: firstNameCtrl.text,
                                    lastName: lastNameCtrl.text,
                                  ),
                                  vehicleInfo: VehicleInfoModel(
                                    vehicleType: vehicleType,
                                    vehicleNumber: vehicleNumberCtrl.text,
                                    vehicleLicense: vehicleLicenseImg,
                                  ),

                                  // country: country,
                                  // firstName: firstNameCtrl.text,
                                  // lastName: lastNameCtrl.text,
                                  // vehicleType: vehicleType,
                                  // vehicleNumber: vehicleNumberCtrl.text,
                                  // nid: nidCtrl.text,
                                  // email: emailCtrl.text,
                                  // nidimg: nidImg,
                                  // vehicleLicense: vehicleLicenseImg,
                                  // password: passwordCtrl.text,
                                  // rePassword: confirmPasswordCtrl.text,
                                  // gender: gender,
                                  // phone: phoneCtrl.text,
                                ),
                              ),
                            );
                          }
                        },
                        txt: context.loc.continueBtn,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
