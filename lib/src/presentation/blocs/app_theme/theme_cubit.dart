
import 'package:asset_vantage/src/data/models/preferences/app_theme.dart';
import 'package:asset_vantage/src/presentation/blocs/loading/loading_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/authentication/user_entity.dart';
import '../../../domain/usecases/authentication/get_user_theme.dart';

class AppThemeCubit extends Cubit<AppThemeModel?> {
  final GetUserTheme getUserTheme;
  final LoadingCubit loadingCubit;

  AppThemeCubit({
    required this.getUserTheme,
    required this.loadingCubit,
  }) : super(null);

  Future<void> loadAppTheme({required CoBrandingEntity? coBrandingEntity}) async{

    emit(AppThemeModel(
        brandLogo: coBrandingEntity?.brandLogo,
        brandName: coBrandingEntity?.brandName,
        textColor: coBrandingEntity?.textColor,
        scaffoldBackground: coBrandingEntity?.backgroundColor,
        loadingIndicatorColor: coBrandingEntity?.primaryColor,
        buttonColor: coBrandingEntity?.primaryColor,
        appBar: AppBar(
          backArrowColor: coBrandingEntity?.iconColor,
          iconColor: coBrandingEntity?.iconColor
        ),
        toolBar: ToolBarTheme(
          iconColor: coBrandingEntity?.iconColor
        ),
        popupMenu: PopupMenu(
          color: coBrandingEntity?.cardColor
        ),
        card: Card(
          color: coBrandingEntity?.cardColor
        ),
        filter: Filter(
          color: coBrandingEntity?.cardColor,
          iconColor: coBrandingEntity?.primaryColor
        ),
        bottomSheet: BottomSheet(
          color: coBrandingEntity?.cardColor,
          backArrowColor: coBrandingEntity?.primaryColor,
          checkColor: coBrandingEntity?.primaryColor
        ),
        dashboard: Dashboard(
          borderColor: coBrandingEntity?.textColor,
          iconColor: coBrandingEntity?.primaryColor,
          iconBackgroundColor: coBrandingEntity?.cardColor
        ),
      navigationDrawer: NavigationDrawer(
        color: coBrandingEntity?.backgroundColor,
        iconColor: coBrandingEntity?.primaryColor
      ),
      grouping: Grouping(
        iconClor: coBrandingEntity?.primaryColor,
        borderColor: coBrandingEntity?.iconColor
      ),
      searchBar: SearchBar(
        color: coBrandingEntity?.cardColor,
        iconColor: coBrandingEntity?.iconColor
      ),
      document: Document(
        iconColor: coBrandingEntity?.primaryColor
      )

      )
    );

  }
}
