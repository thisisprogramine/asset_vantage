
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constants/size_constants.dart';
import '../../../injector.dart';
import '../../blocs/authentication/forgot_password/forgot_password_cubit.dart';
import '../../blocs/timer/countdown_timer_cubit.dart';
import '../../widgets/av_app_bar.dart';
import 'forgot_password_counter.dart';
import 'forgot_password_label.dart';
import 'forgot_password_input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _forgotPasswordEditingController;
  late FocusNode _forgotPasswordFocusNode;
  late TimerCubit timerCubit;
  late ForgotPasswordCubit forgotPasswordCubit;

  @override
  void initState() {
    super.initState();
    _forgotPasswordEditingController = TextEditingController();
    _forgotPasswordFocusNode = FocusNode();

    timerCubit = getItInstance<TimerCubit>();
    forgotPasswordCubit = getItInstance<ForgotPasswordCubit>();

    _listenOtp();
  }

  @override
  void dispose() {
    super.dispose();
    _forgotPasswordEditingController.dispose();
    _forgotPasswordFocusNode.dispose();

    forgotPasswordCubit.close();
    timerCubit.closeTimer();
    timerCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => forgotPasswordCubit,
        ),
        BlocProvider(
          create: (context) => timerCubit,
        )
      ],
      child: Scaffold(
        appBar: AVAppBar(
          title: 'Forgot Password',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_20.h, horizontal: Sizes.dimen_20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ForgetPasswordLabel(),
                ForgotPasswordInputField(
                  inputHint: "Enter email address",
                  controller: _forgotPasswordEditingController,
                  focusNode: _forgotPasswordFocusNode,
                  textInputAction: TextInputAction.done,
                  validator: (String? text){

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listenOtp() async {
  }
}
