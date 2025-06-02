
import 'package:equatable/equatable.dart';

class PerformanceReportEntity extends Equatable{
  final List<PerformanceReportEntity> positions;
  final String? title;
  final double? marketValue;
  final double? twrMTD;
  final double? twrQTD;
  final double? twrCYTD;
  final double? twrFYTD;
  final double? twr1YR;
  final double? twr2YR;
  final double? twr3YR;
  final double? inceptionTWR;
  final double? inceptionIRR;
  final String? benchmark;
  final double? benchmarkMTD;
  final double? benchmarkQTD;
  final double? benchmarkCYTD;
  final double? benchmarkFYTD;
  final double? benchmark1YR;
  final double? benchmark2YR;
  final double? benchmark3YR;
  final double? benchmarkTWR;
  final double? benchmarkIRR;

  const PerformanceReportEntity({
    required this.positions,
    this.title,
    this.marketValue,
    this.twrMTD,
    this.twrQTD,
    this.twrCYTD,
    this.twrFYTD,
    this.twr1YR,
    this.twr2YR,
    this.twr3YR,
    this.inceptionTWR,
    this.inceptionIRR,
    this.benchmark,
    this.benchmarkMTD,
    this.benchmarkQTD,
    this.benchmarkCYTD,
    this.benchmarkFYTD,
    this.benchmark1YR,
    this.benchmark2YR,
    this.benchmark3YR,
    this.benchmarkTWR,
    this.benchmarkIRR,
  });

  @override
  List<Object?> get props => [positions];
}