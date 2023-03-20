import 'dart:math';

class Range {
  Range(this.start, this.end);

  final double start;
  final double end;

  bool overlaps(Range other) {
    if (other.start > start && other.start < end) return true;
    if (other.end > end && other.end < end) return true;
    return false;
  }

  static bool between(int number, int floor, int ciel) {
    return number > floor && number <= ciel;
  }
}

extension Between on num {
  bool between(num floor, num ceiling) {
    return this > floor && this <= ceiling;
  }
}

class ProbabilityGenerator {
  ProbabilityGenerator();

  final Random _random = Random();

  bool generateWithProbability(double percent) {
    // + gera um número aleatório 1 - 100
    var randomInt = _random.nextInt(100) + 1;

    if (randomInt <= percent) {
      return true;
    }

    return false;
  }
}
