import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class GetDriverOrdersEvent extends OrderEvent {
  final int page;
  final int limit;

  const GetDriverOrdersEvent({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

class RefreshDriverOrdersEvent extends OrderEvent {
  const RefreshDriverOrdersEvent();

  @override
  List<Object?> get props => [];
}