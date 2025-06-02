
import 'package:flutter/material.dart';

import 'tnc_list_item.dart';

class TnCList extends StatelessWidget {
  const TnCList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        TnCListItem(
          title: '1. ACCEPTANCE THE USE OF LOREM IPSUM TERMS AND CONDITIONS',
          description: 'Your access to and use of Lorem Ipsum (the app) is subject exclusively to these Terms and Conditions. You will not use the app for any purpose that is unlawful or prohibited by these Terms and Conditions. By using the app you are fully accepting the terms, conditions and disclaimers contained in this notice. If you do not accept these Terms and Conditions you must immediately stop using the app.',
        ),
        TnCListItem(
          title: '2. CREDIT CARD DETAILS',
          description: 'All Lorem Ipsum purchases are managed by the individual App Stores (Apple, Google Windows) and Lorem Ipsum will never store your credit card information or make it available to any third parties. Any purchasing information provided will be provided directly from you to the respective App Store and you will be subject to their credit card policies.',
        ),
        TnCListItem(
          title: '3. LEGAL ADVICE',
          description: '''The contents of Lorem Ipsum app do not constitute advice and should not be relied upon in making or refraining from making, any decision. All material contained on Lorem Ipsum is provided without any or warranty of any kind. You use the material on Lorem Ipsum at your own discretion''',
        ),
        TnCListItem(
          title: '4. CHANGE OF USE',
          description: 'change these Terms and Conditions at any time, and your continued use of the app following any changes shall be deemed to be your acceptance of such change.',
        ),
        TnCListItem(
          title: '5. LINKS TO THIRD PARTY APPS AND WEBSITES',
          description: 'Lorem Ipsum app may include links to third party apps and websites that are controlled and maintained by others. Any link to other apps and websites is not an endorsement of such and you acknowledge and agree that we are not responsible for the content or availability of any such apps and websites.',
        ),
        TnCListItem(
          title: '6. COPYRIGHT',
          description: 'In accessing the app you agree that you will access the content solely for your personal, non-commercial use. None of the content may be downloaded, copied, reproduced, transmitted, stored, sold or distributed without the prior written consent of the copyright holder. This excludes the downloading, copying and/or printing of pages of the app for personal, non-commercial home use only.',
        ),
        TnCListItem(
          title: '7. LINKS TO AND FROM OTHER APPS AND WEBSITES',
          description: 'Throughout this app you may find links to third party apps. The provision of a link to such an app does not mean that we endorse that app. If you visit any app via a link in this app you do so at your own risk.',
        ),
        TnCListItem(
          title: '8. DISCLAIMERS AND LIMITATION OF LIABILITY',
          description: ' The app is provided on an AS IS and AS AVAILABLE basis without any representation or endorsement made and without warranty of any kind whether express or implied, including but not limited to the implied warranties of satisfactory quality, fitness for a particular purpose, non-infringement, compatibility, security and accuracy.',
        )
      ],
    );
  }
}
