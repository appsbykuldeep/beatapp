enum SummonDetailType {
  total,
  pending,
  completed;

  bool get isTotal => this == total;
  bool get isPending => this == pending;
  bool get isCompleted => this == completed;
}
