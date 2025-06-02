part of 'countdown_timer_cubit.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object> get props => [];
}

class TimerInitial extends TimerState {}

class TimerStart extends TimerState {
  final String time;

  const TimerStart(this.time);
}

class TimerEnd extends TimerState {}

class TimerError extends TimerState {
  final String message;

  const TimerError(this.message);

  @override
  List<Object> get props => [message];
}
