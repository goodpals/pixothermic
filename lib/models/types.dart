import 'package:flame/components.dart';
import 'package:hot_cold/models/constants.dart';

typedef IntVec = (int, int);

extension IntVecExtension on IntVec {
  IntVec get down => (this.$1, this.$2 + 1);
  IntVec get up => (this.$1, this.$2 - 1);
  IntVec get left => (this.$1 - 1, this.$2);
  IntVec get right => (this.$1 + 1, this.$2);
  Vector2 get vec2 => Vector2(this.$1 * unit, this.$2 * unit);

  String export() => '(${$1},${$2})';
  static IntVec import(String s) {
    final nums = s.replaceAll(RegExp(r'[()]'), '').split(',');
    return (int.parse(nums[0]), int.parse(nums[1]));
  }
}

IntVec intVecFromString(String s) => IntVecExtension.import(s);
