import 'package:flame/components.dart';
import 'package:hot_cold/models/constants.dart';

mixin LongTick on Component {
  double accTime = 0;

  @override
  void update(double dt) {
    super.update(dt);
    accTime += dt;
    while (accTime > longTick) {
      onLongTick();
      accTime -= longTick;
    }
  }

  void onLongTick();
}
