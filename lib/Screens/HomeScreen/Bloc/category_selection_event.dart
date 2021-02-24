import 'package:equatable/equatable.dart';

import '../../CityScreen/Model/FilteredCities.dart';
import '../Model/FilteredStores.dart';

abstract class CategorySelectionEvent extends Equatable {
  const CategorySelectionEvent();
}

class CategoryChanged extends CategorySelectionEvent {
  final CategoriesUuid category;

  const CategoryChanged({this.category});

  @override
  List<Object> get props => [category.uuid];

  @override
  String toString() => 'CategoryChanged { text: ${category.uuid} }';
}

class CityChanged extends CategorySelectionEvent {
  final FilteredCities city;

  const CityChanged({this.city});

  @override
  List<Object> get props => [city.uuid];

  @override
  String toString() => 'CategoryChanged { text: ${city.uuid} }';
}

class InitialLoad extends CategorySelectionEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'CategoryChanged';
}