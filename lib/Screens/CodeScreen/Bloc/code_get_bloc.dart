import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/CodeScreen/API/auth_code_data_pass.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_event.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_state.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class CodeGetBloc extends Bloc<CodeEvent, CodeState> {

  @override
  Stream<Transition<CodeEvent, CodeState>> transformEvents(
      Stream<CodeEvent> events,
      Stream<Transition<CodeEvent, CodeState>> Function(
          CodeEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<CodeEvent, CodeState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  CodeState get initialState => CodeStateEmpty();



  @override
  Stream<CodeState> mapEventToState(CodeEvent event ) async* {
    if (event is InitialLoad) {
      yield CodeStateEmpty();
    }else if(event is SendCode){
      yield CodeStateLoading();
      if(event.code == ''){
        yield SearchStateError('Вы ввели неверный смс код');
      }


      bool sendDataOnServer = false;
      if (authCodeData != null) {
        sendDataOnServer = true;
        await AmplitudeAnalytics.analytics.setUserId(currentUser.phone);
        AmplitudeAnalytics.analytics.logEvent('login');
        necessaryDataForAuth.phone_number =
            currentUser.phone;
        necessaryDataForAuth.refresh_token =
            authCodeData.refreshToken.value;
        necessaryDataForAuth.token =
            authCodeData.token;
        await NecessaryDataForAuth.saveData();
        //await Centrifugo.connectToServer();

        if(necessaryDataForAuth.name == null){
          yield CodeStateSuccess(null, goToHomeScreen: false, goToNameScreen: true);
        }else{
          currentUser.isLoggedIn = true;
          homeScreenKey =
          new GlobalKey<HomeScreenState>();
          currentUser.isLoggedIn = true;
          yield CodeStateSuccess(null, goToHomeScreen: true, goToNameScreen: false);
        }
      } else {
        SearchStateError('Вы ввели неверный смс код');
      }


      if(sendDataOnServer){
        AuthCodeData authorization = await loadAuthCodeData(necessaryDataForAuth.device_id, event.code, 'eda');
        if(authorization != null){
          // if(authorization. != 200){
          //   yield SearchStateError(authorization.message);
          // }
          yield CodeStateSuccess(authorization);
        }else{
          yield SearchStateError('Вы ввели неверный смс код');
        }
      }
    }else if(event is SetError){
      yield SearchStateError(event.error);
    }
  }
}