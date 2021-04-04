import 'dart:async';

import 'package:ToFinish/database/database.dart';
import 'package:bloc/bloc.dart';
import '../blocs.dart';


class TagsBloc extends Bloc<TagsEvent, TagsState> {
  TagsBloc() : super(TagsLoadInProgress());
  DBHelper dbHelper = DBHelper();

  // @override
  // void onTransition(Transition<TodoEvent, TodoState> transition) {
  //   print(transition);
  //   super.onTransition(transition);
  // }

  @override
  Stream<TagsState> mapEventToState(
    TagsEvent event,
  ) async* {
    if (event is LoadTags){
      yield* _mapLoadTagsToState();
    } else if (event is AddTag){
      yield* _mapAddTagToState(event);
    } else if (event is DeleteTag){
      yield* _mapDeleteTagToState(event);
    }
  }

  Stream<TagsState> _mapLoadTagsToState() async* {
    try {
      print('Tags load in progress');
      yield TagsLoadInProgress();
      final tags = await dbHelper.getTags();
      print(tags);
      yield TagsLoadSuccess(tags: tags);
    } catch(_){
      print('Error in _mapLoadTagsToState: ');
      print(_);
      yield TagsLoadFailure();
    }
  }

  Stream<TagsState> _mapAddTagToState(AddTag event) async*{
    if (state is TagsLoadSuccess){
      try {
        String addedTag = await dbHelper.addTag(event.tag);
        List<String> tags = List.from((state as TagsLoadSuccess).tags);
        if (addedTag != ''){
          tags.add(addedTag);
        }
        yield TagsLoadInProgress();
        yield TagsLoadSuccess(tags: tags);
      } catch (_){
        print('Error in mapAddTagToState');
        print(_);
        yield TagsLoadFailure();
      }
    }
  }

  Stream<TagsState> _mapDeleteTagToState(DeleteTag event) async*{
    if (state is TagsLoadSuccess){
      try {
        String deletedTag = await dbHelper.deleteTag(event.tag);
        List<String> tags = List.from((state as TagsLoadSuccess).tags);
        if (deletedTag != ''){
          tags.remove(deletedTag);
        }
        yield TagsLoadInProgress();
        yield TagsLoadSuccess(tags: tags);
      } catch (_){
        print('Error in _mapDeleteTagToState: ');
        print(_);
        yield TagsLoadFailure();
      }
    }
  }
}
