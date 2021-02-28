import 'package:equatable/equatable.dart';

import '../Model/FilteredStores.dart';

abstract class RestaurantGetState extends Equatable {
  const RestaurantGetState();

  @override
  List<Object> get props => [];
}

class RestaurantGetStateEmpty extends RestaurantGetState {}

class RestaurantGetStateLoading extends RestaurantGetState {}

class RestaurantGetStateSuccess extends RestaurantGetState {
  final List<FilteredStores> items;


  const RestaurantGetStateSuccess(this.items);

  @override
  List<Object> get props => [items];
}

class SearchStateError extends RestaurantGetState {
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}