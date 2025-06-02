import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/domain/params/preference/user_preference_params.dart';
import 'package:asset_vantage/src/domain/usecases/preferences/save_user_preference.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/blocs/user_guide_assets/user_guide_assets_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/models/preferences/user_preference.dart';
import 'button.dart';
import 'circular_progress.dart';

class UserGuideWidget extends StatefulWidget {
  const UserGuideWidget({super.key});

  @override
  State<UserGuideWidget> createState() => _UserGuideWidgetState();
}

class _UserGuideWidgetState extends State<UserGuideWidget> {
  PageController controller = PageController();
  bool isCompleted = false;
  int  currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return BlocBuilder<UserGuideAssetsCubit, UserGuideAssetsState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_24.h),
              child: Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.dimen_12)),
                child: !isCompleted
                    ? Column(
                  children: [
                    Expanded(
                      child: state is UserGuideAssetsLoaded ? Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                                controller: controller,
                                onPageChanged: (int index) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                                itemCount: state.assetsEntity?.assets?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: EdgeInsets.only(top: Sizes.dimen_6.h),
                                    child: Image.asset("${state.assetsEntity?.assets?[index]}"),
                                  );
                                }
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_0.h),
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: state.assetsEntity?.assets?.length ?? 0,
                              effect: WormEffect(
                                dotHeight: Sizes.dimen_6,
                                dotWidth: Sizes.dimen_6,
                                spacing: Sizes.dimen_4,
                                activeDotColor: Colors.blue,
                                dotColor: Colors.grey.shade400,
                              ),
                            ),
                          )
                        ],
                      ) : const CircularProgressWidget(),

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCompleted = true;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w, vertical: Sizes.dimen_6.h),
                              child: Text("Skip", style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold, color: AppColor.grey),)
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(state.assetsEntity?.assets?.length == (currentIndex + 1)) {
                              setState(() {
                                isCompleted = true;
                              });
                            }
                            controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w, vertical: Sizes.dimen_6.h),
                              child: Row(
                                children: [
                                  Text("Next", style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold, color: AppColor.primary),),
                                  UIHelper.horizontalSpace(Sizes.dimen_2.w),
                                  const Icon(Icons.arrow_forward_ios_outlined, size: Sizes.dimen_14, color: AppColor.primary,)
                                ],
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                )
                    : Column(
                        children: [
                          Expanded(
                            child: Image.asset("assets/pngs/user_guide_last.png"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.dimen_8.h, horizontal: Sizes.dimen_16.w),
                            child: Button(
                              text: "Get Started",
                              isIpad: false,
                              onPressed: () async{
                                getItInstance<SaveUserPreference>().call(const UserPreferenceParams(
                                    preference: UserPreference(
                                      isFirstOpen: false,
                                    )));
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }
        );
      }
    );
  }
}
