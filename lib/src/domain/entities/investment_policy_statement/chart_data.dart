class InvestmentPolicyStatementChartData {
  final String title;
  final double actualAlloc;
  final double expectedAlloc;
  final double returnPercent;
  final double benchmark;

  const InvestmentPolicyStatementChartData({
    this.title = '--',
    this.actualAlloc = 0,
    this.expectedAlloc = 0,
    this.returnPercent = 0,
    this.benchmark = 0,
  });
}