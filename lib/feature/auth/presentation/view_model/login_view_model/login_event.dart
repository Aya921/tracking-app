import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
@immutable
abstract class LoginEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
class GetLoginEvent extends LoginEvent{
  final LoginRequest request;
  GetLoginEvent(this.request);
}
class RememberMeEvent extends LoginEvent{
   bool isLoggedIn;
RememberMeEvent(this.isLoggedIn);
}
