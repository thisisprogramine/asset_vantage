//TODO:: A counter with send otp again button with 3 min timer



import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constants/size_constants.dart';
import '../../blocs/timer/countdown_timer_cubit.dart';
import '../../theme/theme_color.dart';

class OtpCounter extends StatelessWidget {
  final Function() onPressed;
  const OtpCounter({
    Key? key,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.dimen_22.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              BlocBuilder<TimerCubit, TimerState>(
                builder: (context, state) {
                  if(state is TimerInitial) {
                    return const SizedBox.shrink();
                  }else if(state is TimerStart) {
                    return Text(state.time,
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  }else if(state is TimerEnd) {
                    return const SizedBox.shrink();
                  }

                  return const SizedBox.shrink();
                },
              ),
              GestureDetector(
                onTap: onPressed,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4.h),
                  child: Text("Send OTP Again?",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColor.secondary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
