import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/sort_bottom_sheet.dart';
import 'package:inventory_app/features/inventory/providers/filter_providers.dart';

void main() {
  Widget buildTestWidget() {
    return ProviderScope(
      child: const MaterialApp(
        home: Scaffold(
          body: SortBottomSheet(),
        ),
      ),
    );
  }

  group('SortBottomSheet', () {
    testWidgets('renders sort by title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Sort by'), findsOneWidget);
    });

    testWidgets('renders all sort options', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
    });

    testWidgets('shows arrow icon for default sort field', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('tapping sort option updates filter state', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('Name'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(SortBottomSheet)),
      );
      final filter = container.read(filterProvider);
      expect(filter.sortField, equals(SortField.name));
    });
  });
}
