import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import '../../../data/data.dart';
import '../API/getFilteredStores.dart';
import '../Model/FilteredStores.dart';
import 'restaurant_get_event.dart';
import 'restaurant_get_state.dart';

class RestaurantGetBloc extends Bloc<CategorySelectionEvent, RestaurantGetState> {

  @override
  Stream<Transition<CategorySelectionEvent, RestaurantGetState>> transformEvents(
      Stream<CategorySelectionEvent> events,
      Stream<Transition<CategorySelectionEvent, RestaurantGetState>> Function(
          CategorySelectionEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<CategorySelectionEvent, RestaurantGetState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  RestaurantGetState get initialState => RestaurantGetStateLoading();

  @override
  Stream<RestaurantGetState> mapEventToState(CategorySelectionEvent event ) async* {

    if (event is InitialLoad) {
      yield RestaurantGetStateLoading();
      FilteredStoresData stores = await getFilteredStores(selectedCity.uuid, true);
      if(stores != null && stores.filteredStoresList != null && stores.filteredStoresList.length > 0){
        yield RestaurantGetStateSuccess(stores.filteredStoresList);
      }
      else
        yield RestaurantGetStateEmpty();
    }
    else if(event is CityChanged){

    }

  }

}