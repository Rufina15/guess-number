import 'dart:math';

class FixedRandom implements Random {
  final int fixedValue;

  FixedRandom(this.fixedValue);

  @override
  int nextInt(int max) => fixedValue;

  @override
  bool nextBool() => true;

  @override
  double nextDouble() => 0.5;

  @override
  double nextDoubleSecure() => throw UnimplementedError();

  @override
  int nextIntSecure(int max) => throw UnimplementedError();
}
