extension StringExtension on String {
  String intelliTrim() {
    return this.length > 15 ? '${this.substring(0, 15)}...' : this;
  }

  String total() {
    String inputString = this;

    List<int> integerList = inputString
        .split(',')
        .where((s) => s.isNotEmpty)
        .map((s) =>
            int.tryParse(s) ??
            0)
        .toList();

    return integerList.isNotEmpty
        ? integerList.reduce((value, element) => value + element).toString()
        : '0';
  }

  String stealth(bool value) => value ? "∗∗∗" : this;
}
