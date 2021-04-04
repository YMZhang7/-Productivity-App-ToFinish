import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TagsState extends Equatable {
  const TagsState();
  
  @override
  List<Object> get props => [];
}

class TagsLoadInProgress extends TagsState {}


class TagsLoadSuccess extends TagsState{
  final List<String> tags;
  const TagsLoadSuccess({@required this.tags});

  @override
  List<Object> get props => [tags];

  @override
  String toString() => 'TagsLoadSuccess { tags: $tags }';
}


class TagsLoadFailure extends TagsState {}