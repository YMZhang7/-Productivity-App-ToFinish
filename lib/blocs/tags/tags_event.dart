import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


abstract class TagsEvent extends Equatable {
  const TagsEvent();
  @override
  List<Object> get props => [];
}

class LoadTags extends TagsEvent {}

class AddTag extends TagsEvent {
  final String tag;
  const AddTag ({@required this.tag});

  @override
  List<Object> get props => [tag];
  @override
  String toString() => 'AddTag { tag: $tag }';
}

// class UpdateTag extends TagsEvent {
//   final String tag;
//   const UpdateTag ({@required this.tag});

//   @override
//   List<Object> get props => [tag];
//   @override
//   String toString() => 'UpdateTag { tag: $tag }';
// }

class DeleteTag extends TagsEvent {
  final String tag;

  const DeleteTag({@required this.tag});

  @override
  List<Object> get props => [tag];

  @override
  String toString() => 'DeleteTag { tag: $tag }';
}

