import 'dart:core';

abstract class AppWidgetsKeys {
  //forget password
  static const forgetAppBar = 'forgetAppBar';
  static const forgetLoading = 'forgetLoading';
  static const forgetTitle = 'forgetTitle';
  static const forgetSubtitle = 'forgetSubtitle';
  static const emailTextField = 'emailTextField';
  static const confirmButton = 'confirmButton';

  //verify code
  static const verifyCodeAppBar = 'verifyCodeAppBar';
  static const verifyButton = 'verifyButton';
  static const resendButton = 'resendButton';
  static const emailVerificationText = 'emailVerificationText';
  static const enterCodeEmailText = 'enterCodeEmailText';
  static const pinCodeField = 'pinCodeField';
  static const successSnackBar = 'successSnackBar';
  static const errorSnackBar = 'errorSnackBar';

  //reset password
  static const resetPasswordAppBar = 'resetPasswordAppBar';
  static const resetPasswordTitle = 'resetPasswordTitle';
  static const resetPasswordSubtitle = 'resetPasswordSubtitle';
  static const newPasswordTextField = 'newPasswordTextField';
  static const confirmPasswordTextField = 'confirmPasswordTextField';
  static const resetPasswordConfirmButton = 'resetPasswordConfirmButton';
  static const resetPasswordSuccessSnackBar = 'resetPasswordSuccessSnackBar';
  static const resetPasswordErrorSnackBar = 'resetPasswordErrorSnackBar';

  //login
  static const String loginScreen = "login_screen";

  //apply
  static const String applyScreen = "apply_screen";

  static const String sharedPrefrenceKeyLanguage = "appLanguage";
  static const String homeKey = "nav_home";
  static const String profileKey = "nav_profile";
  static const String phoneKey = "phone_key";
  static const String whatsAppKey = "WhatsApp_key";
  static const String orderkey = "nav_orders";
  static const String stackKey1 = "stack1";
  static const String alignKey1 = "align1";
  static const String ceenterKey1 = "center1";

  // edit profile
  static const editProfileAppBar = 'editProfileAppBar';
  static const backButton = 'backButton';
  static const profilePhoto = 'profilePhoto';
  static const firstNameField = 'firstNameField';
  static const lastNameField = 'lastNameField';
  static const emailField = 'emailField';
  static const phoneField = 'phoneField';
  static const passwordField = 'passwordField';
  static const changePasswordButton = 'changePasswordButton';
  static const genderSection = 'genderSection';
  static const editButton = 'editBtn';
  static const noChangesSnackBar = 'noChangesSnackBar';
  static const profileUpdatedSnackBar = 'profileUpdatedSnackBar';
  static const errorSnackBarEditProfile = 'editProfileErrorSnackBar';

  //gender section
  static const femaleRadio = "femaleRadio";
  static const maleRadio = "maleRadio";

  //photo section
  static const photoStack = "photoStack";
  static const photoAvatar = "photoAvatar";
  static const photoSelectIcon = "photoSelectIcon";
}
