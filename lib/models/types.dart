typedef IntVec = (int, int);

extension IntVecExtension on IntVec {
  IntVec get down => (this.$1, this.$2 + 1);
  IntVec get up => (this.$1, this.$2 - 1);
  IntVec get left => (this.$1 - 1, this.$2);
  IntVec get right => (this.$1 + 1, this.$2);
}
