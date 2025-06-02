
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/save_user_preference.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import 'package:asset_vantage/src/config/constants/tnc_pp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constants/strings_constants.dart';
import '../../../data/models/preferences/user_preference.dart';
import '../../../domain/params/preference/user_preference_params.dart';
import '../../../domain/usecases/preferences/get_user_preference.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/dialog.dart';
import 'preference_list_item.dart';

class PreferenceList extends StatefulWidget {
  final void Function() parentState;
  const PreferenceList(this.parentState,{Key? key}) : super(key: key);

  @override
  State<PreferenceList> createState() => _PreferenceListState();
}

class _PreferenceListState extends State<PreferenceList> {
  bool isChecked = false;
  bool darkMode = true;
  late SaveUserPreference saveUserPreference;
  late GetUserPreference getUserPreference;
  late AppThemeCubit _appThemeCubit;

  @override
  void initState() {
    super.initState();
    saveUserPreference = getItInstance<SaveUserPreference>();
    getUserPreference = getItInstance<GetUserPreference>();
    _appThemeCubit = getItInstance<AppThemeCubit>();
    getUserPreference(NoParams()).then((value) {
      value.fold((error) {

      }, (pref) {
        setState(() {
          isChecked = pref.isOnBiometric ?? false;
          darkMode = pref.darkMode ?? true;
        });
      });
    });

  }

  Future<void> launchEmail() async {
    const uri = 'mailto:inquiry@assetvantage.com';
    if(await (canLaunchUrl(Uri.parse(uri)))){
      await launchUrl(Uri.parse(uri));
    }else {
      FlashHelper.showToastMessage(context, message: StringConstants.failedToOpenLink, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    int denominationIndex = 0;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          PreferenceListItem(
            title: 'Privacy Policy',
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AVDialog(
                  data: Privacy.data,
                  headerString: Privacy.headerString,
                  title: 'Privacy Policy',
                  onClick: launchEmail,
                );
              },);
            },
          ),
          PreferenceListItem(
            title: 'Terms & Conditions',
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return const AVDialog(
                  data: TnC.tncData,
                  title: 'Terms & Conditions',
                );
              },);
            },
          ),
          PreferenceListItem(
            title: 'Biometric Login',
            action: CupertinoSwitch(
                activeColor: context.read<AppThemeCubit>().state?.filter?.iconColor != null
                    ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!))
                    : AppColor.primary,
                trackColor: AppColor.grey,
                value: isChecked,
                onChanged: (bool value) {
                    final response = saveUserPreference(UserPreferenceParams(
                        preference: UserPreference(isOnBiometric: value)
                    )).then((response) {
                      response.fold((error) {

                      }, (pref) async{
                        final prefValue = await getUserPreference(NoParams());
                        prefValue.fold((error) {

                        }, (pref) {
                          setState(() {
                            isChecked = pref.isOnBiometric ?? false;
                          });
                        });
                      });
                    });

                }
            ),
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }
}
