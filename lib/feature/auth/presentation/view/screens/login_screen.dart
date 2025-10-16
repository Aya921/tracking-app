import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/validator/validator.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
import 'package:tracking_app/feature/auth/presentation/view/widgets/custom_txt_field.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_bloc.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_states.dart';
import '../../../../../core/extensions/app_localization_extenstion.dart';
import '../../../../../core/routes/app_route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginStates>(
        listener: (context, state) {
          if (state.requestState == RequestState.success) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(context.loc.successLogin)));
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
            });
          }
          if (state.requestState == RequestState.error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessageLogin!)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: const Key(AppWidgetsKeys.loginScreen),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.of(context).popAndPushNamed(AppRoute.onBoarding),
                icon: Padding(
                  padding: EdgeInsets.only(right: context.setWidth(2)),
                  child: Icon(Icons.arrow_back_ios, size: context.setSp(20)),
                ),
              ),
              title: Text(context.loc.login),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTxtField(
                        hintTxt: context.loc.enterEmail,
                        lbl: context.loc.email,
                        controller: emailController,
                        validator: Validator.validateEmail,
                      ),
                      SizedBox(height: context.setHight(20)),
                      CustomTxtField(
                        hintTxt: context.loc.enterYourPassword,
                        lbl: context.loc.password,
                        controller: passwordController,
                        isPassword: true,
                        validator: Validator.validatePassword,
                      ),
                      SizedBox(height: context.setHight(20)),
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,

                            child: Checkbox(
                              value: state.rememberMe,
                              onChanged: (value) {
                                context.read<LoginBloc>().add(
                                  RememberMeEvent(value ?? false),
                                );
                              },
                            ),
                          ),

                          Text(
                            context.loc.rememberMe,
                            style: getMediumStyle(
                              color: AppColors.black[0]!,
                              fontSize: context.setSp(14),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoute.forgetPasswordScreen,
                            ),
                            child: Text(
                              context.loc.forgetPassword,
                              style: getRegularStyle(color: AppColors.gray)
                                  .copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.gray,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.setHight(20)),
                      ElevatedButton(
                        style:ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14
                          )
                        ) ,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(
                              GetLoginEvent(
                                LoginRequest(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          context.loc.continueBtn,
                          style: getMediumStyle(
                            color: AppColors.white,
                            fontSize: context.setSp(FontSize.s20),
                          ),
                        ),
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
