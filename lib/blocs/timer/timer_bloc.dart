import 'dart:async';

import 'package:ToFinish/models/Task.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../blocs.dart';
import '../../models/Timer.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Timer _ticker;
  Task task;
  int _duration;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Timer ticker, @required Task task})
      : assert(ticker != null),
        _ticker = ticker,
        task = task,
        _duration = task.time - task.timeElapsed,
        super(TimerInitial(task.time - task.timeElapsed));

  // @override
  TimerState get initialState => TimerInitial(_duration);

  // @override
  // void onTransition(Transition<TimerEvent, TimerState> transition) {
  //   print(transition);
  //   super.onTransition(transition);
  // }

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is TimerStarted){
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerTicked){
      yield* _mapTimerTickedToState(event);
    } else if (event is TimerPaused){
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed){
      yield* _mapTimerResumedToState(event);
    } else if (event is TimerReset){
      yield* _mapTimerResetToState(event);
    } else if (event is CompleteTimer){
      yield TimerRunComplete();
    }
  }

  @override
  Future<void> close(){
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: start.duration).listen((duration)=>add(TimerTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    yield tick.duration > 0 ? TimerRunInProgress(tick.duration) : TimerRunComplete();
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused pause) async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed resume) async* {
    if (state is TimerRunPause){
      _tickerSubscription?.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async*{
    _tickerSubscription?.cancel();
    if (reset.task != null){
      this.task = reset.task;
      this._duration = reset.task.time - reset.task.timeElapsed;
    }
    yield TimerInitial(_duration);
  }
}
