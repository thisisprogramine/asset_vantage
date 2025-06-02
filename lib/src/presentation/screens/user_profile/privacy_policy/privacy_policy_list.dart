
import 'package:flutter/material.dart';

import 'privacy_policy_list_item.dart';


class PrivacyPolicyList extends StatelessWidget {
  const PrivacyPolicyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        PrivacyPolicyListItem(
          title: '1. WE WILL USE THIS INFORMATION IN ORDER TO:',
          description: 'Provide users with our Services and customer support including, but not limited to, confirming emails related to our services, reminders, confirmations, requests for information and transactions.',
        ),
        PrivacyPolicyListItem(
          title: '2. ADDITIONALLY, WE MAY USE THE INFORMATION WE COLLECT ABOUT YOU TO:',
          description: 'Send you communications we think will be of interest to you, including information about products, services, promotions, news, and events of Lorem Ipsum and other affiliated or sponsoring companies with whom we have established a relationship.',
        ),
        PrivacyPolicyListItem(
          title: '3. INTERNATIONAL PRIVACY POLICIES',
          description: 'In order to provide our products and services to you, we may send and store your personal information outside of the country where you reside or are located, including to the United States. Accordingly, if you reside or are located outside of the United States, your personal information may be transferred outside of the country where you reside or are located, including countries that may not, or do not, provide the same level of protection for your personal information. We are committed to protecting the privacy and confidentiality of personal information when it is transferred. If you reside or are located within the European Economic Area and such transfers occur, we take appropriate steps to provide the same level of protection for the processing carried out in any such countries as you would have within the European Economic Area to the extent feasible under applicable law. By using and accessing our products and services, users who reside or are located in countries outside of the United States agree and consent to the transfer to and processing of personal information on servers located outside of the country where they reside, and assume the risk that the protection of such information may be different and may be less protective than those required under the laws of their residence or location.',
        ),
        PrivacyPolicyListItem(
          title: '4. ACCOUNT INFORMATION',
          description: 'You may correct your account information at any time by logging into your online account. If you wish to cancel your account, please email us at legal@wasai.co Please note that in some cases we may retain certain information about you as required by law, or for legitimate business purposes to the extent permitted by law.',
        ),
        PrivacyPolicyListItem(
          title: '5. PROMOTIONAL INFORMATION OPT OUT',
          description: 'You may opt out of receiving our newsletters or any other promotional messages from us at any time by following the instructions in those messages sent to you and the link provided therein, or by contacting us at any time using the Contact Us information at the end of this Privacy Policy. If you opt out, we may still send you non-promotional communications, such as those about your account, about Services you have requested, or our ongoing business relations.',
        ),
        PrivacyPolicyListItem(
          title: '6. OUR INFORMATION RETENTION POLICY',
          description: 'Unless you request that we delete certain information, we retain the information we collect for as long as your account is active or as needed to provide you services. Following termination or deactivation of your account, we will retain information for at least 3 years and may retain the information for as long as needed for our business and legal purposes. We will only retain your Personal Data for so long as we reasonably need to unless a longer retention period is required by law (for example for regulatory purposes).',
        ),
        PrivacyPolicyListItem(
          title: '',
          description: '',
        ),
        PrivacyPolicyListItem(
          title: '',
          description: '',
        ),
      ],
    );
  }
}
