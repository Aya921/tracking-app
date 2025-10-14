import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/validator/validator.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/presentation/view/widgets/custom_txt_field.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/edit_profile_view_model/edit_profile_bloc.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/gender_section.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/profile_photo_section.dart';

class EditProfileScreen extends StatefulWidget {
  final DriverEntity user;

  const EditProfileScreen({required this.user, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _selectedGender;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.contactInfo.email);
    _phoneController = TextEditingController(text: widget.user.contactInfo.phone);
    _selectedGender = widget.user.contactInfo.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    return _firstNameController.text != widget.user.firstName ||
        _lastNameController.text != widget.user.lastName ||
        _emailController.text != widget.user.contactInfo.email ||
        _phoneController.text != widget.user.contactInfo.phone ||
        _selectedGender != widget.user.contactInfo.gender;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileBloc>(),
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state.editProfileRequestState == RequestState.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  key:const Key(AppWidgetsKeys.profileUpdatedSnackBar),
                  content: Text(context.loc.profileUpdated)),
            );
          } else if (state.editProfileRequestState == RequestState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  key:const Key(AppWidgetsKeys.errorSnackBarEditProfile),
                  content: Text(state.editProfileErrorMessage ?? context.loc.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              key: const Key(AppWidgetsKeys.editProfileAppBar),
              title: Text(context.loc.editProfileTitle),
              leading: IconButton(
                onPressed: () =>
                    Navigator.of(context).
                    pop(
                      true
                    ),
                icon: Padding(
                  padding: EdgeInsets.only(right: context.setWidth(2)),
                  child: Icon(Icons.arrow_back_ios, size: context.setWidth(20)),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(context.setWidth(16)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ==== Profile Photo ====
                    ProfilePhotoSection(
                      photoUrl: widget.user.contactInfo.photo,
                      selectedPhoto: state.selectedPhoto,
                      onPickPhoto: () {
                        context.read<EditProfileBloc>().add(
                          PickImageEvent(ImageSource.gallery),
                        );
                      },
                    ),
                    SizedBox(height: context.setHight(25)),

                    // ==== Name Fields ====
                    Row(
                      children: [
                        Expanded(
                          child: CustomTxtField(
                            key: const Key(AppWidgetsKeys.firstNameField),
                            hintTxt: context.loc.firstnameLabel,
                            lbl: context.loc.firstnameLabel,
                            controller: _firstNameController,
                            validator: Validator.validateFullName,
                          ),
                        ),
                        SizedBox(width: context.setWidth(10)),
                        Expanded(
                          child: CustomTxtField(
                            key: const Key(AppWidgetsKeys.lastNameField),
                            hintTxt: context.loc.secondnameLabel,
                            lbl: context.loc.secondnameLabel,
                            controller: _lastNameController,
                            validator: Validator.validateFullName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.setHight(15)),

                    // ==== Email ====
                    CustomTxtField(
                      key: const Key(AppWidgetsKeys.emailField),
                      hintTxt: context.loc.email,
                      lbl: context.loc.email,
                      controller: _emailController,
                      validator: Validator.validateEmail,
                    ),
                    SizedBox(height: context.setHight(15)),

                    // ==== Phone ====
                    CustomTxtField(
                      key: const Key(AppWidgetsKeys.phoneField),
                      hintTxt: context.loc.phone,
                      lbl: context.loc.phone,
                      controller: _phoneController,
                      validator: Validator.validatePhoneNumber,
                    ),
                    SizedBox(height: context.setHight(15)),

                    // ==== Password Placeholder ====
                    TextFormField(
                      key: const Key(AppWidgetsKeys.passwordField),
                      initialValue: Constants.maskedPass,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text(context.loc.password),
                        suffix: InkWell(
                          key: const Key(AppWidgetsKeys.changePasswordButton),
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoute.changePasswordScreen);
                          },
                          child: Text(
                            context.loc.changePassword,
                            style: getRegularStyle(
                              color: AppColors.pink,
                              fontSize: context.setSp(FontSize.s14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.setHight(15)),

                    // ==== Gender ====
                    GenderSection(selectedGender: _selectedGender),
                    SizedBox(height: context.setHight(20)),

                    // ==== Submit Button ====
                    SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        height: context.setHight(50),
                        child: ElevatedButton(
                          key: const Key(AppWidgetsKeys.editButton),
                          style: AppTheme.lightTheme.elevatedButtonTheme.style
                              ?.copyWith(
                                backgroundColor: WidgetStatePropertyAll(
                                  (!_hasChanges())
                                      ? AppColors.black[30]
                                      : AppColors.pink,
                                ),
                              ),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            if (!_hasChanges()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  key: const Key(
                                    AppWidgetsKeys.noChangesSnackBar,
                                  ),
                                  content: Text(context.loc.noChanges),
                                ),
                              );
                              return;
                            }

                            final request = EditProfileRequest(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              phone: _phoneController.text,
                            );

                            context.read<EditProfileBloc>().add(
                              EditBtnSubmitEvent(request),
                            );
                          },
                          child: Text(context.loc.update),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
