import 'package:equatable/equatable.dart';


abstract class CodeEvent extends Equatable {
  const CodeEvent();
}

class SendCode extends CodeEvent {
  final int code;

  const SendCode({this.code});

  @override
  List<Object> get props => [code];
}

class InitialLoad extends CodeEvent {

  const InitialLoad();

  @override
  List<Object> get props => [];
}

class SetError extends CodeEvent {
  final String error;
  const SetError(this.error);

  @override
  List<Object> get props => [error];
}