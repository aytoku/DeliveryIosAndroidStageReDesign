import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Centrifugo/centrifugo.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/CodeScreen/API/auth_code_data_pass.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_event.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_state.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/global_variables.dart';
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
    }else if(event is SendCode){ // Отправка кода на сервер
      // Состояние загруки
      yield CodeStateLoading();
      // Если передан кривой код
      if(event.code == null || event.code.toString() == ''){
        yield SearchStateError('Вы ввели неверный смс код');
        return;
      }
      // Отправляем код на серв
      authCodeData = await loadAuthCodeData(necessaryDataForAuth.device_id, event.code);
      if(authCodeData != null){ // Если модель не крашнула

        //Активация амплитуды
        await AmplitudeAnalytics.analytics.setUserId(currentUser.phone);
        AmplitudeAnalytics.analytics.logEvent('login');
        // Сохранение данных в память
        necessaryDataForAuth.phone_number =
            currentUser.phone;
        necessaryDataForAuth.refresh_token =
            authCodeData.refreshToken.value;
        necessaryDataForAuth.token =
            authCodeData.token;
        await NecessaryDataForAuth.saveData();

        // await Centrifugo.connectToServer();

        // Изменение флажка и переход на скрин
        currentUser.isLoggedIn = true;
        if(necessaryDataForAuth.name == null){
          yield CodeStateSuccess(null, goToHomeScreen: false, goToNameScreen: true);
        }else{
          yield CodeStateSuccess(null, goToHomeScreen: true, goToNameScreen: false);
        }
      }else{
        yield SearchStateError('Вы ввели неверный смс код');
      }

    }else if(event is SetError){
      yield SearchStateError(event.error);
    }
  }
}