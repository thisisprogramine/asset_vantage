class DashboardReports {
  DashboardReports._();

  static const data = {
    "data": [
      {"index": 0, "tileName": "Performance"},
      {"index": 1, "tileName": "Cash Balance"},
      {"index": 2, "tileName": "Income"},
      {"index": 3, "tileName": "Expense"},
    ]
  };
}

class DashBoardNetWorthChartBarColors {
  DashBoardNetWorthChartBarColors._();

  static const Map<int, String> colorSpectrum = {
    1: "ffa600",
    9: "fcb54c",
    17: "fec679",
    25: "ffd8a1",
    33: "ffeacc",
    2: "ff7c43",
    10: "f79366",
    18: "f9ac85",
    26: "fcc6a9",
    34: "fee1cf",
    3: "f95d6a",
    11: "f37f81",
    19: "f69d9b",
    27: "f9bcb7",
    35: "fcdcd7",
    4: "d45087",
    12: "db749a",
    20: "e294af",
    28: "eab5c6",
    36: "f3d8e0",
    5: "a05195",
    13: "af70a6",
    21: "be8eb8",
    29: "d0afcd",
    37: "e5d4e4",
    6: "665191",
    14: "7e6ca2",
    22: "9788b3",
    30: "b4a9c9",
    38: "d5cfe1",
    7: "2f4b7c",
    15: "55638e",
    23: "787ea2",
    31: "9d9fba",
    39: "c7c8d7",
    8: "003f5c",
    16: "3b5671",
    24: "63728a",
    32: "8d95a8",
    40: "bec1cc",
  };

  static List<String> getColorScheme(int numberOfItems) {
      return (colorSpectrum.keys.toList()..sort())
          .map((e) => (colorSpectrum[e] as String))
          .toList();
  }
}
