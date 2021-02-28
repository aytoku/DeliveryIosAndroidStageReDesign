import 'dart:async';
import 'package:flutter_app/Screens/HomeScreen/Model/AllStoreCategories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import '../../../data/data.dart';
import '../API/getFilteredStores.dart';
import '../Model/FilteredStores.dart';
import 'restaurant_get_event.dart';
import 'restaurant_get_state.dart';

class RestaurantGetBloc extends Bloc<RestaurantEvent, RestaurantGetState> {

  @override
  Stream<Transition<RestaurantEvent, RestaurantGetState>> transformEvents(
      Stream<RestaurantEvent> events,
      Stream<Transition<RestaurantEvent, RestaurantGetState>> Function(
          RestaurantEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<RestaurantEvent, RestaurantGetState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  RestaurantGetState get initialState => RestaurantGetStateLoading();

  @override
  Stream<RestaurantGetState> mapEventToState(RestaurantEvent event ) async* {

    if (event is InitialLoad) {
      yield RestaurantGetStateLoading();
      FilteredStoresData stores = await getFilteredStores(selectedCity.uuid, true);
      if(stores != null && stores.filteredStoresList != null && stores.filteredStoresList.length > 0){
        FilteredStoresData.filteredStoresCache = stores.filteredStoresList;
        yield RestaurantGetStateSuccess(FilteredStoresData.filteredStoresCache);
      }
      else
        yield RestaurantGetStateEmpty();
    } else if(event is CategoryFilterApplied){
      if(AllStoreCategoriesData.selectedStoreCategories  == null){
        AllStoreCategoriesData.selectedStoreCategories = new List<AllStoreCategories>();
      }
      yield RestaurantGetStateLoading();
      if(event.categories != null){
        AllStoreCategoriesData.selectedStoreCategories.clear();
        AllStoreCategoriesData.selectedStoreCategories.addAll(event.categories);
        yield RestaurantGetStateSuccess(FilteredStoresData.applyCategoryFilters(AllStoreCategoriesData.selectedStoreCategories));
        return;
      }

      if(AllStoreCategoriesData.selectedStoreCategories.contains(event.category)){
        if(event.selectedCategoryFromHomeScreen){
          AllStoreCategoriesData.selectedStoreCategories.remove(event.category);
        }
      } else {
        AllStoreCategoriesData.selectedStoreCategories.add(event.category);
      }
      yield RestaurantGetStateSuccess(FilteredStoresData.applyCategoryFilters(AllStoreCategoriesData.selectedStoreCategories));

    }
  }

}