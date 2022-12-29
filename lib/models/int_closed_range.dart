class IntClosedRange {
  final int start;
  final int end;

  IntClosedRange(this.start, this.end);

  Set<int> get range {
    final Set<int> range = {};

    for (int i = start; i <= end; i++) {
      range.add(i);
    }

    return range;
  }

  bool contains(int value) {
    return range.contains(value);
  }
}
