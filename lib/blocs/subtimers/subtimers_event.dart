import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SubtimersEvent extends Equatable {
  const SubtimersEvent();
  @override
  List<Object> get props => [];
}

class LoadSubtimers extends SubtimersEvent {
  final int id;
  const LoadSubtimers({@required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'LoadSubtimers { id: $id }';
}

class UpdateSubtimer extends SubtimersEvent{
  final int tableId;
  final Task task;
  const UpdateSubtimer({@required this.tableId, @required this.task});
  @override
  List<Object> get props => [tableId, task];
  @override
  String toString() => 'UpdateSubtimer { tableId: $tableId, task: $task }';
}