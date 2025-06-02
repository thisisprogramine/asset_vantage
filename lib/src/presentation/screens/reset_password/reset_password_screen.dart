import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/screens/reset_password/password_input_field.dart';
import 'package:asset_vantage/src/presentation/widgets/av_app_bar.dart';
import 'package:asset_vantage/src/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../utilities/helper/flash_helper.dart';
import '../../../utilities/helper/ui_helper.dart';
import '../../arguments/login_argument.dart';
import '../../arguments/reset_passoword_argument.dart';
import '../../blocs/authentication/reset_password/reset_password_cubit.dart';
import '../authentication/biomatric_options.dart';

class ResetPassword extends StatefulWidget {
  final ResetPasswordArgument argument;
  const ResetPassword({Key? key, required this.argument}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController _username;
  late TextEditingController _newPassword;
  late TextEditingController _confirmPassword;
  late TextEditingController _systemName;
  late FocusNode _newPasswordNode;
  late FocusNode _confirmPasswordNode;
  late FocusNode _usernameNode;
  late FocusNode _systemNameNode;
  final _formKey = GlobalKey<FormState>();
  late ResetPasswordCubit _resetCubit;

  @override
  void initState() {
    _username = TextEditingController();
    _newPassword = TextEditingController();
    _confirmPassword = TextEditingController();
    _systemName = TextEditingController();
    _systemNameNode = FocusNode();
    _newPasswordNode = FocusNode();
    _confirmPasswordNode = FocusNode();
    _usernameNode = FocusNode();

    _username.text = widget.argument.username ?? '';
    _systemName.text = widget.argument.systemName ?? '';

    _resetCubit = getItInstance<ResetPasswordCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    _newPasswordNode.dispose();
    _confirmPasswordNode.dispose();
    _usernameNode.dispose();
    _resetCubit.close();
    _systemName.dispose();
    _systemNameNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>_resetCubit),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
              appBar: AVAppBar(
                title: "Reset Password",
                leading: Container(),
              ),
              bottomNavigationBar: orientation == Orientation.portrait ? const BiometricOptions() : null,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_20.w),
                        child: SizedBox(
                          width: !(constraints.maxWidth < 600)
                              ? ScreenUtil().screenWidth * 0.6
                              : null,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_0.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Reset".toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Please reset the default password to a new one",
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                UIHelper.verticalSpace(Sizes.dimen_4.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: PasswordInputField(
                                        inputHint: "Enter username",
                                        validator: (String? text) {
                                          if(text?.trim().isEmpty ?? true){
                                            return "Please enter your username";
                                          }
                                          return null;
                                        },
                                        focusNode: _usernameNode,
                                        controller: _username,
                                        textInputAction: TextInputAction.next,
                                        textInputType: TextInputType.visiblePassword,
                                        onFinish: (val) {
                                          _systemNameNode.requestFocus();
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: PasswordInputField(
                                        inputHint: "Enter systemName",
                                        validator: (String? text) {
                                          if(text?.trim().isEmpty ?? true){
                                            return "Please enter systemName";
                                          }
                                          return null;
                                        },
                                        focusNode: _systemNameNode,
                                        controller: _systemName,
                                        textInputAction: TextInputAction.next,
                                        textInputType: TextInputType.visiblePassword,
                                        onFinish: (val) {
                                          _newPasswordNode.requestFocus();
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: PasswordInputField(
                                        inputHint: "Enter new Password",
                                        validator: (String? text) {
                                          if(text?.trim().isEmpty ?? true){
                                            return "Please enter the new password";
                                          } else if(text?.trim().isEmpty ?? true){
                                            return "Please enter the new password";
                                          } else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(text!.trim())){
                                            return "Please enter minimum 8 characters consisting one uppercase, one lowercase, one number and one special character";
                                          }
                                          return null;
                                        },
                                        focusNode: _newPasswordNode,
                                        controller: _newPassword,
                                        textInputAction: TextInputAction.next,
                                        textInputType: TextInputType.visiblePassword,
                                        isPassword: true,
                                        onFinish: (val) {
                                          _confirmPasswordNode.requestFocus();
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: PasswordInputField(
                                        inputHint: "Confirm Password",
                                        validator: (String? text) {
                                          if (text != _newPassword.text) {
                                            return "Both passwords don't match";
                                          } else if(text?.trim().isEmpty ?? true){
                                            return "Please enter the new password";
                                          }
                                          return null;
                                        },
                                        focusNode: _confirmPasswordNode,
                                        controller: _confirmPassword,
                                        textInputAction: TextInputAction.done,
                                        textInputType: TextInputType.visiblePassword,
                                        isPassword: true,
                                        onFinish: (val) {}),
                                  ),
                                ),
                                UIHelper.verticalSpace(Sizes.dimen_8.h),

                                Button(
                                  isIpad: !(constraints.maxWidth < 600),
                                  text: 'Submit',
                                  onPressed: () {
                                    if(_formKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      context.read<ResetPasswordCubit>().startResetPassword(username: _username.text.trim(), newPassword: _newPassword.text.trim(),systemName: _systemName.text.trim(),awssession: widget.argument.awssession,challenge: widget.argument.challenge);
                                    }else {
                                      if(_username.text.trim().isEmpty && _newPassword.text.trim().isEmpty && _confirmPassword.text.trim().isEmpty && _systemName.text.trim().isEmpty) {
                                        FlashHelper.showToastMessage(context, message: 'Please, enter username,systemName and new password', type: ToastType.warning);
                                      }else if(_username.text.trim().isEmpty) {
                                        FlashHelper.showToastMessage(context, message: 'Please, enter username', type: ToastType.warning);
                                      }else if(_newPassword.text.trim().isEmpty) {
                                        FlashHelper.showToastMessage(context, message: 'Please, enter new password', type: ToastType.warning);
                                      }else if(_confirmPassword.text.trim().isEmpty) {
                                        FlashHelper.showToastMessage(context, message: 'Please, re-enter the password', type: ToastType.warning);
                                      }else if(_systemName.text.trim().isEmpty){
                                        FlashHelper.showToastMessage(context, message: 'Please, enter systemName', type: ToastType.warning);
                                      }
                                    }
                                  },
                                ),
                                BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                                  buildWhen: (previous, current) => current is ResetPasswordInitial,
                                  builder: (context, state) {
                                    return const SizedBox.shrink();
                                  },
                                  listenWhen: (previous, current) => current is ResetPasswordSuccess || current is ResetPasswordError || current is ResetPasswordFailed,
                                  listener: (context, state) {
                                    if (state is ResetPasswordError){
                                      WidgetsBinding.instance.addPostFrameCallback((_){
                                        FlashHelper.showToastMessage(context, message: "Please, enter valid password", type: ToastType.warning);
                                      });
                                    }else if(state is ResetPasswordFailed) {
                                      WidgetsBinding.instance.addPostFrameCallback((_){
                                        FlashHelper.showToastMessage(context, message: "Reset Password Failed", type: ToastType.error);
                                      });
                                    }else if(state is ResetPasswordSuccess) {
                                      getItInstance<GetUserPreference>().call(NoParams()).then((eitherPref) {
                                        bool isDark = false;
                                        eitherPref.fold((l) {

                                        }, (pref) {
                                          isDark = pref.darkMode ?? true;
                                        });
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                          RouteList.login,
                                          arguments: LoginArgument(isDark: isDark),
                                              (route) => false,
                                        );
                                      });
                                    }

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }),
    );
  }
}
