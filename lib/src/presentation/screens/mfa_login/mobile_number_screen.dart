
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/arguments/mfa_login_argument.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/mfa_login/mfa_login_cubit.dart';
import 'package:asset_vantage/src/presentation/widgets/av_app_bar.dart';
import 'package:asset_vantage/src/utilities/helper/flash_helper.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../config/constants/route_constants.dart';
import '../../../config/constants/size_constants.dart';
import '../../blocs/authentication/login/login_cubit.dart';
import '../../blocs/timer/countdown_timer_cubit.dart';
import 'otp_counter.dart';

class MfaLoginScreen extends StatefulWidget {
  final MfaLoginArgument argument;
  const MfaLoginScreen({super.key,required this.argument});

  @override
  State<MfaLoginScreen> createState() => _MfaLoginScreenState();
}

class _MfaLoginScreenState extends State<MfaLoginScreen> {
  late TextEditingController _controller;
  late MfaLoginArgument argumentData;

  @override
  void initState() {
    argumentData = MfaLoginArgument(username: widget.argument.username, awssession: widget.argument.awssession, challenge: widget.argument.challenge, systemName: widget.argument.systemName, password: widget.argument.password);
    _controller = TextEditingController();
    FlashHelper.showToastMessage(context, message: "OTP sent successfully", type: ToastType.success);
    super.initState();
  }

  @override
  void dispose() {
    context.read<TimerCubit>().closeTimer();
    _controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AVAppBar(
        title: "One Time Password",
        leading: Container(),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: Sizes.dimen_2.h, horizontal: Sizes.dimen_20.w),
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
                    "OTP",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Please enter the OTP sent to your registered mobile number",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            PinCodeTextField(
              appContext: context,
              pastedTextStyle: Theme.of(context).textTheme.titleLarge,
              textStyle: Theme.of(context).textTheme.titleLarge,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              length: 6,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                selectedFillColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
                activeColor: Theme.of(context).appBarTheme.iconTheme?.color,
                inactiveColor: Theme.of(context).appBarTheme.iconTheme?.color,
                selectedColor: Theme.of(context).appBarTheme.iconTheme?.color,
                disabledColor: Theme.of(context).appBarTheme.iconTheme?.color,
                activeFillColor: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                borderWidth: Sizes.dimen_1,
                activeBorderWidth: Sizes.dimen_1,
                inactiveBorderWidth: Sizes.dimen_1,
                selectedBorderWidth: Sizes.dimen_1,
                fieldHeight: (ScreenUtil().screenWidth / 8) + Sizes.dimen_6,
                fieldWidth: ScreenUtil().screenWidth / 8,
              ),
              cursorColor: Theme.of(context).iconTheme.color,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              controller: _controller,
              keyboardType: TextInputType.number,
              onCompleted: (otp) {
                context.read<MfaLoginCubit>().verifyOtp(otp: otp ?? "",username: argumentData.username ?? "",awssession: argumentData.awssession ?? "",challenge: argumentData.challenge??"",systemName: argumentData.systemName??"",password: argumentData.password ?? '');
              },
              onChanged: (value) {

              },
              beforeTextPaste: (text) {
                return true;
              },
            ),
            OtpCounter(
              onPressed: () async {
                context.read<LoginCubit>().initiateLogin(username: widget.argument.username??'', password: widget.argument.password??'', systemName: widget.argument.systemName??"");
              },
            ),
            BlocConsumer<LoginCubit, LoginState>(
              buildWhen: (previous, current) => current is LoginInitial,
              builder: (context, state) {
                return const SizedBox.shrink();
              },
              listenWhen: (previous, current) => current is LoginSuccess || current is LoginError || current is LoginFailed,
              listener: (context, state) {
                if (state is LoginError){
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    FlashHelper.showToastMessage(context, message: "Failed to send new OTP", type: ToastType.error);
                  });
                }else if(state is LoginFailed) {
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    FlashHelper.showToastMessage(context, message: "Failed to send new OTP", type: ToastType.error);
                  });
                }else if(state is LoginSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    FlashHelper.showToastMessage(context, message: "OTP Sent Successfully", type: ToastType.success);
                  });
                  argumentData = MfaLoginArgument(username: argumentData.username, awssession: state.awssession, challenge: argumentData.challenge, systemName: argumentData.systemName, password: argumentData.password);
                  _controller.clear();
                  setState(() {});
                  context.read<TimerCubit>().startTimer(initialTime: 180);
                }
              },
            ),
            BlocConsumer<MfaLoginCubit, MfaLoginState>(
              buildWhen: (previous, current) => current is MfaLoginInitial,
              builder: (context, state) {
                return const SizedBox.shrink();
              },
              listenWhen: (previous, current) => current is MfaLoginSuccess || current is MfaLoginError || current is MfaLoginFailed,
              listener: (context, state) {
                if (state is MfaLoginError){
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    FlashHelper.showToastMessage(context, message: "Please, enter correct OTP", type: ToastType.warning);
                  });
                }else if(state is MfaLoginFailed) {
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    FlashHelper.showToastMessage(context, message: "Multi-factor authentication failed", type: ToastType.error);
                  });
                }else if(state is MfaLoginSuccess) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteList.dashboard,
                        (route) => false,
                  );
                }

              },
            ),
          ],
        )
      ),
    );
  }
}
