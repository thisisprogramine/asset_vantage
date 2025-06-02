import 'package:asset_vantage/src/data/datasource/remote/av_remote_datasource.dart';
import 'package:asset_vantage/src/domain/usecases/authentication/get_credentials.dart';
import 'package:asset_vantage/src/domain/usecases/authentication/save_credentials.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/primary_grouping/get_cash_balance_selected_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/primary_grouping/save_cash_balance_selected_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/selected_entity/get_cash_balance_selected_entity.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/selected_period/save_performance_selected_entity.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/sub_grouping/get_cash_balance_selected_sub_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/get_cash_balance_report.dart';
import 'package:asset_vantage/src/domain/usecases/cash_balance/cash_balance_filters/sub_grouping/get_cash_balance_sub_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/currency/get_selected_currency.dart';
import 'package:asset_vantage/src/domain/usecases/document/get_documents.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_accounts/get_expense_selected_accounts.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_accounts/save_expense_selected_accounts.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_currency/get_expense_selected_currency.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_currency/save_expense_selected_currency.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_denomination/get_expense_selected_denomination.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_denomination/save_expense_selected_denomination.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_entity/get_expense_selected_entity.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_entity/save_expense_selected_entity.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_number_of_period/get_expense_selected_number_of_period.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_number_of_period/save_expense_selected_number_of_period.dart';
import 'package:asset_vantage/src/domain/usecases/expense/expense_filter/selected_period/get_expense_selected_period.dart';
import 'package:asset_vantage/src/domain/usecases/favorites/favorites_sequence.dart';
import 'package:asset_vantage/src/domain/usecases/holding_method/get_holding_method.dart';
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_currency/get_income_selected_currency.dart';
import 'package:asset_vantage/src/domain/usecases/income/income_filter/selected_entity/get_income_selected_entity.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_report.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_sub_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/investment_policy_statement/get_investment_policy_statement_grouping.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/get_net_worth_report.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/get_net_worth_return_percent.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_holding_method/get_net_worth_selected_holding_method.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_holding_method/save_selected_holding_method.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_partnership_method/get_networth_selected_partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_partnership_method/save_networth_selected_partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/partnership_method/get_partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/performance/performance_filter/selected_holding_method/get_performance_selected_holding_method.dart';
import 'package:asset_vantage/src/domain/usecases/performance/performance_filter/selected_holding_method/save_performance_selected_holding_method.dart';
import 'package:asset_vantage/src/domain/usecases/performance/performance_filter/selected_partnership_method/get_performance_selected_partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/performance/performance_filter/selected_partnership_method/save_performance_selected_partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/period/get_period.dart';
import 'package:asset_vantage/src/domain/usecases/return_percentage/get_return_percentage.dart';
import 'package:asset_vantage/src/domain/usecases/universal_filters/clear_all_the_filters.dart';
import 'package:asset_vantage/src/presentation/blocs/app_theme/theme_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/forgot_password/forgot_password_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/login/login_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/login_check/login_check_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/mfa_login/mfa_login_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/user/user_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_accounts/cash_balance_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_as_on_date/cash_balance_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_currency/cash_balance_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_denomination/cash_balance_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_entity/cash_balance_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_loading/cash_balance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_number_of_period/cash_balance_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_period/cash_balance_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/cash_balance/cash_balance_sort_cubit/cash_balance_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/currency_filter/currency_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/dashboard/dashboard_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/dashboard_datepicker/dashboard_datepicker_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/dashboard_filter/dashboard_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/dashboard_search/dashboard_search_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/denomination_filter/denomination_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document/document_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document_search/document_search_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/document/document_sort/document_view_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_account/expense_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_as_on_date/expense_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_chart/expense_chart_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_currency/expense_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_denomination/expense_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_entity/expense_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_loading/expense_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_number_of_period/expense_number_of_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_report/expense_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_sort_cubit/expense_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/expense/expense_timestamp/expense_timestamp_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_as_on_date/income_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_chart/income_chart_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_currency/income_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_denomination/income_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_loading/income_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_sort_cubit/income_sort_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/insights/insights_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_account/income_account_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_period/income_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/income/income_timestamp/income_timestamp_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/internet_connectivity/internet_connectivity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_grouping/investment_policy_statement_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_policy/investment_policy_statement_policy_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_report/investment_policy_statement_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_tabbed/investment_policy_statement_tabbed_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/investment_policy_statement/investment_policy_statement_timestamp/investment_policy_statement_timestamp_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_as_on_date/net_worth_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_currency/net_worth_currency_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_denomination/net_worth_denomination_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_entity/net_worth_entity_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_loading/net_worth_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_return_percent/net_worth_return_percent_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/net_worth_sub_grouping/net_worth_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_holding_method/networth_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_as_on_date/performance_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_holding_method/performance_holding_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_loading/performance_loading_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_period/performance_period_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_report/performance_report_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_secondary_sub_grouping/performance_secondary_sub_grouping_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/stealth/stealth_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_return_percent/performance_return_percent_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/as_on_date_universal_filter/universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/enitity_universal_filter/universal_entity_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_as_on_date_universal_filter/favourite_universal_filter_as_on_date_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/favourite_universal_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/universal_filter/universal_filter_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/user_guide_assets/user_guide_assets_cubit.dart';
import 'package:asset_vantage/src/services/biomatric_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';

import 'core/api_client.dart';
import 'data/datasource/local/app_local_datasource.dart';
import 'data/datasource/local/authentication_local_datasouce.dart';
import 'data/datasource/local/av_local_datasource.dart';
import 'data/datasource/remote/app_remote_datasource.dart';
import 'data/datasource/remote/authentication_remote_datasource.dart';
import 'data/repositories/app_repository_impl.dart';
import 'data/repositories/authentication_repository_impl.dart';
import 'data/repositories/av_repository_impl.dart';
import 'domain/repositories/app_repository.dart';
import 'domain/repositories/authentication_repository.dart';
import 'domain/repositories/av_repository.dart';
import 'domain/usecases/authentication/get_user_data.dart';
import 'domain/usecases/authentication/get_user_theme.dart';
import 'domain/usecases/authentication/reset_password.dart';
import 'domain/usecases/authentication/verify_otp.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/accounts/get_cash_balance_accounts.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/accounts/save_cb_selected_sub_groups.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_as_on_date/get_cash_balance_selected_as_on_date.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_as_on_date/save_cash_balance_selected_as_on_date.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_currency/get_cash_balance_selected_currency.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_currency/save_cash_balance_selected_currency.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_denomination/get_cash_balance_selected_denomination.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_denomination/save_performance_selected_denomination.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_entity/save_performance_selected_entity.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_number_of_period/get_cash_balance_selected_entity.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_number_of_period/save_performance_selected_entity.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/selected_period/get_cash_balance_selected_entity.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/sub_grouping/save_cash_balance_selected_sub_grouping.dart';
import 'domain/usecases/cash_balance/clear_cash_balance.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/primary_grouping/get_cash_balance_grouping.dart';
import 'domain/usecases/cash_balance/cash_balance_filters/accounts/get_cash_balance_selected_accounts.dart';
import 'domain/usecases/cash_balance/get_cb_sort_filter.dart';
import 'domain/usecases/cash_balance/save_cb_sort_filter.dart';
import 'domain/usecases/currency/getCurrency.dart';
import 'domain/usecases/currency/save_selected_currency.dart';
import 'domain/usecases/dashboard/get_dashboard_entity_list.dart';
import 'domain/usecases/dashboard/get_dashboard_widgets.dart';
import 'domain/usecases/authentication/forgot_password.dart';
import 'domain/usecases/dashboard/get_selected_dashboard_entity.dart';
import 'domain/usecases/dashboard/save_dashboard_widget_sequence.dart';
import 'domain/usecases/dashboard/save_selected_dashboard_entity.dart';
import 'domain/usecases/denomination/get_denomination.dart';
import 'domain/usecases/denomination/get_selected_denomination.dart';
import 'domain/usecases/denomination/save_selected_denomination.dart';
import 'domain/usecases/document/download_documents.dart';
import 'domain/usecases/document/get_selected_document_entity.dart';
import 'domain/usecases/document/save_selected_document_entity.dart';
import 'domain/usecases/document/search_document.dart';
import 'domain/usecases/expense/expense_filter/selected_period/save_expense_selected_period.dart';
import 'domain/usecases/expense/get_expense_report.dart';
import 'domain/usecases/expense/get_expense_account.dart';
import 'domain/usecases/favorites/favorites.dart';
import 'domain/usecases/income/income_filter/selected_accounts/get_income_selected_accounts.dart';
import 'domain/usecases/income/income_filter/selected_accounts/save_income_selected_accounts.dart';
import 'domain/usecases/income/income_filter/selected_currency/save_income_selected_currency.dart';
import 'domain/usecases/income/income_filter/selected_denomination/get_income_selected_denomination.dart';
import 'domain/usecases/income/income_filter/selected_denomination/save_income_selected_denomination.dart';
import 'domain/usecases/income/income_filter/selected_entity/save_income_selected_entity.dart';
import 'domain/usecases/income/income_filter/selected_number_of_period/get_income_selected_number_of_period.dart';
import 'domain/usecases/income/income_filter/selected_number_of_period/save_income_selected_number_of_period.dart';
import 'domain/usecases/income/income_filter/selected_period/get_income_selected_period.dart';
import 'domain/usecases/income/income_filter/selected_period/save_income_selected_period.dart';
import 'domain/usecases/insights/chat_stream.dart';
import 'domain/usecases/insights/connect_chat.dart';
import 'domain/usecases/insights/disconnect_chat.dart';
import 'domain/usecases/insights/get_chat_list.dart';
import 'domain/usecases/insights/send_message.dart';
import 'domain/usecases/income/get_income_report.dart';
import 'domain/usecases/income/get_income_account.dart';
import 'domain/usecases/income_expense/clear_income_expense.dart';
import 'domain/usecases/income_expense/get_income_expense_period.dart';
import 'domain/usecases/income_expense/get_income_expense_saved_accounts.dart';
import 'domain/usecases/income_expense/get_income_expense_saved_period.dart';
import 'domain/usecases/income_expense/get_income_expense_worth_number_of _period.dart';
import 'domain/usecases/income_expense/save_income_expense_accounts.dart';
import 'domain/usecases/income_expense/save_income_expense_period.dart';
import 'domain/usecases/investment_policy_statement/clear_investment_policy_statement.dart';
import 'domain/usecases/investment_policy_statement/get_investment_policy_statement_policies.dart';
import 'domain/usecases/investment_policy_statement/get_investment_policy_statement_time_period.dart';
import 'domain/usecases/investment_policy_statement/get_ips_policy_filter.dart';
import 'domain/usecases/investment_policy_statement/get_ips_return_filter.dart';
import 'domain/usecases/investment_policy_statement/get_ips_sub_filter.dart';
import 'domain/usecases/investment_policy_statement/save_ips_policy_filter.dart';
import 'domain/usecases/investment_policy_statement/save_ips_return_filter.dart';
import 'domain/usecases/investment_policy_statement/save_ips_sub_group_filter.dart';
import 'domain/usecases/net_worth/clear_net_worth.dart';
import 'domain/usecases/net_worth/get_net_worth_sub_grouping.dart';
import 'domain/usecases/net_worth/get_net_worth_grouping.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_as_on_date/get_new_worth_selected_as_on_date.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_as_on_date/save_networth_selected_as_on_date.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_currency/get_net_worth_selected_currency.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_currency/save_net_worth_selected_currency.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_denomination/get_net_worth_selected_denomination.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_denomination/save_net_worth_selected_denomination.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_entity/get_net_worth_selected_entity.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_entity/save_net_worth_selected_entity.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_number_of_period/get_net_worth_selected_number_of_period.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_number_of_period/save_net_worth_selected_number_of_period.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_period/get_net_worth_selected_period.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_period/save_net_worth_selected_period.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_primary_grouping/get_net_worth_selected_primary_grouping.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_primary_grouping/save_net_worth_selected_primary_grouping.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_primary_sub_grouping/get_net_worth_selected_sub_groups.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_primary_sub_grouping/save_net_worth_selected_sub_groups.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_return_percent/get_net_worth_selected_return_percent.dart';
import 'domain/usecases/net_worth/net_worth_filter/selected_return_percent/save_net_worth_selected_return_percent.dart';
import 'domain/usecases/notifications/get_notifications.dart';
import 'domain/usecases/number_of_period/get_number_of_period.dart';
import 'domain/usecases/performance/clear_performance.dart';
import 'domain/usecases/performance/get_performance_primary_grouping.dart';
import 'domain/usecases/performance/get_performance_primary_sub_grouping.dart';
import 'domain/usecases/performance/get_performance_report.dart';
import 'domain/usecases/performance/get_performance_secondary_grouping.dart';
import 'domain/usecases/performance/get_performance_secondary_sub_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_as_on_date/get_performance_selected_as_on_date.dart';
import 'domain/usecases/performance/performance_filter/selected_as_on_date/save_performance_selected_as_on_date.dart';
import 'domain/usecases/performance/performance_filter/selected_currency/get_performance_selected_currency.dart';
import 'domain/usecases/performance/performance_filter/selected_currency/save_performance_selected_currency.dart';
import 'domain/usecases/performance/performance_filter/selected_denomination/get_performance_selected_denomination.dart';
import 'domain/usecases/performance/performance_filter/selected_denomination/save_performance_selected_denomination.dart';
import 'domain/usecases/performance/performance_filter/selected_entity/get_performance_selected_entity.dart';
import 'domain/usecases/performance/performance_filter/selected_entity/save_performance_selected_entity.dart';
import 'domain/usecases/performance/performance_filter/selected_primary_grouping/get_performance_selected_primary_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_primary_grouping/save_performance_selected_primary_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_primary_sub_grouping/get_performance_selected_primary_sub_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_primary_sub_grouping/save_performance_selected_primary_sub_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_return_percent/get_performance_selected_return_percent.dart';
import 'domain/usecases/performance/performance_filter/selected_return_percent/save_performance_selected_return_percent.dart';
import 'domain/usecases/performance/performance_filter/selected_secondary_grouping/get_performance_selected_secondary_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_secondary_grouping/save_performance_selected_secondary_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_secondary_sub_grouping/get_performance_selected_secondary_sub_grouping.dart';
import 'domain/usecases/performance/performance_filter/selected_secondary_sub_grouping/save_performance_selected_secondary_sub_grouping.dart';
import 'domain/usecases/preferences/get_user_preference.dart';
import 'domain/usecases/authentication/login_user.dart';
import 'domain/usecases/authentication/logout_user.dart';
import 'domain/usecases/preferences/save_user_preference.dart';
import 'domain/usecases/user_guide_assets/get_user_guide_assets.dart';
import 'presentation/blocs/authentication/reset_password/reset_password_cubit.dart';
import 'presentation/blocs/authentication/token/token_cubit.dart';
import 'presentation/blocs/cash_balance/cash_balance_grouping/cash_balance_grouping_cubit.dart';
import 'presentation/blocs/cash_balance/cash_balance_report/cash_balance_report_cubit.dart';
import 'presentation/blocs/cash_balance/cash_balance_sub_grouping/cash_balance_sub_grouping_cubit.dart';
import 'presentation/blocs/document/document_filter/document_filter_cubit.dart';
import 'presentation/blocs/document/document_view/document_view_cubit.dart';
import 'presentation/blocs/expense/expense_period/expense_period_cubit.dart';
import 'presentation/blocs/income/income_entity/income_entity_cubit.dart';
import 'presentation/blocs/income/income_number_of_period/income_number_of_period_cubit.dart';
import 'presentation/blocs/income/income_report/income_report_cubit.dart';
import 'presentation/blocs/investment_policy_statement/investment_policy_statement_no_position/investment_policy_statement_no_position_cubit.dart';
import 'presentation/blocs/investment_policy_statement/investment_policy_statement_sub_grouping/investment_policy_statement_sub_grouping_cubit.dart';
import 'presentation/blocs/investment_policy_statement/investment_policy_statement_time_period/investment_policy_statement_time_period_cubit.dart';
import 'presentation/blocs/loading/loading_cubit.dart';
import 'presentation/blocs/net_worth/net_worth_grouping/net_worth_grouping_cubit.dart';
import 'presentation/blocs/net_worth/net_worth_number_of_period/net_worth_number_of_period_cubit.dart';
import 'presentation/blocs/net_worth/net_worth_period/net_worth_period_cubit.dart';
import 'presentation/blocs/net_worth/net_worth_report/net_worth_report_cubit.dart';
import 'presentation/blocs/notification/notification_cubit.dart';
import 'presentation/blocs/performance/performance_currency/performance_currency_cubit.dart';
import 'presentation/blocs/performance/performance_denomination/performance_denomination_cubit.dart';
import 'presentation/blocs/performance/performance_entity/performance_entity_cubit.dart';
import 'presentation/blocs/performance/performance_number_of_period/performance_number_of_period_cubit.dart';
import 'presentation/blocs/performance/performance_primary_grouping/performance_primary_grouping_cubit.dart';
import 'presentation/blocs/performance/performance_primary_sub_grouping/performance_primary_sub_grouping_cubit.dart';
import 'presentation/blocs/performance/performance_secondary_grouping/performance_secondary_grouping_cubit.dart';
import 'presentation/blocs/performance/performance_sort_cubit/performance_sort_cubit.dart';
import 'presentation/blocs/timer/countdown_timer_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance
      .registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());

  getItInstance
      .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<AppRemoteDataSource>(
      () => AppRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<AppLocalDataSource>(
      () => AppLocalDataSourceImpl());

  getItInstance
      .registerLazySingleton<AVLocalDataSource>(() => AVLocalDataSourceImpl());

  getItInstance.registerLazySingleton<AVRemoteDataSource>(
      () => AVRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<AuthenticationLocalDataSource>(
      () => AuthenticationLocalDataSourceImpl());

  getItInstance.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(
        getItInstance(),
      ));

  getItInstance.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(
          getItInstance(), getItInstance(), getItInstance()));

  getItInstance.registerLazySingleton<AVRepository>(() => AVRepositoryImpl(
        getItInstance(),
        getItInstance(),
        getItInstance(),
      ));

  getItInstance.registerLazySingleton<ForgotPassword>(
      () => ForgotPassword(getItInstance()));

  getItInstance
      .registerLazySingleton<LoginUser>(() => LoginUser(getItInstance()));

  getItInstance
      .registerLazySingleton<VerifyOtp>(() => VerifyOtp(getItInstance()));

  getItInstance
      .registerLazySingleton<GetUserData>(() => GetUserData(getItInstance()));

  getItInstance
      .registerLazySingleton<GetUserTheme>(() => GetUserTheme(getItInstance()));

  getItInstance
      .registerLazySingleton<LogoutUser>(() => LogoutUser(getItInstance()));

  getItInstance
      .registerLazySingleton<GetCredentials>(() => GetCredentials(getItInstance()));

  getItInstance
      .registerLazySingleton<SaveCredentials>(() => SaveCredentials(getItInstance()));

  getItInstance.registerLazySingleton<GetUserPreference>(
      () => GetUserPreference(getItInstance()));

  getItInstance.registerLazySingleton<SaveUserPreference>(
      () => SaveUserPreference(getItInstance()));

  getItInstance.registerLazySingleton<GetDashboardEntityListData>(
      () => GetDashboardEntityListData(getItInstance()));

  getItInstance.registerLazySingleton<SaveDashboardWidgetSequence>(
      () => SaveDashboardWidgetSequence(getItInstance()));

  getItInstance.registerLazySingleton<GetDashboardWidgetData>(
      () => GetDashboardWidgetData(getItInstance()));

  getItInstance.registerLazySingleton<FavoritesReport>(
      () => FavoritesReport(getItInstance()));

  getItInstance.registerLazySingleton<FavoritesSequenceReport>(
      () => FavoritesSequenceReport(getItInstance()));

  getItInstance.registerLazySingleton<GetDenomination>(
      () => GetDenomination(getItInstance()));

  getItInstance.registerLazySingleton<GetReturnPercentage>(
      () => GetReturnPercentage(getItInstance()));

  getItInstance.registerLazySingleton<GetNumberOfPeriod>(
      () => GetNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetPartnershipMethod>(
      ()=>GetPartnershipMethod(getItInstance()));

  getItInstance.registerLazySingleton<GetHoldingMethod>(
      ()=>GetHoldingMethod(getItInstance()));

  getItInstance
      .registerLazySingleton<GetPeriod>(() => GetPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSubGrouping>(
          () => GetNetWorthSubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthReport>(
          () => GetNetWorthReport(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthGrouping>(
          () => GetNetWorthGrouping(getItInstance()));

  getItInstance.registerLazySingleton<ClearNetWorth>(
          () => ClearNetWorth(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedReturnPercent>(
          () => GetNetWorthSelectedReturnPercent(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedReturnPercent>(
          () => SaveNetWorthSelectedReturnPercent(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedPrimarySubGrouping>(
          () => GetNetWorthSelectedPrimarySubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedPrimarySubGrouping>(
          () => SaveNetWorthSelectedPrimarySubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedPrimaryGrouping>(
          () => GetNetWorthSelectedPrimaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedPrimaryGrouping>(
          () => SaveNetWorthSelectedPrimaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedPeriod>(
          () => GetNetWorthSelectedPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedPeriod>(
          () => SaveNetWorthSelectedPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedNumberOfPeriod>(
          () => GetNetWorthSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedNumberOfPeriod>(
          () => SaveNetWorthSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedPartnershipMethod>(
      ()=>GetNetWorthSelectedPartnershipMethod(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedPartnershipMethod>(
      ()=>SaveNetWorthSelectedPartnershipMethod(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedHoldingMethod>(
          ()=>GetNetWorthSelectedHoldingMethod(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedHoldingMethod>(
      ()=>SaveNetWorthSelectedHoldingMethod(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedEntity>(
          () => GetNetWorthSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedEntity>(
          () => SaveNetWorthSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedDenomination>(
          () => GetNetWorthSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedDenomination>(
          () => SaveNetWorthSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedCurrency>(
          () => GetNetWorthSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedCurrency>(
          () => SaveNetWorthSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<GetNetWorthSelectedAsOnDate>(
          () => GetNetWorthSelectedAsOnDate(getItInstance()));

  getItInstance.registerLazySingleton<SaveNetWorthSelectedAsOnDate>(
          () => SaveNetWorthSelectedAsOnDate(getItInstance()));

  getItInstance.registerLazySingleton<GetInvestmentPolicyStatementReport>(
      () => GetInvestmentPolicyStatementReport(getItInstance()));

  getItInstance.registerLazySingleton<GetInvestmentPolicyStatementGrouping>(
      () => GetInvestmentPolicyStatementGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetCurrencies>(
      () => GetCurrencies(getItInstance()));

  getItInstance.registerLazySingleton<GetInvestmentPolicyStatementPolicies>(
      () => GetInvestmentPolicyStatementPolicies(getItInstance()));

  getItInstance.registerLazySingleton<GetInvestmentPolicyStatementSubGrouping>(
      () => GetInvestmentPolicyStatementSubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetInvestmentPolicyStatementTimePeriod>(
      () => GetInvestmentPolicyStatementTimePeriod(getItInstance()));

  getItInstance.registerLazySingleton<ClearInvestmentPolicyStatement>(
      () => ClearInvestmentPolicyStatement(getItInstance()));

  getItInstance.registerLazySingleton<GetCashBalanceReport>(
      () => GetCashBalanceReport(getItInstance()));

  getItInstance.registerFactory<CashBalanceSortCubit>(() =>
      CashBalanceSortCubit(
          saveCBSOrtFilter: getItInstance(), cbSortFilter: getItInstance()));

  getItInstance.registerFactory<SaveCashBalanceSelectedAsOnDate>(
      () => SaveCashBalanceSelectedAsOnDate(getItInstance()));

  getItInstance.registerFactory<GetCashBalanceSelectedAsOnDate>(
      () => GetCashBalanceSelectedAsOnDate(getItInstance()));

  getItInstance.registerFactory<SaveCashBalanceSelectedDenomination>(
      () => SaveCashBalanceSelectedDenomination(getItInstance()));

  getItInstance.registerFactory<GetCashBalanceSelectedDenomination>(
      () => GetCashBalanceSelectedDenomination(getItInstance()));

  getItInstance.registerFactory<SaveCashBalanceSelectedCurrency>(
      () => SaveCashBalanceSelectedCurrency(getItInstance()));

  getItInstance.registerFactory<GetCashBalanceSelectedCurrency>(
      () => GetCashBalanceSelectedCurrency(getItInstance()));

  getItInstance.registerFactory<SaveCashBalanceSelectedPeriod>(
      () => SaveCashBalanceSelectedPeriod(getItInstance()));

  getItInstance.registerFactory<GetCashBalanceSelectedPeriod>(
      () => GetCashBalanceSelectedPeriod(getItInstance()));

  getItInstance.registerFactory<SaveCashBalanceSelectedNumberOfPeriod>(
      () => SaveCashBalanceSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerFactory<GetCashBalanceSelectedNumberOfPeriod>(
      () => GetCashBalanceSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerFactory<StealthCubit>(() => StealthCubit());

  getItInstance.registerLazySingleton<GetCashBalanceSubGrouping>(
      () => GetCashBalanceSubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetCashBalanceSelectedPrimarySubGrouping>(
      () => GetCashBalanceSelectedPrimarySubGrouping(getItInstance()));

  getItInstance
      .registerLazySingleton<SaveCashBalanceSelectedPrimarySubGrouping>(
          () => SaveCashBalanceSelectedPrimarySubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetCashBalanceGrouping>(
      () => GetCashBalanceGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetCashBalanceSelectedPrimaryGrouping>(
      () => GetCashBalanceSelectedPrimaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<SaveCashBalanceSelectedPrimaryGrouping>(
      () => SaveCashBalanceSelectedPrimaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetCashBalanceSelectedEntity>(
      () => GetCashBalanceSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<SaveCashBalanceSelectedEntity>(
      () => SaveCashBalanceSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetCashBalanceAccounts>(
      () => GetCashBalanceAccounts(getItInstance()));

  getItInstance.registerLazySingleton<GetCashBalanceSelectedAccounts>(
      () => GetCashBalanceSelectedAccounts(getItInstance()));

  getItInstance.registerLazySingleton<SaveCashBalanceSelectedAccounts>(
      () => SaveCashBalanceSelectedAccounts(getItInstance()));

  getItInstance.registerLazySingleton<ClearCashBalance>(
      () => ClearCashBalance(getItInstance()));


  getItInstance.registerLazySingleton<GetNetWorthReturnPercent>(
      () => GetNetWorthReturnPercent(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformancePrimaryGrouping>(
      () => GetPerformancePrimaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformancePrimarySubGrouping>(
      () => GetPerformancePrimarySubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSecondaryGrouping>(
      () => GetPerformanceSecondaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSecondarySubGrouping>(
      () => GetPerformanceSecondarySubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceReport>(
      () => GetPerformanceReport(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedEntity>(
      () => GetPerformanceSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedEntity>(
      () => SavePerformanceSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedPrimaryGrouping>(
      () => GetPerformanceSelectedPrimaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedPrimaryGrouping>(
      () => SavePerformanceSelectedPrimaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedPrimarySubGrouping>(
      () => GetPerformanceSelectedPrimarySubGrouping(getItInstance()));

  getItInstance
      .registerLazySingleton<SavePerformanceSelectedPrimarySubGrouping>(
          () => SavePerformanceSelectedPrimarySubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedSecondaryGrouping>(
      () => GetPerformanceSelectedSecondaryGrouping(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedSecondaryGrouping>(
      () => SavePerformanceSelectedSecondaryGrouping(getItInstance()));

  getItInstance
      .registerLazySingleton<GetPerformanceSelectedSecondarySubGrouping>(
          () => GetPerformanceSelectedSecondarySubGrouping(getItInstance()));

  getItInstance
      .registerLazySingleton<SavePerformanceSelectedSecondarySubGrouping>(
          () => SavePerformanceSelectedSecondarySubGrouping(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedPartnershipMethod>(
      ()=>GetPerformanceSelectedPartnershipMethod(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedPartnershipMethod>(
      ()=>SavePerformanceSelectedPartnershipMethod(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedHoldingMethod>(
      ()=>GetPerformanceSelectedHoldingMethod(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedHoldingMethod>(
      ()=>SavePerformanceSelectedHoldingMethod(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedReturnPercent>(
      () => GetPerformanceSelectedReturnPercent(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedReturnPercent>(
      () => SavePerformanceSelectedReturnPercent(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedCurrency>(
      () => GetPerformanceSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedCurrency>(
      () => SavePerformanceSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedDenomination>(
      () => GetPerformanceSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedDenomination>(
      () => SavePerformanceSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<GetPerformanceSelectedAsOnDate>(
      () => GetPerformanceSelectedAsOnDate(getItInstance()));

  getItInstance.registerLazySingleton<SavePerformanceSelectedAsOnDate>(
      () => SavePerformanceSelectedAsOnDate(getItInstance()));

  getItInstance.registerLazySingleton<ClearPerformance>(
      () => ClearPerformance(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseReport>(
      () => GetExpenseReport(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseAccount>(
      () => GetExpenseAccount(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseSelectedAccounts>(
      () => GetExpenseSelectedAccounts(getItInstance()));

  getItInstance.registerLazySingleton<SaveExpenseSelectedAccounts>(
      () => SaveExpenseSelectedAccounts(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseSelectedCurrency>(
      () => GetExpenseSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<SaveExpenseSelectedCurrency>(
      () => SaveExpenseSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseSelectedDenomination>(
      () => GetExpenseSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<SaveExpenseSelectedDenomination>(
      () => SaveExpenseSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseSelectedEntity>(
      () => GetExpenseSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<SaveExpenseSelectedEntity>(
      () => SaveExpenseSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseSelectedNumberOfPeriod>(
      () => GetExpenseSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveExpenseSelectedNumberOfPeriod>(
      () => SaveExpenseSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetExpenseSelectedPeriod>(
      () => GetExpenseSelectedPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveExpenseSelectedPeriod>(
      () => SaveExpenseSelectedPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeAccount>(
      () => GetIncomeAccount(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeReport>(
      () => GetIncomeReport(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeSelectedEntity>(
      () => GetIncomeSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<SaveIncomeSelectedEntity>(
      () => SaveIncomeSelectedEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeSelectedAccounts>(
      () => GetIncomeSelectedAccounts(getItInstance()));

  getItInstance.registerLazySingleton<SaveIncomeSelectedAccounts>(
      () => SaveIncomeSelectedAccounts(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeSelectedPeriod>(
      () => GetIncomeSelectedPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveIncomeSelectedPeriod>(
      () => SaveIncomeSelectedPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeSelectedNumberOfPeriod>(
      () => GetIncomeSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveIncomeSelectedNumberOfPeriod>(
      () => SaveIncomeSelectedNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeSelectedCurrency>(
      () => GetIncomeSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<SaveIncomeSelectedCurrency>(
      () => SaveIncomeSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeSelectedDenomination>(
      () => GetIncomeSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<SaveIncomeSelectedDenomination>(
      () => SaveIncomeSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeExpensePeriod>(
      () => GetIncomeExpensePeriod(getItInstance()));

  getItInstance.registerLazySingleton<GetIncomeExpenseNumberOfPeriod>(
      () => GetIncomeExpenseNumberOfPeriod(getItInstance()));

  getItInstance.registerLazySingleton<ClearIncomeExpense>(
      () => ClearIncomeExpense(getItInstance()));

  getItInstance
      .registerLazySingleton<GetDocuments>(() => GetDocuments(getItInstance()));

  getItInstance.registerLazySingleton<DownloadDocuments>(
      () => DownloadDocuments(getItInstance()));

  getItInstance.registerLazySingleton<SearchDocuments>(
      () => SearchDocuments(getItInstance()));

  getItInstance.registerLazySingleton<GetUserGuideAssets>(
      () => GetUserGuideAssets(getItInstance()));

  getItInstance.registerLazySingleton<GetNotifications>(
      () => GetNotifications(getItInstance()));

  getItInstance.registerLazySingleton<SaveSelectedDashboardEntity>(
      () => SaveSelectedDashboardEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetSelectedDashboardEntity>(
      () => GetSelectedDashboardEntity(getItInstance()));

  getItInstance.registerLazySingleton<SaveSelectedDocumentEntity>(
      () => SaveSelectedDocumentEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetSelectedDocumentEntity>(
      () => GetSelectedDocumentEntity(getItInstance()));

  getItInstance.registerLazySingleton<GetIpsPolicyFilter>(
      () => GetIpsPolicyFilter(getItInstance()));

  getItInstance.registerLazySingleton<GetIpsSubFilter>(
      () => GetIpsSubFilter(getItInstance()));

  getItInstance.registerLazySingleton<GetIpsReturnFilter>(
      () => GetIpsReturnFilter(getItInstance()));

  getItInstance.registerLazySingleton<SaveIpsPolicyFilter>(
      () => SaveIpsPolicyFilter(getItInstance()));

  getItInstance.registerLazySingleton<SaveIpsReturnFilter>(
      () => SaveIpsReturnFilter(getItInstance()));

  getItInstance.registerLazySingleton<SaveIpsSubFilter>(
      () => SaveIpsSubFilter(getItInstance()));

  getItInstance.registerLazySingleton<SaveCBSortFilter>(
      () => SaveCBSortFilter(getItInstance()));

  getItInstance.registerLazySingleton<GetCBSortFilter>(
      () => GetCBSortFilter(getItInstance()));

  getItInstance.registerLazySingleton<GetIncExpSavedAccounts>(
      () => GetIncExpSavedAccounts(getItInstance()));

  getItInstance.registerLazySingleton<GetIncExpSavedPeriod>(
      () => GetIncExpSavedPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveSelectedIncExpAccounts>(
      () => SaveSelectedIncExpAccounts(getItInstance()));

  getItInstance.registerLazySingleton<SaveSelectedIncExpPeriod>(
      () => SaveSelectedIncExpPeriod(getItInstance()));

  getItInstance.registerLazySingleton<SaveSelectedCurrency>(
      () => SaveSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<GetSelectedCurrency>(
      () => GetSelectedCurrency(getItInstance()));

  getItInstance.registerLazySingleton<BiometricService>(
      () => BiometricService(getItInstance()));
  getItInstance.registerLazySingleton<GetSelectedDenomination>(
      () => GetSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<SaveSelectedDenomination>(
      () => SaveSelectedDenomination(getItInstance()));

  getItInstance.registerLazySingleton<DisConnectServer>(
      () => DisConnectServer(getItInstance()));

  getItInstance.registerLazySingleton<SendChatMessage>(
      () => SendChatMessage(getItInstance()));

  getItInstance
      .registerLazySingleton<GetAllChats>(() => GetAllChats(getItInstance()));

  getItInstance
      .registerLazySingleton<ChatStream>(() => ChatStream(getItInstance()));

  getItInstance.registerLazySingleton<ConnectServer>(
      () => ConnectServer(getItInstance()));

  getItInstance.registerLazySingleton<ClearAllTheFilters>(
      () => ClearAllTheFilters(getItInstance()));

  getItInstance.registerFactory(() => LoginCubit(
        loginUser: getItInstance(),
        logoutUser: getItInstance(),
        loadingCubit: getItInstance(),
        setUserPreference: getItInstance(),
        getUserPreference: getItInstance(),
      ));

  getItInstance.registerFactory(() => ForgotPasswordCubit(
        forgotPassword: getItInstance(),
        loadingCubit: getItInstance(),
      ));

  getItInstance.registerSingleton<LoadingCubit>(LoadingCubit());

  getItInstance.registerSingleton<InternetConnectivityCubit>(
      InternetConnectivityCubit());

  getItInstance.registerSingleton<AppThemeCubit>(AppThemeCubit(
    getUserTheme: getItInstance(),
    loadingCubit: getItInstance(),
  ));

  getItInstance.registerFactory<TimerCubit>(() => TimerCubit());

  getItInstance.registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(
      loadingCubit: getItInstance(),
      reset: getItInstance(),
      setUserPreference: getItInstance()));

  getItInstance.registerLazySingleton<ResetPassword>(
      () => ResetPassword(getItInstance()));

  getItInstance.registerFactory<MfaLoginCubit>(() => MfaLoginCubit(
      loadingCubit: getItInstance(),
      verify: getItInstance(),
      setUserPreference: getItInstance()));

  getItInstance.registerFactory<LoginCheckCubit>(() => LoginCheckCubit(
        getUserPreference: getItInstance(),
        biometricService: getItInstance(),
        loginCubit: getItInstance(),
      ));

  getItInstance.registerFactory<DashboardCubit>(() => DashboardCubit(
      loadingCubit: getItInstance(),
      getDashboardWidgetData: getItInstance(),
      saveDashboardSequence: getItInstance()));

  getItInstance
      .registerFactory<DenominationFilterCubit>(() => DenominationFilterCubit(
            getDenominationList: getItInstance(),
            getSelectedDenomination: getItInstance(),
            saveSelectedDenomination: getItInstance(),
          ));

  getItInstance.registerFactory<CurrencyFilterCubit>(() => CurrencyFilterCubit(
        getCurrencies: getItInstance(),
        getSelectedCurrency: getItInstance(),
        saveSelectedCurrency: getItInstance(),
      ));

  getItInstance
      .registerFactory<DashboardFilterCubit>(() => DashboardFilterCubit(
            getDashboardEntityListData: getItInstance(),
            saveSelectedDashboardEntity: getItInstance(),
            getSelectedDashboardEntity: getItInstance(),
          ));

  getItInstance.registerFactory<DashboardDatePickerCubit>(
      () => DashboardDatePickerCubit());

  getItInstance.registerFactory<TokenCubit>(() => TokenCubit(
    getUserPreference: getItInstance(),
  ));

  getItInstance.registerFactory<UniversalEntityFilterCubit>(() => UniversalEntityFilterCubit(
    loginCheckCubit: getItInstance(),
    getDashboardEntityListData: getItInstance()
  ));

  getItInstance.registerFactory<UniversalFilterAsOnDateCubit>(() => UniversalFilterAsOnDateCubit());

  getItInstance.registerFactory<UniversalFilterCubit>(() => UniversalFilterCubit(
    universalFilterAsOnDateCubit: getItInstance(),
    universalEntityFilterCubit: getItInstance(),
    clearAllTheFilters: getItInstance(),
  ));

  getItInstance.registerFactory<FavouriteUniversalFilterAsOnDateCubit>(() => FavouriteUniversalFilterAsOnDateCubit());
  getItInstance.registerFactory<FavouriteUniversalFilterCubit>(() => FavouriteUniversalFilterCubit(
    favouriteUniversalFilterAsOnDateCubit: getItInstance(),
  ));

  getItInstance.registerFactory<UserCubit>(() => UserCubit(
      saveUserPreference: getItInstance(),
      favoritesCubit: getItInstance(),
      getUserData: getItInstance(),
      appThemeCubit: getItInstance(),
      getUserPreference: getItInstance(),
      tokenCubit: getItInstance(),
      loginCheckCubit: getItInstance()));

  getItInstance
      .registerFactory<DashboardSearchCubit>(() => DashboardSearchCubit(
            loadingCubit: getItInstance(),
            getDashboardWidgetData: getItInstance(),
          ));

  getItInstance.registerFactory<NetWorthPrimarySubGroupingCubit>(
          () => NetWorthPrimarySubGroupingCubit(
            loginCheckCubit: getItInstance(),
            getNetWorthSelectedPrimarySubGrouping: getItInstance(),
            getNetWorthSubGrouping: getItInstance(),
            saveNetWorthSelectedPrimarySubGrouping: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthReturnPercentCubit>(
          () => NetWorthReturnPercentCubit(
            getNetWorthSelectedReturnPercent: getItInstance(),
            getReturnPercentage: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthReportCubit>(
          () => NetWorthReportCubit(
            saveNetWorthSelectedPrimarySubGrouping: getItInstance(),
            loginCheckCubit: getItInstance(),
            netWorthPeriodCubit: getItInstance(),
            getNetWorthReport: getItInstance(),
            loadingCubit: getItInstance(),
            netWorthAsOnDateCubit: getItInstance(),
            netWorthCurrencyCubit: getItInstance(),
            netWorthDenominationCubit: getItInstance(),
            netWorthEntityCubit: getItInstance(),
            netWorthLoadingCubit: getItInstance(),
            netWorthNumberOfPeriodCubit: getItInstance(),
            netWorthPrimaryGroupingCubit: getItInstance(),
            netWorthPrimarySubGroupingCubit: getItInstance(),
            netWorthReturnPercentCubit: getItInstance(),
            saveNetWorthSelectedAsOnDate: getItInstance(),
            saveNetWorthSelectedCurrency: getItInstance(),
            saveNetWorthSelectedDenomination: getItInstance(),
            saveNetWorthSelectedEntity: getItInstance(),
            saveNetWorthSelectedNumberOfPeriod: getItInstance(),
            saveNetWorthSelectedPeriod: getItInstance(),
            saveNetWorthSelectedPrimaryGrouping: getItInstance(),
            saveNetWorthSelectedReturnPercent: getItInstance(),
            userPreference: getItInstance(),
            saveNetWorthSelectedPartnershipMethod: getItInstance(),
            netWorthPartnershipMethodCubit: getItInstance(),
            netWorthHoldingMethodCubit: getItInstance(),
            saveNetWorthSelectedHoldingMethod: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthPeriodCubit>(
          () => NetWorthPeriodCubit(
            getPeriod: getItInstance(),
            getNetWorthSelectedPeriod: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthNumberOfPeriodCubit>(
          () => NetWorthNumberOfPeriodCubit(
            getNumberOfPeriod: getItInstance(),
            getNetWorthSelectedNumberOfPeriod: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthPartnershipMethodCubit>(
      ()=> NetWorthPartnershipMethodCubit(
          getPartnershipMethod: getItInstance(),
          getNetworthSelectedPartnershipMethod: getItInstance()
      ));

  getItInstance.registerFactory<NetWorthHoldingMethodCubit>(
      ()=>NetWorthHoldingMethodCubit(
          getHoldingMethod: getItInstance(),
          getNetWorthSelectedHoldingMethod: getItInstance()));

  getItInstance.registerFactory<NetWorthLoadingCubit>(
          () => NetWorthLoadingCubit());

  getItInstance.registerFactory<NetWorthGroupingCubit>(
          () => NetWorthGroupingCubit(
            loginCheckCubit: getItInstance(),
            clearNetWorth: getItInstance(),
            getNetWorthGrouping: getItInstance(),
            getNetWorthSelectedPrimaryGrouping: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthEntityCubit>(
          () => NetWorthEntityCubit(
            loginCheckCubit: getItInstance(),
            getDashboardEntityListData: getItInstance(),
            getNetWorthSelectedEntity: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthDenominationCubit>(
          () => NetWorthDenominationCubit(
            getDenomination: getItInstance(),
            getNetWorthSelectedDenomination: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthCurrencyCubit>(
          () => NetWorthCurrencyCubit(
            getCurrencies: getItInstance(),
            getNetWorthSelectedCurrency: getItInstance(),
      ));

  getItInstance.registerFactory<NetWorthAsOnDateCubit>(
          () => NetWorthAsOnDateCubit(
            getNetWorthSelectedAsOnDate: getItInstance(),
      ));

  getItInstance.registerFactory<InvestmentPolicyStatementSubGroupingCubit>(
      () => InvestmentPolicyStatementSubGroupingCubit(
            saveIpsSubFilters: getItInstance(),
          ));

  getItInstance.registerFactory<InvestmentPolicyStatementPolicyCubit>(() =>
      InvestmentPolicyStatementPolicyCubit(
          saveIpsPolicyFilter: getItInstance()));

  getItInstance.registerFactory<InvestmentPolicyStatementTimePeriodCubit>(() =>
      InvestmentPolicyStatementTimePeriodCubit(
          saveIpsReturnFilter: getItInstance()));

  getItInstance.registerFactory<InvestmentPolicyStatementReportCubit>(() =>
      InvestmentPolicyStatementReportCubit(
          loadingCubit: getItInstance(),
          investmentPolicyStatementTimePeriodCubit: getItInstance(),
          getInvestmentPolicyStatementReport: getItInstance(),
          getUserPreference: getItInstance(),
          investmentPolicyStatementTimestampCubit: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<InvestmentPolicyStatementTabbedCubit>(() =>
      InvestmentPolicyStatementTabbedCubit(
          getInvestmentPolicyStatementSubGrouping: getItInstance(),
          getInvestmentPolicyStatementPolicies: getItInstance(),
          getInvestmentPolicyStatementTimePeriod: getItInstance(),
          investmentPolicyStatementReportCubit: getItInstance(),
          investmentPolicyStatementSubGroupingCubit: getItInstance(),
          investmentPolicyStatementPolicyCubit: getItInstance(),
          getIpsReturnFilter: getItInstance(),
          getIpsSubFilter: getItInstance(),
          getIpsPolicyFilter: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<InvestmentPolicyStatementGroupingCubit>(() =>
      InvestmentPolicyStatementGroupingCubit(
          investmentPolicyStatementTabbedCubit: getItInstance(),
          clearInvestmentPolicyStatement: getItInstance(),
          getInvestmentPolicyStatementGrouping: getItInstance(),
          getInvestmentPolicyStatementSubGrouping: getItInstance(),
          getInvestmentPolicyStatementReport: getItInstance(),
          getInvestmentPolicyStatementTimePeriod: getItInstance(),
          getInvestmentPolicyStatementPolicies: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<InvestmentPolicyNoPositionCubit>(
      () => InvestmentPolicyNoPositionCubit());

  getItInstance.registerFactory<InvestmentPolicyStatementTimestampCubit>(
      () => InvestmentPolicyStatementTimestampCubit());

  getItInstance.registerFactory<CashBalanceEntityCubit>(() =>
      CashBalanceEntityCubit(
          getCashBalanceSelectedEntity: getItInstance(),
          getDashboardEntityListData: getItInstance(),
          saveCashBalanceSelectedEntity: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<CashBalanceAccountCubit>(() =>
      CashBalanceAccountCubit(
          getCashBalanceAccounts: getItInstance(),
          getCashBalanceSelectedAccounts: getItInstance(),
          saveCashBalanceSelectedAccounts: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<CashBalancePrimaryGroupingCubit>(() =>
      CashBalancePrimaryGroupingCubit(
          getCashBalanceGrouping: getItInstance(),
          getCashBalanceSelectedPrimaryGrouping: getItInstance(),
          saveCashBalanceSelectedPrimaryGrouping: getItInstance(),
          clearCashBalance: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<CashBalanceReportCubit>(() =>
      CashBalanceReportCubit(
          loadingCubit: getItInstance(),
          cashBalanceSortCubit: getItInstance(),
          saveCashBalanceSelectedAccounts: getItInstance(),
          getCashBalanceReport: getItInstance(),
          saveCashBalanceSelectedAsOnDate: getItInstance(),
          saveCashBalanceSelectedCurrency: getItInstance(),
          cashBalanceCurrencyCubit: getItInstance(),
          cashBalanceDenominationCubit: getItInstance(),
          cashBalanceNumberOfPeriodCubit: getItInstance(),
          cashBalancePeriodCubit: getItInstance(),
          cashBalanceAsOnDateCubit: getItInstance(),
          cashBalancePrimarySubGroupingCubit: getItInstance(),
          cashBalancePrimaryGroupingCubit: getItInstance(),
          cashBalanceEntityCubit: getItInstance(),
          cashBalanceAccountCubit: getItInstance(),
          saveCashBalanceSelectedPrimaryGrouping: getItInstance(),
          saveCashBalanceSelectedEntity: getItInstance(),
          saveCashBalanceSelectedDenomination: getItInstance(),
          saveCashBalanceSelectedNumberOfPeriod: getItInstance(),
          saveCashBalanceSelectedPeriod: getItInstance(),
          saveCashBalanceSelectedPrimarySubGrouping: getItInstance(),
          loginCheckCubit: getItInstance(),
          cashBalanceLoadingCubit: getItInstance(),
      ));

  getItInstance.registerFactory<CashBalancePrimarySubGroupingCubit>(
      () => CashBalancePrimarySubGroupingCubit(
            getCashBalanceSelectedPrimarySubGrouping: getItInstance(),
            getCashBalanceSubGrouping: getItInstance(),
            loginCheckCubit: getItInstance(),
            saveCashBalanceSelectedPrimarySubGrouping: getItInstance(),
          ));

  getItInstance
      .registerFactory<CashBalancePeriodCubit>(() => CashBalancePeriodCubit(
            getPeriod: getItInstance(),
            getCashBalanceSelectedPeriod: getItInstance(),
            saveCashBalanceSelectedPeriod: getItInstance(),
          ));

  getItInstance.registerFactory<CashBalanceNumberOfPeriodCubit>(
      () => CashBalanceNumberOfPeriodCubit(
            getNumberOfPeriod: getItInstance(),
            getCashBalanceSelectedNumberOfPeriod: getItInstance(),
            saveCashBalanceSelectedNumberOfPeriod: getItInstance(),
          ));

  getItInstance
      .registerFactory<CashBalanceCurrencyCubit>(() => CashBalanceCurrencyCubit(
            getCashBalanceSelectedCurrency: getItInstance(),
            getCurrencies: getItInstance(),
            saveCashBalanceSelectedCurrency: getItInstance(),
          ));

  getItInstance.registerFactory<CashBalanceDenominationCubit>(
      () => CashBalanceDenominationCubit(
            getCashBalanceSelectedDenomination: getItInstance(),
            getDenomination: getItInstance(),
            saveCashBalanceSelectedDenomination: getItInstance(),
          ));

  getItInstance
      .registerFactory<CashBalanceAsOnDateCubit>(() => CashBalanceAsOnDateCubit(
            getCashBalanceSelectedAsOnDate: getItInstance(),
            saveCashBalanceSelectedAsOnDate: getItInstance(),
          ));


  getItInstance.registerFactory<PerformanceLoadingCubit>(
          () => PerformanceLoadingCubit());

  getItInstance.registerFactory<CashBalanceLoadingCubit>(
          () => CashBalanceLoadingCubit());

  getItInstance.registerFactory<IncomeLoadingCubit>(
          () => IncomeLoadingCubit());

  getItInstance.registerFactory<ExpenseLoadingCubit>(
          () => ExpenseLoadingCubit());

  getItInstance.registerFactory<PerformancePrimarySubGroupingCubit>(() =>
      PerformancePrimarySubGroupingCubit(
          getPerformancePrimarySubGrouping: getItInstance(),
          getPerformanceSelectedPrimarySubGrouping: getItInstance(),
          savePerformanceSelectedPrimarySubGrouping: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<PerformancePrimaryGroupingCubit>(
      () => PerformancePrimaryGroupingCubit(
            loginCheckCubit: getItInstance(),
            getPerformanceGrouping: getItInstance(),
            clearPerformance: getItInstance(),
            getPerformanceReport: getItInstance(),
            getPerformanceSelectedPrimaryGrouping: getItInstance(),
            savePerformanceSelectedPrimaryGrouping: getItInstance(),
          ));

  getItInstance.registerFactory<PerformancePartnershipMethodCubit>(
      ()=>PerformancePartnershipMethodCubit(
          getPartnershipMethod: getItInstance(),
          getPerformanceSelectedPartnershipMethod: getItInstance()));

  getItInstance.registerFactory<PerformanceHoldingMethodCubit>(
      ()=> PerformanceHoldingMethodCubit(
          getHoldingMethod: getItInstance(),
          getPerformanceSelectedHoldingMethod: getItInstance()));

  getItInstance
      .registerFactory<PerformancePeriodCubit>(() => PerformancePeriodCubit(
            getPeriod: getItInstance(),
          ));

  getItInstance.registerFactory<PerformanceNumberOfPeriodCubit>(
      () => PerformanceNumberOfPeriodCubit(
            getNumberOfPeriod: getItInstance(),
          ));

  getItInstance.registerFactory<PerformanceReturnPercentCubit>(
      () => PerformanceReturnPercentCubit(
            getReturnPercentage: getItInstance(),
            getPerformanceSelectedReturnPercent: getItInstance(),
            savePerformanceSelectedReturnPercent: getItInstance(),
          ));

  getItInstance
      .registerFactory<PerformanceCurrencyCubit>(() => PerformanceCurrencyCubit(
            getCurrencies: getItInstance(),
            getPerformanceSelectedCurrency: getItInstance(),
            savePerformanceSelectedCurrency: getItInstance(),
          ));

  getItInstance
      .registerFactory<PerformanceAsOnDateCubit>(() => PerformanceAsOnDateCubit(
            getPerformanceSelectedAsOnDate: getItInstance(),
            savePerformanceSelectedAsOnDate: getItInstance(),
          ));

  getItInstance.registerFactory<PerformanceDenominationCubit>(
      () => PerformanceDenominationCubit(
            getDenomination: getItInstance(),
            getPerformanceSelectedDenomination: getItInstance(),
            savePerformanceSelectedDenomination: getItInstance(),
          ));

  getItInstance.registerFactory<PerformanceSecondarySubGroupingCubit>(() =>
      PerformanceSecondarySubGroupingCubit(
          getPerformanceSecondarySubGrouping: getItInstance(),
          getPerformanceSelectedSecondarySubGrouping: getItInstance(),
          savePerformanceSelectedSecondarySubGrouping: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<PerformanceSecondaryGroupingCubit>(() =>
      PerformanceSecondaryGroupingCubit(
          getPerformanceSecondaryGrouping: getItInstance(),
          clearPerformance: getItInstance(),
          getPerformanceReport: getItInstance(),
          loginCheckCubit: getItInstance(),
          getPerformanceSelectedSecondaryGrouping: getItInstance(),
          savePerformanceSelectedSecondaryGrouping: getItInstance()));

  getItInstance.registerFactory<PerformanceEntityCubit>(() =>
      PerformanceEntityCubit(
          getDashboardEntityListData: getItInstance(),
          getPerformanceSelectedEntity: getItInstance(),
          savePerformanceSelectedEntity: getItInstance(),
          loginCheckCubit: getItInstance()));

  getItInstance
      .registerFactory<PerformanceSortCubit>(() => PerformanceSortCubit());

  getItInstance
      .registerFactory<PerformanceReportCubit>(() => PerformanceReportCubit(
            loginCheckCubit: getItInstance(),
            loadingCubit: getItInstance(),
            performanceSortCubit: getItInstance(),
            getPerformanceReport: getItInstance(),
            userPreference: getItInstance(),
            performancePrimaryGroupingCubit: getItInstance(),
            performancePrimarySubGroupingCubit: getItInstance(),
            performanceSecondaryGroupingCubit: getItInstance(),
            performanceSecondarySubGroupingCubit: getItInstance(),
            performanceEntityCubit: getItInstance(),
            performancePeriodCubit: getItInstance(),
            performanceDenominationCubit: getItInstance(),
            performanceNumberOfPeriodCubit: getItInstance(),
            performanceCurrencyCubit: getItInstance(),
            performanceReturnPercentCubit: getItInstance(),
            performanceAsOnDateCubit: getItInstance(),
            savePerformanceSelectedEntity: getItInstance(),
            savePerformanceSelectedPrimaryGrouping: getItInstance(),
            savePerformanceSelectedPrimarySubGrouping: getItInstance(),
            savePerformanceSelectedSecondaryGrouping: getItInstance(),
            savePerformanceSelectedSecondarySubGrouping: getItInstance(),
            savePerformanceSelectedReturnPercent: getItInstance(),
            savePerformanceSelectedCurrency: getItInstance(),
            savePerformanceSelectedDenomination: getItInstance(),
            performanceLoadingCubit: getItInstance(),
            performancePartnershipMethodCubit: getItInstance(),
    savePerformanceSelectedPartnershipMethod: getItInstance(),
    performanceHoldingMethodCubit: getItInstance(),
    savePerformanceSelectedHoldingMethod: getItInstance(),
          ));

  getItInstance.registerFactory<IncomeEntityCubit>(() => IncomeEntityCubit(
        getDashboardEntityListData: getItInstance(),
        loginCheckCubit: getItInstance(),
        saveIncomeSelectedEntity: getItInstance(),
        getIncomeSelectedEntity: getItInstance(),
      ));

  getItInstance.registerFactory<IncomeAccountCubit>(() => IncomeAccountCubit(
        getIncomeAccount: getItInstance(),
        loginCheckCubit: getItInstance(),
        getIncomeSelectedAccounts: getItInstance(),
        saveIncomeSelectedAccounts: getItInstance(),
      ));

  getItInstance.registerFactory<IncomePeriodCubit>(() => IncomePeriodCubit(
        getPeriod: getItInstance(),
        getIncomeSelectedPeriod: getItInstance(),
        saveIncomeSelectedPeriod: getItInstance(),
      ));

  getItInstance.registerFactory<IncomeNumberOfPeriodCubit>(
      () => IncomeNumberOfPeriodCubit(
            getNumberOfPeriod: getItInstance(),
            getIncomeSelectedNumberOfPeriod: getItInstance(),
            saveIncomeSelectedNumberOfPeriod: getItInstance(),
            incomeChartCubit: getItInstance(),
          ));

  getItInstance.registerFactory<IncomeCurrencyCubit>(() => IncomeCurrencyCubit(
        getCurrencies: getItInstance(),
        getIncomeSelectedCurrency: getItInstance(),
        saveIncomeSelectedCurrency: getItInstance(),
      ));

  getItInstance
      .registerFactory<IncomeDenominationCubit>(() => IncomeDenominationCubit(
            getDenomination: getItInstance(),
            getIncomeSelectedDenomination: getItInstance(),
            saveIncomeSelectedDenomination: getItInstance(),
          ));

  getItInstance
      .registerFactory<IncomeAsOnDateCubit>(() => IncomeAsOnDateCubit());

  getItInstance.registerFactory<IncomeSortCubit>(() => IncomeSortCubit());

  getItInstance.registerFactory<IncomeChartCubit>(() => IncomeChartCubit());

  getItInstance.registerFactory<IncomeReportCubit>(() => IncomeReportCubit(
        incomeEntityCubit: getItInstance(),
        incomeAccountCubit: getItInstance(),
        incomePeriodCubit: getItInstance(),
        incomeNumberOfPeriodCubit: getItInstance(),
        incomeCurrencyCubit: getItInstance(),
        incomeDenominationCubit: getItInstance(),
        incomeAsOnDateCubit: getItInstance(),
        getIncomeReport: getItInstance(),
        userPreference: getItInstance(),
        incomeTimestampCubit: getItInstance(),
        incomeSortCubit: getItInstance(),
        incomeLoadingCubit: getItInstance(),
        loginCheckCubit: getItInstance(),
        saveIncomeSelectedEntity: getItInstance(),
        saveIncomeSelectedAccounts: getItInstance(),
        saveIncomeSelectedPeriod: getItInstance(),
        saveIncomeSelectedNumberOfPeriod: getItInstance(),
        saveIncomeSelectedCurrency: getItInstance(),
        saveIncomeSelectedDenomination: getItInstance(),
      ));

  getItInstance
      .registerFactory<IncomeTimestampCubit>(() => IncomeTimestampCubit());

  getItInstance.registerFactory<ExpenseAccountCubit>(() => ExpenseAccountCubit(
      getExpenseAccount: getItInstance(),
      getExpenseSelectedAccounts: getItInstance(),
      saveExpenseSelectedAccounts: getItInstance(),
      loginCheckCubit: getItInstance()));

  getItInstance
      .registerFactory<ExpenseAsOnDateCubit>(() => ExpenseAsOnDateCubit());

  getItInstance.registerFactory<ExpenseChartCubit>(() => ExpenseChartCubit());

  getItInstance
      .registerFactory<ExpenseCurrencyCubit>(() => ExpenseCurrencyCubit(
            getCurrencies: getItInstance(),
            getExpenseSelectedCurrency: getItInstance(),
            saveExpenseSelectedCurrency: getItInstance(),
          ));

  getItInstance.registerFactory<ExpenseDenominationCubit>(
    () => ExpenseDenominationCubit(
      getDenomination: getItInstance(),
      getExpenseSelectedDenomination: getItInstance(),
      saveExpenseSelectedDenomination: getItInstance(),
    ),
  );

  getItInstance.registerFactory<ExpenseEntityCubit>(
    () => ExpenseEntityCubit(
      loginCheckCubit: getItInstance(),
      getDashboardEntityListData: getItInstance(),
      getExpenseSelectedEntity: getItInstance(),
      saveExpenseSelectedEntity: getItInstance(),
    ),
  );

  getItInstance.registerFactory<ExpenseNumberOfPeriodCubit>(
      () => ExpenseNumberOfPeriodCubit(
            expenseChartCubit: getItInstance(),
            getExpenseSelectedNumberOfPeriod: getItInstance(),
            getNumberOfPeriod: getItInstance(),
            saveExpenseSelectedNumberOfPeriod: getItInstance(),
          ));

  getItInstance.registerFactory<ExpensePeriodCubit>(
    () => ExpensePeriodCubit(
      getExpenseSelectedPeriod: getItInstance(),
      getPeriod: getItInstance(),
      saveExpenseSelectedPeriod: getItInstance(),
    ),
  );

  getItInstance.registerFactory<ExpenseSortCubit>(() => ExpenseSortCubit());

  getItInstance
      .registerFactory<ExpenseTimestampCubit>(() => ExpenseTimestampCubit());

  getItInstance
      .registerFactory<UserGuideAssetsCubit>(() => UserGuideAssetsCubit(
      getUserPreference: getItInstance(),
      saveUserPreference: getItInstance(),
      getUserGuideAssets: getItInstance(),
  ));

  getItInstance.registerFactory<ExpenseReportCubit>(() => ExpenseReportCubit(
      getExpenseReport: getItInstance(),
      userPreference: getItInstance(),
      saveExpenseSelectedAccounts: getItInstance(),
      expenseAccountCubit: getItInstance(),
      expenseAsOnDateCubit: getItInstance(),
      expenseCurrencyCubit: getItInstance(),
      expenseDenominationCubit: getItInstance(),
      expenseEntityCubit: getItInstance(),
      expenseNumberOfPeriodCubit: getItInstance(),
      expensePeriodCubit: getItInstance(),
      expenseSortCubit: getItInstance(),
      saveExpenseSelectedCurrency: getItInstance(),
      saveExpenseSelectedDenomination: getItInstance(),
      saveExpenseSelectedEntity: getItInstance(),
      saveExpenseSelectedNumberOfPeriod: getItInstance(),
      saveExpenseSelectedPeriod: getItInstance(),
      expenseTimestampCubit: getItInstance(),
      loginCheckCubit: getItInstance(),
      expenseLoadingCubit: getItInstance(),
  ));

  getItInstance.registerFactory<DocumentCubit>(() => DocumentCubit(
      getDocuments: getItInstance(), loginCheckCubit: getItInstance()));
  getItInstance.registerFactory<DocumentFilterCubit>(() => DocumentFilterCubit(
        getDashboardEntityListData: getItInstance(),
        documentCubit: getItInstance(),
        getSelectedDocumentEntity: getItInstance(),
        saveSelectedDocumentEntity: getItInstance(),
      ));

  getItInstance.registerFactory<FavoritesCubit>(() => FavoritesCubit(
        loginCheckCubit: getItInstance(),
        favoritesReport: getItInstance(),
        getUserPreference: getItInstance(),
        favoritesSequence: getItInstance(),
      ));

  getItInstance.registerFactory<DocumentViewCubit>(() => DocumentViewCubit());

  getItInstance.registerFactory<DocumentSortCubit>(() => DocumentSortCubit());

  getItInstance.registerFactory<DocumentSearchCubit>(() => DocumentSearchCubit(
      searchDocuments: getItInstance(), loginCheckCubit: getItInstance()));

  getItInstance.registerFactory<NotificationCubit>(() => NotificationCubit(
      getNotifications: getItInstance(), loginCheckCubit: getItInstance()));

  getItInstance.registerFactory(() => ChatCubit(
        chatStream: getItInstance(),
        connectServer: getItInstance(),
        disConnectServer: getItInstance(),
        getAllChats: getItInstance(),
        sendChatMessage: getItInstance(),
      ));
}
