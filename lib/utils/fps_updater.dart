import 'package:flame/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FpsController extends Cubit<double> {
  FpsController() : super(0);

  void update(double fps) {
    emit(fps);
  }
}

class FpsUpdater extends FpsComponent {
  final void Function(double fps) onUpdate;

  FpsUpdater({
    required this.onUpdate,
    super.windowSize,
    super.key,
  });

  @override
  void update(double dt) {
    super.update(dt);
    onUpdate(fps);
  }
}
