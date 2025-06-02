
import 'dart:io';

import 'package:asset_vantage/src/config/constants/route_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'dart:developer';
import 'package:asset_vantage/src/data/models/insights/messages_model.dart';
import 'package:asset_vantage/src/domain/entities/insights/chat_message_entity.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/blocs/insights/insights_cubit.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/presentation/widgets/av_app_bar.dart';
import 'package:asset_vantage/src/presentation/widgets/circular_progress.dart';
import 'package:asset_vantage/src/utilities/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:scrollable_positioned_list_extended/scrollable_positioned_list_extended.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/app_config.dart';
import '../../../config/constants/size_constants.dart';
import '../../../config/constants/strings_constants.dart';
import '../../../domain/params/no_params.dart';
import '../../../domain/usecases/preferences/get_user_preference.dart';
import '../../../utilities/helper/flash_helper.dart';
import '../../blocs/app_theme/theme_cubit.dart';
import '../../blocs/dashboard_filter/dashboard_filter_cubit.dart';
import '../../blocs/internet_connectivity/internet_connectivity_cubit.dart';
import '../../widgets/contact_support.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _node = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  bool darkMode = true;
  String? authToken;
  String? subId;
  late ChatCubit chatCubit;
  late InternetConnectivityCubit internetConnectivityCubit;
  bool stopButton = false;

  @override
  void initState() {
    chatCubit = getItInstance<ChatCubit>();
    internetConnectivityCubit = getItInstance<InternetConnectivityCubit>();
    getItInstance<GetUserPreference>()(NoParams()).then((response) {
      response.fold((l) {}, (userPref) async {
        if (userPref.user?.avInsightsUrl == "N/A" ||
            (userPref.user?.avInsightsUrl?.isEmpty ?? true)) {
          showDialog(
            context: context,
            builder: (context) => SupportDialog(
              description: StringConstants.insightsNotAvailable,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          );
        }
        darkMode = userPref.darkMode ?? true;
        final data = JwtDecoder.decode(userPref.idToken ?? '');
        authToken = userPref.idToken;
        subId = data['sub'];
        if(JwtDecoder.isExpired(authToken ?? "")){
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteList.initial,
                (route) => false,
          );
          FlashHelper.showToastMessage(context, message: 'The token has expired', type: ToastType.info);
        }
        chatCubit
            .startPage(authToken: authToken, subId: subId)
            .then((value) => setState(() {}));
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    chatCubit.endPage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardFilterCubit =
        ModalRoute.of(context)?.settings.arguments as DashboardFilterCubit;
    return AppConfiguration.showInSights
        ? MultiBlocProvider(
            providers: [
              BlocProvider<ChatCubit>.value(value: chatCubit),
              BlocProvider<InternetConnectivityCubit>.value(
                value: internetConnectivityCubit,
              ),
            ],
            child: BlocListener<InternetConnectivityCubit, bool>(
              listener: (context, state) {
                if (state) {
                  getItInstance<GetUserPreference>()(NoParams()).then((response) {
                    response.fold((l) {}, (userPref) async {
                      darkMode = userPref.darkMode ?? true;
                      final data = JwtDecoder.decode(userPref.idToken ?? '');
                      authToken = userPref.idToken;
                      subId = data['sub'];
                      chatCubit
                          .startPage(authToken: authToken, subId: subId)
                          .then((value) => setState(() {}));
                      setState(() {});
                    });
                  });
                }
              },
              listenWhen: (previous, current) => previous != current && current,
              child: Scaffold(
                drawerEnableOpenDragGesture: false,
                backgroundColor: darkMode ? null : Colors.white,
                bottomNavigationBar: Container(
                  padding: MediaQuery.of(context).viewInsets,
                  margin: EdgeInsets.only(
                    right: Sizes.dimen_20.w,
                    left: Sizes.dimen_20.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: context.read<AppThemeCubit>().state?.filter?.iconColor != null
                              ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!))
                              : AppColor.primary,
                          key: const ValueKey('textfield'),
                          onTap: () {
                            Future.delayed(
                              const Duration(milliseconds: 600),
                                  () {
                                _itemScrollController.scrollToMax(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                            );
                          },
                          scrollController: _scrollController,
                          controller: _controller,
                          focusNode: _node,
                          maxLines: 10,
                          minLines: 1,
                          style: Theme.of(context).textTheme.titleLarge,
                          decoration: InputDecoration(
                            hintText: 'Ask AV',
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Sizes.dimen_56),
                              borderSide: BorderSide(
                                width: Sizes.dimen_1.w,
                                color: darkMode
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Sizes.dimen_56),
                              borderSide: BorderSide(
                                width: Sizes.dimen_1.w,
                                color: darkMode
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(Sizes.dimen_56),
                              borderSide: BorderSide(
                                width: Sizes.dimen_1.w,
                                color: darkMode
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: Sizes.dimen_26.w,
                              vertical: Sizes.dimen_6.h,
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      UIHelper.horizontalSpace(Sizes.dimen_8.w),
                      GestureDetector(
                        key: const ValueKey('sendButton'),
                        onTap: () async {
                          if (stopButton) return;
                          if (_controller.text.trim().isEmpty) return;
                          if(JwtDecoder.isExpired(authToken ?? "")){
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              RouteList.initial,
                                  (route) => false,
                            );
                            FlashHelper.showToastMessage(context, message: 'The token has expired', type: ToastType.info);
                          }
                          await chatCubit.sendMessage(
                              entityId: (dashboardFilterCubit
                                  .state.selectedFilter?.id ??
                                  0)
                                  .toString(),
                              entityType: (dashboardFilterCubit
                                  .state.selectedFilter?.type ??
                                  0)
                                  .toString(),
                              question: _controller.text.trim());
                          setState(() {});
                          _controller.text = "";
                          _node.unfocus();
                          Future.delayed(
                            const Duration(milliseconds: 600),
                                () {
                              _itemScrollController.scrollToMax(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: Sizes.dimen_56.w,
                          height: Sizes.dimen_56.h,
                          decoration: BoxDecoration(
                            color: darkMode
                                ? Theme.of(context).primaryColor
                                : const Color(0xFF19ABDC),
                            shape: BoxShape.circle,
                          ),
                          padding: stopButton
                              ? const EdgeInsets.symmetric(
                            vertical: Sizes.dimen_12,
                            horizontal: Sizes.dimen_12,
                          )
                              : const EdgeInsets.only(
                            top: Sizes.dimen_8,
                            right: Sizes.dimen_12,
                            bottom: Sizes.dimen_8,
                            left: Sizes.dimen_6,
                          ),
                          child: SvgPicture.asset(
                            stopButton
                                ? 'assets/svgs/stopbutton.svg'
                                : 'assets/svgs/send_icon.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: Sizes.dimen_12.sp),
                        child: BlocBuilder<ChatCubit, InSightsState>(
                            buildWhen: (previous, current) =>
                                current is ServerConnectedAndFeededInitialChats,
                            builder: (context, state) {
                              if (state is ServerConnectedAndFeededInitialChats) {
                                return StreamBuilder(
                                  stream: chatCubit.chatDataSource?.chatObservable,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data;
                                      return ChatListView(
                                        dashboardFilterCubit: dashboardFilterCubit,
                                        darkMode: darkMode,
                                        data: data,
                                        chatCubit: chatCubit,
                                        itemScrollController: _itemScrollController,
                                        stopButtonExec: (val) {
                                          Future.delayed(
                                            const Duration(milliseconds: 1),
                                            () {
                                              stopButton = val;
                                              setState(() {});
                                            },
                                          );
                                        },
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressWidget(),
                                );
                              }
                            }),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          )
        : Scaffold(
      drawerEnableOpenDragGesture: false,
      body: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'In',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: darkMode
                        ? context
                        .read<AppThemeCubit>()
                        .state
                        ?.dashboard
                        ?.iconColor !=
                        null
                        ? Color(int.parse(context
                        .read<AppThemeCubit>()
                        .state!
                        .dashboard!
                        .iconColor!))
                        : Theme.of(context).cardTheme.color
                        : const Color(0xFF19ABDC)),
              ),
              TextSpan(
                text: "Sights will be available soon...",
                style: Theme.of(context).textTheme.titleMedium
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<int?> _showBottomSheet({required DashboardFilterCubit dashboardFilterCubit}) async {
    return await showModalBottomSheet(
        isDismissible: true,
        elevation: 12.0,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Sizes.dimen_20.sp),
            topLeft: Radius.circular(Sizes.dimen_20.sp),
          ),
        ),
        enableDrag: true,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            builder: (context, scroll) {
              return Container(
                height: ScreenUtil().screenHeight * 0.4,
                padding: EdgeInsets.only(
                  top: Sizes.dimen_4.h,
                  right: Sizes.dimen_20.w,
                  left: Sizes.dimen_20.w,
                ),
                child: Column(
                  children: [
                    Container(
                      height: Sizes.dimen_2.h,
                      width: Sizes.dimen_100.w,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.25),
                          borderRadius:
                              BorderRadius.circular(Sizes.dimen_20.w)),
                    ),
                    UIHelper.verticalSpace(Sizes.dimen_10.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/history.svg',
                          width: Sizes.dimen_10.w,
                          height: Sizes.dimen_10.h,
                          color: darkMode ? null : Colors.black,
                        ),
                        UIHelper.horizontalSpace(Sizes.dimen_12.w),
                        Text(
                          'History',
                          style: TextStyle(
                              fontSize: Sizes.dimen_22.sp,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Expanded(
                        child: StreamBuilder(
                      stream: chatCubit.chatDataSource?.chatObservable,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data
                              ?.where((element) =>
                                  element.payload?.data?.content != null)
                              .toList();
                          return ListView.separated(
                            controller: scroll,
                            separatorBuilder: (context, index) {
                              return UIHelper.verticalSpace(Sizes.dimen_4.h);
                            },
                            padding: EdgeInsets.only(
                                top: Sizes.dimen_8.h, bottom: Sizes.dimen_20.h),
                            itemCount: data?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                key: ValueKey('child$index'),
                                onTap: () {
                                  return Navigator.of(context).pop(snapshot.data
                                      ?.indexWhere((element) =>
                                          element.payload?.data?.messageId ==
                                          data?[index]
                                              .payload
                                              ?.data
                                              ?.messageId));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: Sizes.dimen_4.h),
                                      child: Container(
                                        height: Sizes.dimen_8.w,
                                        width: Sizes.dimen_8.w,
                                        decoration: BoxDecoration(shape: BoxShape.circle,
                                        color: context.read<AppThemeCubit>().state?.filter?.iconColor != null
                                            ? Color(int.parse(context.read<AppThemeCubit>().state!.filter!.iconColor!))
                                            : AppColor.primary,),
                                      ),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data?[index].payload?.data?.content ?? "",
                                            style: TextStyle(
                                              fontSize: Sizes.dimen_18.sp,
                                            ),
                                          ),
                                          Text(dashboardFilterCubit
                                              .state.selectedFilter?.name ?? "",
                                            style: TextStyle(
                                              fontSize: Sizes.dimen_14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _controller.text = data?[index].payload?.data?.content ?? "";
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.refresh, size: Sizes.dimen_24.w)
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )),
                  ],
                ),
              );
            },
          );
        });
  }
}

class ChatListView extends StatefulWidget {
  final DashboardFilterCubit dashboardFilterCubit;
  final List<ChatMsg>? data;
  final ItemScrollController itemScrollController;
  final ChatCubit chatCubit;
  final bool darkMode;
  final void Function(bool) stopButtonExec;
  const ChatListView(
      {super.key,
      required this.dashboardFilterCubit,
      required this.itemScrollController,
      this.data,
      required this.stopButtonExec,
      required this.chatCubit,
      required this.darkMode});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool first = true;
  late String _profilePic;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _profilePic = buildProfilePic();
    return ScrollablePositionedList.builder(
      physics: const BouncingScrollPhysics(),
      itemScrollController: widget.itemScrollController,
      itemCount: (widget.data?.length ?? 0) + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(
              right: Sizes.dimen_16.w,
              left: Sizes.dimen_16.w,
              bottom: Sizes.dimen_6.h,
            ),
            color: widget.darkMode ? Theme.of(context).cardTheme.color : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Sizes.dimen_2.h),
                  child: SvgPicture.asset(
                    'assets/svgs/chat_av_icon.svg',
                    width: Sizes.dimen_9.w,
                    height: Sizes.dimen_9.h,
                  ),
                ),
                UIHelper.horizontalSpace(Sizes.dimen_10.w),
                Flexible(
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome to InSights powered by ",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              TextSpan(
                                text:
                                "Asset Vantage",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ". Here are some interesting things you might want to know today.",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w, vertical: Sizes.dimen_4.h),
                                width: Sizes.dimen_10,
                                height: Sizes.dimen_10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).iconTheme.color
                                ),
                              ),
                              Expanded(
                                child: Text('What is my Net Worth?',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w, vertical: Sizes.dimen_4.h),
                                width: Sizes.dimen_10,
                                height: Sizes.dimen_10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).iconTheme.color
                                ),
                              ),
                              Expanded(
                                child: Text('What is the change in Net Worth for past 6 months?',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_2.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: Sizes.dimen_12.w, vertical: Sizes.dimen_4.h),
                                width: Sizes.dimen_10,
                                height: Sizes.dimen_10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).iconTheme.color
                                ),
                              ),
                              Expanded(
                                child: Text('What is the expected cash flow projection for fixed income portfolio over next 6 months?',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'What would you like to know about',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              TextSpan(text: ' ${widget.dashboardFilterCubit.state.selectedFilter?.name}\'s ',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: 'Portfolio?',
                                style: Theme.of(context).textTheme.titleLarge,
                              )
                            ],
                          ),
                        ),

                      ],
                    )
                )
              ],
            ),
          );
        } else if (index == (widget.data?.length ?? 0) + 1) {
          return StreamBuilder(
            stream: widget.chatCubit.chatDataSource?.waitObservable,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                widget.stopButtonExec(snapshot.data ?? false);
              }
              if (snapshot.hasData && (snapshot.data ?? false)) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.dimen_16.w, vertical: Sizes.dimen_4.h),
                  color: Theme.of(context).cardTheme.color,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/chat_av_icon.svg',
                        width: Sizes.dimen_9.w,
                        height: Sizes.dimen_9.h,
                      ),
                      UIHelper.horizontalSpace(Sizes.dimen_10.w),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                            stream: widget
                                .chatCubit.chatDataSource?.currentChatNotifier,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data?.typ ==
                                      MsgVariant.notification) {
                                return Text(
                                  "${snapshot.data?.payload?.output?.message}...",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: widget.darkMode
                                            ? null
                                            : const Color(0xFF8E8E8E),
                                      ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          UIHelper.verticalSpaceSmall,
                          Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.1)
                                : const Color(0xFF8E8E8E).withOpacity(0.2),
                            highlightColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.2)
                                : const Color(0xFF8E8E8E).withOpacity(0.3),
                            period: const Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h),
                              height: Sizes.dimen_6.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColor.lightGrey,
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_60),
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.1)
                                : const Color(0xFF8E8E8E).withOpacity(0.2),
                            highlightColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.2)
                                : const Color(0xFF8E8E8E).withOpacity(0.3),
                            period: const Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h),
                              height: Sizes.dimen_6.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColor.lightGrey,
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_60),
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.1)
                                : const Color(0xFF8E8E8E).withOpacity(0.2),
                            highlightColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.2)
                                : const Color(0xFF8E8E8E).withOpacity(0.3),
                            period: const Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h),
                              height: Sizes.dimen_6.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColor.lightGrey,
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_60),
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.1)
                                : const Color(0xFF8E8E8E).withOpacity(0.2),
                            highlightColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.2)
                                : const Color(0xFF8E8E8E).withOpacity(0.3),
                            period: const Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h),
                              height: Sizes.dimen_6.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColor.lightGrey,
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_60),
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.1)
                                : const Color(0xFF8E8E8E).withOpacity(0.2),
                            highlightColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.2)
                                : const Color(0xFF8E8E8E).withOpacity(0.3),
                            period: const Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h),
                              height: Sizes.dimen_6.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColor.lightGrey,
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_60),
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.1)
                                : const Color(0xFF8E8E8E).withOpacity(0.2),
                            highlightColor: widget.darkMode
                                ? AppColor.white.withOpacity(0.2)
                                : const Color(0xFF8E8E8E).withOpacity(0.3),
                            period: const Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_2.h),
                              height: Sizes.dimen_6.h,
                              width: ScreenUtil().screenWidth * 0.4,
                              decoration: BoxDecoration(
                                color: AppColor.lightGrey,
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_60),
                              ),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        } else {
          final e = widget.data![index - 1];
          return NotificationListener<SizeChangedLayoutNotification>(
            onNotification: (notification) {
              widget.itemScrollController.scrollToMax(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              return true;
            },
            child: SizeChangedLayoutNotifier(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.dimen_16.w, vertical: Sizes.dimen_4.h),
                color: e.payload?.data?.content == null
                    ? widget.darkMode
                        ? Theme.of(context).cardTheme.color
                        : null
                    : widget.darkMode
                        ? null
                        : const Color(0xFFF4F6F8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Sizes.dimen_2.h),
                      child: e.payload?.data?.content != null
                          ? SvgPicture.string(_profilePic
                        , height: Sizes.dimen_20,width: Sizes.dimen_20.sp,)
                          : SvgPicture.asset(
                              'assets/svgs/chat_av_icon.svg',
                              width: Sizes.dimen_9.w,
                              height: Sizes.dimen_9.h,
                            ),
                    ),
                    UIHelper.horizontalSpace(Sizes.dimen_10.w),
                    Flexible(
                      child: (widget.data ?? []).length - 1 ==
                                  widget.data?.indexOf(e) &&
                              (e.payload?.msgResp?.isNotEmpty ?? false)
                          ? RichText(
                              text: TextSpan(
                              children: e.payload?.msgResp
                                  ?.map((c) => TextSpan(
                                        text: c.text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                color: c.styles?.textColor,
                                                fontWeight: c.styles?.weight
                                                        is FontWeight
                                                    ? c.styles?.weight
                                                    : null,
                                                fontStyle: c.styles?.weight
                                                        is FontStyle
                                                    ? c.styles?.weight
                                                    : null),
                                      ))
                                  .toList(),
                            ))
                          : e.payload?.msgResp?.isNotEmpty ?? false
                              ? RichText(
                                  text: TextSpan(
                                  children: e.payload?.msgResp
                                      ?.map((c) => TextSpan(
                                            text: c.text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                    color: c.styles?.textColor,
                                                    fontWeight: c.styles?.weight
                                                            is FontWeight
                                                        ? c.styles?.weight
                                                        : null,
                                                    fontStyle: c.styles?.weight
                                                            is FontStyle
                                                        ? c.styles?.weight
                                                        : null),
                                          ))
                                      .toList(),
                                ))
                              : Text(
                                  e.payload?.data?.content ?? '',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
  String buildProfilePic() {
    final Color? color = context
        .read<AppThemeCubit>()
        .state
        ?.dashboard
        ?.iconColor !=
        null
        ? Color(int.parse(context
        .read<AppThemeCubit>()
        .state!
        .dashboard!
        .iconColor!))
        : Theme.of(context).iconTheme.color;
    final Color bodyColor = context
        .read<AppThemeCubit>()
        .state?.scaffoldBackground !=
        null
        ? Color(int.parse(context
        .read<AppThemeCubit>()
        .state!.scaffoldBackground!))
        : Theme.of(context).scaffoldBackgroundColor;
    final String colorHex = "#${color?.value.toRadixString(16).substring(2)}";
    final String bodyColorHex = "#${bodyColor.value.toRadixString(16).substring(2)}";
    final String rawSvg = """<svg width="154" height="154" viewBox="0 0 154 154" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="77" cy="77" r="77" fill="$colorHex"/>
<ellipse cx="77" cy="76.9589" rx="65" ry="65.9125" stroke="$bodyColorHex" stroke-width="9.11215"/>
<ellipse cx="76.8481" cy="61.7128" rx="25.3621" ry="25.7182" fill="$bodyColorHex"/>
<path d="M108.741 137.635C108.741 129 129.616 128.057 126.357 120.079C123.099 112.101 128.724 120.498 122.703 114.391C116.681 108.285 109.532 103.441 101.664 100.137C93.7966 96.8319 85.364 95.131 76.8481 95.131C68.3321 95.131 59.8995 96.8319 52.0318 100.137C44.164 103.441 37.0152 108.285 30.9935 114.391C24.9718 120.498 26.8009 107.943 23.542 115.921C20.2831 123.899 25.8201 113.908 25.8201 122.543L68.1916 142.871L108.741 137.635Z" fill="$bodyColorHex"/>
</svg>
""";
    return rawSvg;
  }
}

class TypewriterText extends StatefulWidget {
  final List<String?>? texts;
  final List<TextStyle?>? styles;

  const TypewriterText({
    required this.texts,
    required this.styles,
  });

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<int>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List<AnimationController>.generate(
      widget.texts?.length ?? 0,
      (index) => AnimationController(
        vsync: this,
        duration:
            (Duration(milliseconds: widget.texts?[index]?.length ?? 0) * 40),
      ),
    );

    _animations = _controllers.map((controller) {
      return IntTween(
        begin: 0,
        end: widget.texts?[_controllers.indexOf(controller)]?.length,
      ).animate(controller);
    }).toList();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        _controllers.forEach((element) {
          _controllers[0].forward();
          element.addListener(() {
            setState(() {});
            if (element.isCompleted) {
              final newInd = _controllers.indexOf(element) + 1;
              if (!(newInd > _controllers.length - 1)) {
                _controllers[newInd].forward();
              }
            }
          });
        });
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            children: List.generate(widget.texts?.length ?? 0, (index) {
      final String? displayText =
          widget.texts?[index]?.substring(0, _animations[index].value);
      return TextSpan(
        text: displayText,
        style: widget.styles?[index],
      );
    })));
  }
}
