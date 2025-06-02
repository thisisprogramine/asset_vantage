extension NumExtension on num? {
  String convertToPercentageString() {
    return ((this ?? 0) * 10).toStringAsFixed(0) + ' %';
  }

  double denominate({required int? denominator}) {
    return ((this ?? 0.0) / (denominator ?? 1)).toDouble();
  }

  String toStringAsFixedWithoutRoundingOff(int digits) {
    final number = (this ?? 0).toString().split(".");
    return "${number[0]}.${number[1].substring(0,digits)}";
  }


}
