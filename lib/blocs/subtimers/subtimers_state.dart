import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SubtimersState extends Equatable {
  const SubtimersState();
  
  @override
  List<Object> get props => [];
}


class SubtasksLoadSuccess extends SubtimersState {
  final List<Task> tasks;
  const SubtasksLoadSuccess({@required this.tasks});

  @override
  List<Object> get props => [tasks];

  @override
  String toString() => 'SubtasksLoadSuccess { tasks: $tasks }';
}

class SubtasksLoadFailure extends SubtimersState {}

class SubtasksLoadInProcess extends SubtimersState {}