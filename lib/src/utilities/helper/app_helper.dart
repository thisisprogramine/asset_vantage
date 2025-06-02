
import 'dart:math';

import 'dart:convert';

import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/stealth/stealth_cubit.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

import '../../config/constants/route_constants.dart';
import '../../data/models/authentication/credentials.dart';
import '../../data/models/return_percentage/return_percentage_model.dart';
import '../../domain/entities/cash_balance/cash_balance_entity.dart';
import '../../domain/entities/expense/expense_chart_data.dart';
import '../../domain/entities/income/income_chart_data.dart';
import '../../domain/entities/income/income_chart_data.dart' as income;
import '../../domain/entities/expense/expense_chart_data.dart' as expense;
import '../../domain/entities/net_worth/net_worth_chart_data.dart';
import '../../domain/entities/performance/performance_report_entity.dart';
import '../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../../presentation/blocs/authentication/login/login_cubit.dart';
import '../../presentation/blocs/stealth/stealth_cubit.dart';
import '../../presentation/widgets/button.dart';
import 'flash_helper.dart';

enum CompactFormat {Hundred, Thousand, Million, Lack, Billion, Crore}

class AppHelpers {

  static Future<bool> onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text("Are you sure?",
            style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: <Widget>[
          Button(
            isIpad: false,
            onPressed: () => Navigator.of(context).pop(false),
            text: 'NO',
          ),
          Button(
            isIpad: false,
            onPressed: () => Navigator.of(context).pop(true),
            text: 'YES',
          ),
        ],
      ),
    ) ??
        false;
  }

  static String getDateLimit({required String dateLimit}) {
    DateTime date = DateTime.now();
    int currentMonth = date.month;
    if(dateLimit.toUpperCase() == 'LASTMONTH') {
      date = Jiffy(date).subtract(months: 1).dateTime;
      return '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${Jiffy(date).daysInMonth < 10 ? '0${Jiffy(date).daysInMonth}' : Jiffy(date).daysInMonth}';
    }else if(dateLimit.toUpperCase() == 'LASTQUARTER') {
      date = Jiffy(date).subtract(months: date.month).dateTime;
      if(currentMonth >= 1 && currentMonth <=3) {
        date = Jiffy(date).add(months: 0).dateTime;
      }else if(currentMonth >= 4 && currentMonth <=6) {
        date = Jiffy(date).add(months: 3).dateTime;
      }else if(currentMonth >= 7 && currentMonth <=9) {
        date = Jiffy(date).add(months: 6).dateTime;
      }else if(currentMonth >= 10 && currentMonth <=12) {
        date = Jiffy(date).add(months: 9).dateTime;
      }
      return '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${Jiffy(date).daysInMonth < 10 ? '0${Jiffy(date).daysInMonth}' : Jiffy(date).daysInMonth}';
    }else {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  static void logout({required BuildContext context}) {
    context.read<FavoritesCubit>().cFavourite();

    BlocProvider.of<LoginCubit>(context).logout().then((value) {
      BlocProvider.of<StealthCubit>(context).hide();
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteList.initial,
            (route) => false,
      );
      FlashHelper.showToastMessage(context, message: 'The token has expired', type: ToastType.info);
    });
  }

  static String getTopLevelDomain({required String systemName}) {
    if(systemName.startsWith('hc') || systemName.startsWith('uar') || systemName.startsWith('rcuat')) {
      return '.in';
    }else {
      return '.com';
    }
  }

  static String getLambdaPrefix({required String region}) {

    if(region.contains('uat')) {
      return 'uat_';
    }else if(region.contains('dev')) {
      return 'dev_';
    }else if(region.contains('qa')) {
      return 'qa_';
    }else {
      return '';
    }
  }

  static String getFormattedCurrency({required double value, required CompactFormat format}) {

    int amount = value.toInt().abs();

    if(format == CompactFormat.Thousand) {
      final double value = (amount / 1000);
      return "${value.toStringAsFixed(2)}${value != 0 ? 'K' : ''}";
    } else if(format == CompactFormat.Million) {
      final double value = (amount / 1000000);
      return "${value.toStringAsFixed(2)}${value != 0 ? 'M' : ''}";
    }else if(format == CompactFormat.Lack) {
      final double value = (amount / 100000);
      return "${value.toStringAsFixed(2)}${value != 0 ? 'L' : ''}";
    }else if(format == CompactFormat.Billion) {
      final double value = (amount / 1000000000);
      return "${value.toStringAsFixed(2)}${value != 0 ? 'B' : ''}";
    }else if(format == CompactFormat.Crore) {
      double value = (amount / 10000000);
      return "${value.toStringAsFixed(2)}${value != 0 ? 'Cr' : ''}";
    }

    return amount.toString();
  }

  static CompactFormat getCompactFormat({required int greaterValue, required String currencyCode}) {

    if(currencyCode == 'INR') {
      if(greaterValue.toString().length <= 3) {
        return CompactFormat.Hundred;
      }else if(greaterValue.toString().length > 3 && greaterValue.toString().length <= 5) {
        return CompactFormat.Thousand;
      }else if(greaterValue.toString().length > 5 && greaterValue.toString().length <= 7) {
        return CompactFormat.Lack;
      }else if(greaterValue.toString().length > 7) {
        return CompactFormat.Crore;
      }
    }else {
      if(greaterValue.toString().length <= 3) {
        return CompactFormat.Hundred;
      }else if(greaterValue.toString().length > 3 && greaterValue.toString().length <= 6) {
        return CompactFormat.Thousand;
      }else if(greaterValue.toString().length > 6 && greaterValue.toString().length <= 9) {
        return CompactFormat.Million;
      }else if(greaterValue.toString().length > 9) {
        return CompactFormat.Billion;
      }
    }

    return CompactFormat.Hundred;
  }



  static int getPerformanceGreaterValue({required List<PerformanceReportEntity> performanceList}) {
    int greaterValue = 0;

      for (var data in performanceList) {
        if(greaterValue < (data.marketValue?.toInt() ?? 0)) {
          greaterValue = data.marketValue?.toInt() ?? 0;
        }
      }

    return greaterValue;
  }

  static double getPerformanceMarketValueChartFraction({required double  actualValue, required double greaterValue}) {

    double fraction = 0.0;

    if(!(actualValue.abs() == 0 && greaterValue.abs() == 0)) {
      fraction = actualValue.abs() / greaterValue.abs();

      if(fraction >= 1.0) {
        fraction = 1.0;
      }else if(fraction <0.00) {
        fraction = 0.00;
      }
    }

    return double.parse(fraction.toStringAsFixed(2)).abs();

  }

  static String getReturnName(ReturnType returnType) {
    switch(returnType) {
      case ReturnType.MTD:
        return 'MTD';
        break;
      case ReturnType.QTD:
        return 'QTD';
        break;
      case ReturnType.CYTD:
        return 'CYTD';
        break;
      case ReturnType.FYTD:
        return 'FYTD';
        break;
      case ReturnType.Yr1:
        return '1YR';
        break;
      case ReturnType.Yr2:
        return '2YR';
        break;
      case ReturnType.Yr3:
        return '3YR';
        break;
      case ReturnType.IncTwr:
        return 'I. TWR';
        break;
      case ReturnType.IncIrr:
        return 'IRR';
        break;
      default:
        return '1YR';
        break;
    }
  }

  static double getReturnTWR(PerformanceReportEntity data, ReturnType selectedReturnType) {
    switch(selectedReturnType) {
      case ReturnType.MTD:
        return double.parse(data.twrMTD?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.QTD:
        return double.parse(data.twrQTD?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.CYTD:
        return double.parse(data.twrCYTD?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.FYTD:
        return double.parse(data.twrFYTD?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.Yr1:
        return double.parse(data.twr1YR?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.Yr2:
        return double.parse(data.twr2YR?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.Yr3:
        return double.parse(data.twr3YR?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.IncTwr:
        return double.parse(data.inceptionTWR?.toStringAsFixed(2) ?? '0.00');
        break;
      case ReturnType.IncIrr:
        return double.parse(data.inceptionIRR?.toStringAsFixed(2) ?? '0.00');
        break;
      default:
        return double.parse(data.twrMTD?.toStringAsFixed(2) ?? '0.00');
        break;
    }
  }

  static double getReturnBenchmark(PerformanceReportEntity data, ReturnType selectedReturnType) {
    switch(selectedReturnType) {
      case ReturnType.MTD:
        return double.parse(data.benchmarkMTD?.toString() ?? '0.000000');
        break;
      case ReturnType.QTD:
        return double.parse(data.benchmarkQTD?.toString() ?? '0.000000');
        break;
      case ReturnType.CYTD:
        return double.parse(data.benchmarkCYTD?.toString() ?? '0.000000');
        break;
      case ReturnType.FYTD:
        return double.parse(data.benchmarkFYTD?.toString() ?? '0.000000');
        break;
      case ReturnType.Yr1:
        return double.parse(data.benchmark1YR?.toString() ?? '0.000000');
        break;
      case ReturnType.Yr2:
        return double.parse(data.benchmark2YR?.toString() ?? '0.000000');
        break;
      case ReturnType.Yr3:
        return double.parse(data.benchmark3YR?.toString() ?? '0.000000');
        break;
      case ReturnType.IncTwr:
        return double.parse(data.benchmarkTWR?.toString() ?? '0.000000');
        break;
      case ReturnType.IncIrr:
        return double.parse(data.benchmarkIRR?.toString() ?? '0.000000');
        break;
      default:
        return double.parse(data.benchmarkMTD?.toString() ?? '0.000000');
        break;
    }
  }

  static bool shouldShowReturn({List<ReturnPercentItemData?>? selectedReturnPercentList, required ReturnType returnType}) {

    if(selectedReturnPercentList != null) {
      for(var percent in selectedReturnPercentList) {
        if(percent?.value == returnType) {
          return true;
        }
      }
    }
    return false;
  }

  static double getPerformanceSelectedReturn({required bool isBenchmark, required PerformanceReportEntity chartData, required ReturnType selectedType}) {
    if(isBenchmark) {
      if(selectedType == ReturnType.MTD) {
        return chartData.benchmarkMTD ?? 0.000000;
      }else if(selectedType == ReturnType.QTD) {
        return chartData.benchmarkQTD ?? 0.000000;
      }else if(selectedType == ReturnType.FYTD) {
        return chartData.benchmarkFYTD ?? 0.000000;
      }else if(selectedType == ReturnType.CYTD) {
        return chartData.benchmarkCYTD ?? 0.000000;
      }else if(selectedType == ReturnType.Yr1) {
        return chartData.benchmark1YR ?? 0.000000;
      }else if(selectedType == ReturnType.Yr2) {
        return chartData.benchmark2YR ?? 0.000000;
      }else if(selectedType == ReturnType.Yr3) {
        return chartData.benchmark3YR ?? 0.000000;
      }else if(selectedType == ReturnType.IncTwr) {
        return chartData.benchmarkTWR ?? 0.000000;
      }else if(selectedType == ReturnType.IncIrr) {
        return chartData.benchmarkIRR ?? 0.000000;
      }
    }else {
      if(selectedType == ReturnType.MTD) {
        return chartData.twrMTD ?? 0.000000;
      }else if(selectedType == ReturnType.QTD) {
        return chartData.twrQTD ?? 0.000000;
      }else if(selectedType == ReturnType.CYTD) {
        return chartData.twrCYTD ?? 0.000000;
      }else if(selectedType == ReturnType.FYTD) {
        return chartData.twrFYTD ?? 0.000000;
      }else if(selectedType == ReturnType.Yr1) {
        return chartData.twr1YR ?? 0.000000;
      }else if(selectedType == ReturnType.Yr2) {
        return chartData.twr2YR ?? 0.000000;
      }else if(selectedType == ReturnType.Yr3) {
        return chartData.twr3YR ?? 0.000000;
      }else if(selectedType == ReturnType.IncTwr) {
        return chartData.inceptionTWR ?? 0.000000;
      }else if(selectedType == ReturnType.IncIrr) {
        return chartData.inceptionIRR ?? 0.000000;
      }
    }

    return 0.000000;
  }

  static List<PerformanceReportEntity> getPerformanceListAsPerPosition({required List<PerformanceReportEntity> report, required List<int> selectedItemIndex, required int positionLevel}) {

    if(positionLevel == 0) {
      return report;
    }else if(positionLevel == 1) {
      return report[selectedItemIndex[0]].positions ?? [];
    }else if(positionLevel == 2) {
      final list = report[selectedItemIndex[0]].positions ?? [];
      if(list.isNotEmpty) {
        return list[selectedItemIndex[1]].positions ?? [];
      }else {
        return [];
      }
    }
    return [];
  }

  static PerformanceReportEntity getPerformanceAsPerPosition({required PerformanceReportEntity report, required List<int> selectedItemIndex, required int positionLevel}) {

    if(positionLevel == 0) {
      return report;
    }else if(positionLevel == 1) {
      return report.positions[selectedItemIndex[0]];
    }else if(positionLevel == 2) {
      final list = report.positions[selectedItemIndex[0]];
      if(list.positions.isNotEmpty) {
        return list.positions[selectedItemIndex[1]];
      }else {
        return report;
      }
    }else if(positionLevel == 3) {
      final list = report.positions[selectedItemIndex[0]];
      if(list.positions.isNotEmpty) {
        final list2 = list.positions[selectedItemIndex[1]];
        return list2.positions[selectedItemIndex[2]];
      }else {
        return report;
      }
    }
    return report;
  }

  static double getPerformanceChartFraction({
    required double actualReturn,
    required bool showBenchmark,
    required double twrMTD,
    required double twrQTD,
    required double twrCYTD,
    required double twrFYTD,
    required double twr1YR,
    required double twr2YR,
    required double twr3YR,
    required double inceptionTWR,
    required double inceptionIRR,
    required double benchmarkMTD,
    required double benchmarkQTD,
    required double benchmarkCYTD,
    required double benchmarkFYTD,
    required double benchmark1YR,
    required double benchmark2YR,
    required double benchmark3YR,
    required double benchmarkTWR,
    required double benchmarkIRR,
  }) {

    double greaterReturn = 0.0;
    double fraction = 0.0;
    bool isNegative = actualReturn < 0.00;

    if(greaterReturn < twrMTD.abs()) {
      greaterReturn = twrMTD.abs();
    }
    if(greaterReturn < twrQTD.abs()) {
      greaterReturn = twrQTD.abs();
    }
    if(greaterReturn < twrCYTD.abs()) {
      greaterReturn = twrCYTD.abs();
    }
    if(greaterReturn < twrFYTD.abs()) {
      greaterReturn = twrFYTD.abs();
    }
    if(greaterReturn < twr1YR.abs()) {
      greaterReturn = twr1YR.abs();
    }
    if(greaterReturn < twr2YR.abs()) {
      greaterReturn = twr2YR.abs();
    }
    if(greaterReturn < twr3YR.abs()) {
      greaterReturn = twr3YR.abs();
    }
    if(greaterReturn < inceptionTWR.abs()) {
      greaterReturn = inceptionTWR.abs();
    }
    if(greaterReturn < inceptionIRR.abs()) {
      greaterReturn = inceptionIRR.abs();
    }
    if(greaterReturn < benchmarkMTD.abs() && showBenchmark) {
      greaterReturn = benchmarkMTD.abs();
    }
    if(greaterReturn < benchmarkQTD.abs() && showBenchmark) {
      greaterReturn = benchmarkQTD.abs();
    }
    if(greaterReturn < benchmarkCYTD.abs() && showBenchmark) {
      greaterReturn = benchmarkCYTD.abs();
    }
    if(greaterReturn < benchmarkFYTD.abs() && showBenchmark) {
      greaterReturn = benchmarkFYTD.abs();
    }
    if(greaterReturn < benchmark1YR.abs() && showBenchmark) {
      greaterReturn = benchmark1YR.abs();
    }
    if(greaterReturn < benchmark2YR.abs() && showBenchmark) {
      greaterReturn = benchmark2YR.abs();
    }
    if(greaterReturn < benchmark3YR.abs() && showBenchmark) {
      greaterReturn = benchmark3YR.abs();
    }
    if(greaterReturn < benchmarkTWR.abs() && showBenchmark) {
      greaterReturn = benchmarkTWR.abs();
    }
    if(greaterReturn < benchmarkIRR.abs() && showBenchmark) {
      greaterReturn = benchmarkIRR.abs();
    }

    if(actualReturn == 0.00 && greaterReturn == 0.00) {
      fraction = 0.00;
    }else {
      fraction = actualReturn.abs() / greaterReturn.abs();
    }

    if(fraction >= 1.0) {
      fraction = 1.0;
    }

    return double.parse(fraction.toStringAsFixed(2)).abs();

  }

  static bool isPerformanceContainNegativeValue({
    required double twrMTD,
    required double twrQTD,
    required double twrCYTD,
    required double twrFYTD,
    required double twr1YR,
    required double twr2YR,
    required double twr3YR,
    required double inceptionTWR,
    required double inceptionIRR,
    required double benchmarkMTD,
    required double benchmarkQTD,
    required double benchmarkCYTD,
    required double benchmarkFYTD,
    required double benchmark1YR,
    required double benchmark2YR,
    required double benchmark3YR,
    required double benchmarkTWR,
    required double benchmarkIRR,
  }) {

    if(twrMTD  < 0.00) {
      return true;
    }else if(twrQTD < 0.00) {
      return true;
    }else if(twrCYTD < 0.00) {
      return true;
    }else if(twrFYTD < 0.00) {
      return true;
    }else if(twr1YR < 0.00) {
      return true;
    }else if(twr2YR < 0.00) {
      return true;
    }else if(twr3YR < 0.00) {
      return true;
    }else if(inceptionTWR < 0.00) {
      return true;
    }else if(inceptionIRR < 0.00) {
      return true;
    }else if(benchmarkMTD < 0.00) {
      return true;
    }else if(benchmarkQTD < 0.00) {
      return true;
    }else if(benchmarkCYTD < 0.00) {
      return true;
    }else if(benchmarkFYTD < 0.00) {
      return true;
    }else if(benchmark1YR < 0.00) {
      return true;
    }else if(benchmark2YR < 0.00) {
      return true;
    }else if(benchmark3YR < 0.00) {
      return true;
    }else if(benchmarkTWR < 0.00) {
      return true;
    }else if(benchmarkIRR < 0.00) {
      return true;
    }else {
      return false;
    }

  }

  static int getIncomeGreaterValue({required List<IncomeChartData> incomeList}) {
    int greaterValue = 0;

    for (var data in incomeList) {
      if(greaterValue < data.total.toInt()) {
        greaterValue = data.total.toInt();
      }
    }

    return greaterValue;
  }

  static int getIncomeChildrenGreaterValue({required List<income.Child> incomeList}) {
    int greaterValue = 0;

    for (var data in incomeList) {
      if(greaterValue < data.total.toInt()) {
        greaterValue = data.total.toInt();
      }
    }

    return greaterValue;
  }

  static double getIncomeChartFraction({required double  actualValue, required double greaterValue}) {
    double fraction = 0.0;
    bool isNegative = actualValue < 0.00;

    if(greaterValue < actualValue.abs()) {
      greaterValue = actualValue.abs();
    }

    if((actualValue == 0.00 && greaterValue == 0.00) || isNegative) {
      fraction = 0.00;
    }else {
      fraction = actualValue.abs() / greaterValue.abs();
    }


    if(fraction >= 1.0) {
      fraction = 1.0;
    }

    return double.parse(fraction.toStringAsFixed(2)).abs();

  }

  static double getExpenseChartFraction({required double  actualValue, required double greaterValue}) {
    double fraction = 0.0;
    bool isNegative = actualValue < 0.00;

    if(greaterValue < actualValue.abs()) {
      greaterValue = actualValue.abs();
    }

    if((actualValue == 0.00 && greaterValue == 0.00) || isNegative) {
      fraction = 0.00;
    }else {
      fraction = actualValue.abs() / greaterValue.abs();
    }


    if(fraction >= 1.0) {
      fraction = 1.0;
    }

    return double.parse(fraction.toStringAsFixed(2)).abs();

  }


  static int getExpenseGreaterValue({required List<ExpenseChartData> expenseList}) {
    int greaterValue = 0;

    for (var data in expenseList) {
      if(greaterValue < data.total.toInt()) {
        greaterValue = data.total.toInt();
      }
    }

    return greaterValue;
  }

  static int getExpenseChildrenGreaterValue({required List<expense.Child> expenseList}) {
    int greaterValue = 0;

    for (var data in expenseList) {
      if(greaterValue < data.total.toInt()) {
        greaterValue = data.total.toInt();
      }
    }

    return greaterValue;
  }

  static int getCashBalanceGreaterValue({required List<CBPeriodEntity> cashBalanceList}) {
    int greaterValue = 0;

    for (var data in cashBalanceList) {
      if(greaterValue < (data.total ?? 0.00).toInt()) {
        greaterValue = (data.total ?? 0.00).toInt();
      }
    }

    return greaterValue;
  }

  static double getCashBalanceChartFraction({required double  actualValue, required double greaterValue}) {
    double fraction = 0.0;
    bool isNegative = actualValue < 0.00;

    if(isNegative) {
     fraction = 0.00;
    }

    if((actualValue == 0.00 && greaterValue == 0.00) || isNegative) {
      fraction = 0.00;
    }else {
      fraction = actualValue.abs() / greaterValue.abs();
    }

    if(fraction >= 1.0) {
      fraction = 1.0;
    }

    return double.parse(fraction.toStringAsFixed(2)).abs();

  }

  String documentIcon(String extension) {
    switch(extension){
      case "pdf":
        return "assets/svgs/document_pdf.svg";
      case "doc":
        return "assets/svgs/document_docs.svg";
      case "txt":
        return "assets/svgs/document_text.svg";
      case "docx":
        return "assets/svgs/document_docs.svg";
      case "xls":
      case "xlsx":
      case "csv":
        return "assets/svgs/document_xls.svg";
      case "ppt":
        return "assets/svgs/document_ppt.svg";
      case "jpg":
      case "jpeg":
      case "png":
      case "bmp":
        return "assets/svgs/document_png.svg";
      case "gif":
        return "assets/svgs/document_gif.svg";
      default:
        return "assets/svgs/document_raw.svg";
    }
  }

  String convertInStringByteRepresentation(String size) {
    final sizeInInt = int.parse(size);
    if ((sizeInInt ~/ 1024)
        .toString()
        .length <= 2) {
      return "${(sizeInInt / 1024.0).toStringAsFixed(2)}KB";
    } else {
      if ((sizeInInt ~/ pow(1024, 2))
          .toString()
          .length <= 2) {
        return "${(sizeInInt / pow(1024, 2)).toStringAsFixed(2)}MB";
      } else {
        return "${(sizeInInt / pow(1024, 3)).toStringAsFixed(2)}GB";
      }
    }
  }

  static String getNetWorthMonthAbbreviation({required String date,int? length=1,}) {

    String dateMonth = DateFormat.MMM().format(DateTime.parse(date)).substring(0,length);

    return dateMonth;
  }

  static List<NetWorthChartData> getNetWorthDenominatedList({required List<NetWorthChartData> chartData, required CompactFormat format, required int decimalPlace}) {
    final List<NetWorthChartData> dataList = [];
    for(var data in chartData) {
      dataList.add(
          NetWorthChartData(
            closingValue: getCompactFormatForNetWorth(value: data.closingValue.toInt(), format: format, decimalPlace: decimalPlace),
            endDate: data.endDate,
            startDate: data.startDate,
            title: data.title,
            inceptionIrrPercent: data.inceptionIrrPercent,
            inceptionTWRPercent: data.inceptionTWRPercent,
            periodIrrPercent: data.periodIrrPercent,
            periodTWRPercent: data.periodTWRPercent,
            children: data.children,
          )
      );
    }

    return dataList;
  }

  static String getCompactSymbolForNetWorth({required CompactFormat format}) {
    switch(format) {
      case CompactFormat.Hundred:
        return '';

      case CompactFormat.Thousand:
        return 'K';

      case CompactFormat.Million:
        return 'M';

      case CompactFormat.Lack:
        return 'L';

      case CompactFormat.Billion:
        return 'B';

      case CompactFormat.Crore:
        return 'Cr';
    }
  }

  static double getCompactFormatForNetWorth({required int value, required CompactFormat format, required int decimalPlace}) {
    double amount = value.toDouble();

    if(format == CompactFormat.Thousand) {
      final double value = (amount / 1000);
      return double.parse(value.toStringAsFixed(decimalPlace));
    } else if(format == CompactFormat.Million) {
      final double value = (amount / 1000000);
      return double.parse(value.toStringAsFixed(decimalPlace));
    }else if(format == CompactFormat.Lack) {
      final double value = (amount / 100000);
      return double.parse(value.toStringAsFixed(decimalPlace));
    }else if(format == CompactFormat.Billion) {
      final double value = (amount / 1000000000);
      return double.parse(value.toStringAsFixed(decimalPlace));
    }else if(format == CompactFormat.Crore) {
      double value = (amount / 10000000);
      return double.parse(value.toStringAsFixed(decimalPlace));
    }
    return amount;
  }

  static int getNetWorthGreaterValue({required List<NetWorthChartData> netWorthList}) {
    int greaterValue = 0;

    for (var data in netWorthList) {
      if(greaterValue < data.closingValue.toInt().abs()) {
        greaterValue = data.closingValue.toInt().abs();
      }
    }

    return greaterValue;
  }


  static String generateUniqueHashKey(String input, int length) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    String hashString = digest.toString();

    var uuid = Uuid();
    String uuidString = uuid.v4();

    String combined = hashString + uuidString;

    return combined.substring(0, length.clamp(0, combined.length));
  }

  static Credentials? getCredentialsFromSystemName({required Map<dynamic, dynamic> credentials, required String systemName}) {

    Map<dynamic, dynamic>? cred = credentials[systemName];

    if(cred != null) {
      return Credentials.fromJson(cred);
    }
    return null;
  }

}