import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hbb/desktop/widgets/tekniq_customer_panel.dart';

void main() {
  testWidgets('code, consent and active help reuse the same page',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(560, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var accepted = 0;
    var rejected = 0;
    var stopped = 0;
    Future<void> render(
        {bool pending = false, bool active = false, String? error}) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: TekniqCustomerPanel(
        id: '185 359 637',
        ready: error == null,
        awaitingApproval: pending,
        active: active,
        error: error,
        onAccept: () => accepted++,
        onReject: () => rejected++,
        onStop: () => stopped++,
      ))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(TekniqCustomerPanel), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
    }

    await render();
    expect(find.text('185 359 637'), findsOneWidget);
    await render(pending: true);
    await tester.tap(find.text('Hulp toestaan'));
    expect(accepted, 1);
    expect(stopped, 0);
    await render(active: true);
    expect(find.text('Tekniq helpt nu mee'), findsOneWidget);
    await tester.tap(find.text('Hulp beëindigen'));
    expect(stopped, 1);
    await render();
    await render(pending: true);
    await tester.tap(find.text('Niet toestaan'));
    expect(rejected, 1);
    expect(accepted, 1);
    await render();
    expect(find.text('185 359 637'), findsOneWidget);
  });

  testWidgets('listener failure is visible instead of claiming readiness',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: TekniqCustomerPanel(
      id: '185 359 637',
      ready: false,
      awaitingApproval: false,
      active: false,
      error: 'De hulpverbinding kon niet starten.',
      onAccept: () => fail('Must not accept'),
      onReject: () {},
      onStop: () {},
    ))));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('connection-error')), findsOneWidget);
    expect(find.text('Klaar voor verbinding'), findsNothing);
    expect(find.text('Hulp toestaan'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
