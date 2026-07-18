import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_app/shared/widgets/confirm_dialog.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              await ConfirmDialog.show(
                context: context,
                title: 'Delete Item',
                message: 'Are you sure?',
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );
  }

  group('ConfirmDialog', () {
    testWidgets('shows title and message', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Item'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
    });

    testWidgets('shows cancel and delete buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('cancel returns false', (tester) async {
      bool? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                result = await ConfirmDialog.show(
                  context: context,
                  title: 'Test',
                  message: 'Test message',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('confirm returns true', (tester) async {
      bool? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                result = await ConfirmDialog.show(
                  context: context,
                  title: 'Test',
                  message: 'Test message',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('custom labels work', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                await ConfirmDialog.show(
                  context: context,
                  title: 'Remove',
                  message: 'Confirm removal',
                  confirmLabel: 'Remove',
                  cancelLabel: 'Keep',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Remove'), findsWidgets);
      expect(find.text('Keep'), findsOneWidget);
      expect(find.text('Confirm removal'), findsOneWidget);
    });
  });
}
