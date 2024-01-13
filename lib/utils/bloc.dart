import 'package:flutter_bloc/flutter_bloc.dart';

extension SeededStream<T> on Cubit<T> {
  Stream<T> get seededStream async* {
    yield state;
    yield* stream;
  }
}
