import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProgressStore extends Cubit<Set<int>> {
  late final Box box;
  ProgressStore() : super({}) {
    _init();
  }

  void _init() async {
    box = await Hive.openBox('progress');
    emit(box.keys.cast<int>().toSet());
  }

  void add(int level) {
    box.put(level, true);
    emit({...state, level});
  }

  void remove(int level) {
    box.delete(level);
    emit({...state}..remove(level));
  }

  void clear() {
    box.clear();
    emit({});
  }

  bool contains(int level) => state.contains(level);
}
