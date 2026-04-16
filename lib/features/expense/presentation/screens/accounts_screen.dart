import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page_header.dart';
import 'accounts/tools_tab_widgets.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppPageHeader(
            eyebrow: 'Tools',
            title: 'Financial Utilities',
            bottom: const ToolsTabBar(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              child: const ToolsTabView(),
            ),
          ),
        ],
      ),
    );
  }
}
