
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/config/validators/login_validators.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/get_user_preference.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/arguments/reset_passoword_argument.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../config/constants/strings_constants.dart';
import '../../../data/models/authentication/credentials.dart';
import '../../../data/models/preferences/user_preference.dart';
import '../../../domain/params/preference/user_preference_params.dart';
import '../../../domain/usecases/preferences/save_user_preference.dart';
import '../../../services/biomatric_service.dart';
import '../../../utilities/helper/flash_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../arguments/mfa_login_argument.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../theme/theme_color.dart';
import '../../widgets/button.dart';
import '../../widgets/contact_support.dart';
import 'login_input_field.dart';
import 'login_label.dart';

class LoginForm extends StatefulWidget {
  final bool isIpad;
  final bool isLandscape;
  const LoginForm({
    Key? key,
    required this.isIpad,
    this.isLandscape = false
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _clientSystemEditingController;
  late TextEditingController _usernameEditingController;
  late TextEditingController _passwordEditingController;

  late BiometricService biometricService;

  late FocusNode _clientSystemNode;
  late FocusNode _usernameNode;
  late FocusNode _passwordNode;

  String password = '';
  String username = '';
  String systemName = '';
  Map<dynamic, dynamic>? credentials;
  bool isEnabled = false;
  String? errorMsg;
  String? systemErr;


  @override
  void initState() {
    super.initState();
    _clientSystemEditingController = TextEditingController();
    _usernameEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();

    biometricService = getItInstance<BiometricService>();

    setCredentials();

    _clientSystemNode = FocusNode();
    _usernameNode = FocusNode();
    _passwordNode = FocusNode();
  }

  void updateButtonState() {
    setState(() {
      isEnabled = _clientSystemEditingController.text.isNotEmpty &&
          _usernameEditingController.text.isNotEmpty &&
          _passwordEditingController.text.isNotEmpty;
    });

  }

  void setCredentials() async{

    getItInstance<GetUserPreference>().call(NoParams()).then((either) {
      either.fold((l) {

      }, (user) {

        _clientSystemEditingController.text = user.systemName ?? '';
        if(user.isOnBiometric ?? false) {
          credentials = user.credential;
          print("credentials: $credentials");
          password = user.password ?? '';
          username = user.username ?? '';
          systemName = user.systemName ?? '';
        }
      });

    });
  }


  @override
  void dispose() {
    super.dispose();
    _clientSystemEditingController.dispose();
    _usernameEditingController.dispose();
    _passwordEditingController.dispose();

    _clientSystemNode.dispose();
    _usernameNode.dispose();
    _passwordNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
        child: SizedBox(
          width: widget.isIpad ? ScreenUtil().screenWidth * 0.6 : null,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: LoginInputField(
                      stringKey: "systemName",
                      identifier: "text_systemName",
                      key: Key("sysName"),
                      hintStyle: TextStyle(color: AppColor.textGrey.withValues(alpha: 0.6)),
                      inputHint: StringConstants.clientSystemName,
                      controller: _clientSystemEditingController,
                      focusNode: _clientSystemNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {

                        Credentials? cred = AppHelpers.getCredentialsFromSystemName(credentials: credentials ?? {}, systemName: _clientSystemEditingController.text);
                        if(cred != null) {
                          username = cred.username ?? '';
                          password = cred.password ?? '';
                          _passwordEditingController.clear();
                        }else {
                          username = '';
                          password = '';
                          _usernameEditingController.clear();
                          _passwordEditingController.clear();
                        }
                        setState(() {
                          systemErr = null;
                        });
                        updateButtonState();

                      },
                      validator: (String? text) {},


                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: LoginInputField(
                      stringKey: "username",
                      identifier: "textUsername",
                      key: Key("usernm"),
                      hintStyle: TextStyle(color: AppColor.textGrey.withValues(alpha: 0.6)),
                      inputHint: StringConstants.username,
                      controller: _usernameEditingController,
                      onTap: () async{
                        if(password.isNotEmpty && _usernameEditingController.text.isEmpty
                            && (username.isNotEmpty && password.isNotEmpty)) {
                          if(await biometricService.checkBiometrics()) {
                            if(await biometricService.authenticate()) {
                              _usernameEditingController.text = username;
                              _passwordEditingController.text = password;
                              _initiateLogin();

                            }
                          }
                        }
                      },
                      onChanged: (text){
                        setState(() {
                          errorMsg =null;
                        });
                        updateButtonState();
                      },
                      focusNode: _usernameNode,
                      textInputAction: TextInputAction.next,
                      validator: (String? text) {},
                      isUsername: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_3.h),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: LoginInputField(
                      stringKey: "password",
                      identifier: "textPassword",
                      key: Key("pass"),
                      hintStyle: TextStyle(color: AppColor.textGrey.withValues(alpha: 0.6)),
                      inputHint: StringConstants.password,
                      controller: _passwordEditingController,

                      onTap: () async{
                        if(password.isNotEmpty && _passwordEditingController.text.isEmpty
                            && (username.isNotEmpty && password.isNotEmpty)) {
                          if(await biometricService.checkBiometrics()) {
                            if(await biometricService.authenticate()) {
                              _passwordEditingController.text = password;
                              _usernameEditingController.text = username;
                              _initiateLogin();

                            }
                          }
                        }

                      },
                      onChanged: (text){
                        setState(() {
                          errorMsg = null;
                        });
                        updateButtonState();
                      },
                      isPassword: true,
                      focusNode: _passwordNode,
                      textInputAction: TextInputAction.next,
                      validator: (String? text) {},
                    ),
                  ),
                ),
                if (errorMsg != null)
                  Padding(
                    padding: EdgeInsets.only(left: Sizes.dimen_4.w),
                    child: Text(
                      errorMsg!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: Sizes.dimen_14.sp,
                      ),
                    ),
                  ),
                if(systemErr !=null)
                  Padding(
                    padding: EdgeInsets.only(left: Sizes.dimen_4.w),
                    child: Text(
                      systemErr!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: Sizes.dimen_14.sp,
                      ),
                    ),
                  ),
                SizedBox(height: errorMsg !=null || systemErr !=null ? Sizes.dimen_10.h : Sizes.dimen_14.h),

                Button(
                  isIpad: widget.isIpad,
                  text: StringConstants.login,
                  isEnabled: isEnabled,
                  onPressed: () {
                    _initiateLogin();
                  },
                ),

                UIHelper.verticalSpace(Sizes.dimen_3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: GestureDetector(
                          onTap: () async{
                            HapticFeedback.lightImpact();
                            SystemSound.play(SystemSoundType.click);
                            if(_clientSystemEditingController.text.isNotEmpty) {
                              final Uri url = Uri.parse('https://${_clientSystemEditingController.text.trim()}.assetvantage${AppHelpers.getTopLevelDomain(systemName: _clientSystemEditingController.text.trim())}/user/index/index/forgotpassword');
                              FlashHelper.showToastMessage(context, message: 'You will be redirected to browser to reset your password.', type: ToastType.info);
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            }else {
                              FlashHelper.showToastMessage(context, message: 'Please enter your system name', type: ToastType.warning);
                            }
                          },
                          child: Text(StringConstants.forgotPassword, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColor.textGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.dimen_15.sp
                          ),maxLines: 1,overflow: TextOverflow.ellipsis,)
                      ),
                    ),
                  ],
                ),

                UIHelper.verticalSpace(Sizes.dimen_2.h),

                BlocConsumer<LoginCubit, LoginState>(
                  buildWhen: (previous, current) => current is LoginInitial,
                  builder: (context, state) {
                    return const SizedBox.shrink();
                  },
                  listenWhen: (previous, current) => current is LoginSuccess || current is LoginError || current is LoginFailed,
                  listener: (context, state) {
                    if (state is LoginError){
                      if(state.message=='406'){
                        setState(() {
                          systemErr = StringConstants.incorrectSystemName;
                        });

                      }else {
                        setState(() {
                          errorMsg = StringConstants.incorrectCredentials;
                        });
                      }
                    }else if(state is LoginFailed) {
                      WidgetsBinding.instance.addPostFrameCallback((_){
                        showDialog(context: context, builder: (context) => SupportDialog(title: StringConstants.loginFailed, description: StringConstants.somethingWentWorng, onClicked: () => Navigator.pop(context)),);
                      });
                    }else if(state is LoginSuccess) {
                      if(state.login ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteList.dashboard,
                              (route) => false,
                        );
                      }else if(state.resetPasswordReq ?? false){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteList.resetPassword,
                                (route) => false,
                            arguments: ResetPasswordArgument(
                                username: _usernameEditingController.text,
                                systemName: _clientSystemEditingController.text,
                                awssession: state.awssession,
                                challenge: state.challenge
                            )
                        );
                      }else if(state.mfaLoginReq ?? false){
                        Navigator.of(context).pushNamedAndRemoveUntil(RouteList.mfaLogin, (route) => false,arguments: MfaLoginArgument(
                          username: _usernameEditingController.text,
                          awssession: state.awssession,
                          challenge: state.challenge,
                          systemName: _clientSystemEditingController.text,
                          password: _passwordEditingController.text,
                        ));
                      }
                    }

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initiateLogin() {
    if(LoginValidators.validateUserName(_usernameEditingController.text.trim()) && LoginValidators.validatePassword(_passwordEditingController.text.trim()) && LoginValidators.validateClientSystemName(_clientSystemEditingController.text.trim())) {
      FocusScope.of(context).unfocus();
      context.read<LoginCubit>().initiateLogin(username: _usernameEditingController.text.trim(), password: _passwordEditingController.text.trim(), systemName: _clientSystemEditingController.text.trim());
    }else {
      if(_usernameEditingController.text.trim().isEmpty && _passwordEditingController.text.trim().isEmpty) {
        FlashHelper.showToastMessage(context, message: 'Please enter your system name, username, and password', type: ToastType.warning);
      }else if(_usernameEditingController.text.trim().isEmpty) {
        FlashHelper.showToastMessage(context, message: 'Please enter your username', type: ToastType.warning);
      }else if(_passwordEditingController.text.trim().isEmpty) {
        FlashHelper.showToastMessage(context, message: 'Please enter your password', type: ToastType.warning);

      }else if(_clientSystemEditingController.text.trim().isEmpty) {
        FlashHelper.showToastMessage(context, message: 'Please enter your system name', type: ToastType.warning);

      }

    }
  }


}
