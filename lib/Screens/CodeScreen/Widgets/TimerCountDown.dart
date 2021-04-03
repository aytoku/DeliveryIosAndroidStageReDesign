import 'dart:async';

import 'package:flutter/material.dart';

import '../View/code_screen.dart';

class TimerCountDown extends StatefulWidget {
  TimerCountDown({
    Key key,
    this.codeScreenState,
  }) : super(key: key);
  final CodeScreenState codeScreenState;

  @override
  TimerCountDownState createState() {
    return new TimerCountDownState(codeScreenState: codeScreenState);
  }
}

class TimerCountDownState extends State<TimerCountDown> {
  TimerCountDownState({this.codeScreenState});

  final CodeScreenState codeScreenState;
  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            _timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_start == 60) {
      startTimer();
    }
    return _start != 0
        ? Text('Получить новый код можно через $_start c',
        style: TextStyle(
          color: Color(0x97979797),
          fontSize: 13.0,
          letterSpacing: 1.2,
        ))
        : GestureDetector(
      child: Text(
        'Отправить код повторно',
        style: TextStyle(),
      ),
      onTap: () {
        codeScreenState.setState(() {});
      },
    );
  }
}