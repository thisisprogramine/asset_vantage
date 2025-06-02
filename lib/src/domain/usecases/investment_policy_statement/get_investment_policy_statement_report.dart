import 'package:asset_vantage/main.dart';
import 'package:asset_vantage/src/domain/params/investment_policy_statement/investment_policy_statement_report_params.dart';
import 'package:dartz/dartz.dart';

import '../../entities/app_error.dart';
import '../../entities/investment_policy_statement/investment_policy_statement_report_entity.dart';
import '../../repositories/av_repository.dart';
import '../usecase.dart';

class GetInvestmentPolicyStatementReport extends UseCase<InvestmentPolicyStatementReportEntity, InvestmentPolicyStatementReportParams> {
  final AVRepository _avRepository;

  GetInvestmentPolicyStatementReport(this._avRepository);

  @override
  Future<Either<AppError, InvestmentPolicyStatementReportEntity>> call(InvestmentPolicyStatementReportParams params) async =>
      await ipsResponseQueue.add(() async{
        return await _avRepository.getInvestmentPolicyStatementReport(context: params.context, requestBody: await params.toJson());
      });
}
