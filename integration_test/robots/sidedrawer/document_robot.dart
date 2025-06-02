import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../commons/utils.dart';

class DocumentScreenRobot {
  final WidgetTester _tester;
  final _backButton = find.byKey(const ValueKey("back_button"));
  DocumentScreenRobot(this._tester);

  Future<void> searchDocuments() async {
    final searchBar = find.byKey(const ValueKey("doc_search_bar"));
    await tapAndWait(_tester, searchBar, 2);
    _tester.testTextInput.enterText('de');
    await _tester.testTextInput.receiveAction(TextInputAction.done);
    await _tester.pumpAndSettle(const Duration(seconds: 2));
    await tapAndWait(_tester, _backButton, 2);
  }

  Future<void> changeView() async {
    final viewChangeButton = find.byKey(const ValueKey("view_button"));
    final filterButton = find.byKey(const ValueKey('a-z-button'));
    final filterItem = find.byKey(const ValueKey('z-a-item'));
    await tapAndWait(_tester, viewChangeButton, 1);
    await tapAndWait(_tester, filterButton, 1);
    await tapAndWait(_tester, filterItem, 1);
  }

  Future<void> changeEntity() async {
    final entityFilter = find.byKey(const ValueKey("entity-filter"));
    final searchField = find.byType(TextFormField);
    final entityListItem = find.byKey(const ValueKey('entity_list_item'));
    await tapAndWait(_tester, entityFilter, 1);
    await _tester.enterText(searchField, 'adam');
    await _tester.pumpAndSettle(const Duration(seconds: 1));
    await tapAndWait(_tester, entityListItem, 5);
    await tapAndWait(_tester, _backButton, 3);
  }
}
