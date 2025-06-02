import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'countdown_timer_state.dart';

class TimerCubit extends Cubit<TimerState> {

  TimerCubit() : super(TimerInitial());

  int start = 0;

  void startTimer({int initialTime = 180}) {
    start = initialTime;

    Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {

            if (start < 1) {
              timer.cancel();
              if(start >= 0) {
                emit(TimerEnd());
              }
            } else {
              emit(TimerInitial());
              start = start - 1;
              emit(TimerStart(_printDuration(start)));
            }
          }
    );
  }

  void closeTimer() {
    start = -1;
  }

  String _printDuration(int time) {
    Duration duration = Duration(seconds: time);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

}
