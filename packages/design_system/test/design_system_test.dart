import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_system/design_system.dart';

void main() {
  testWidgets('AppScaffold and PrimaryButton render correctly', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: AppScaffold(
          title: 'تست عنوان',
          body: PrimaryButton(
            text: 'دکمه اصلی',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('تست عنوان'), findsOneWidget);
    expect(find.text('دکمه اصلی'), findsOneWidget);

    await tester.tap(find.text('دکمه اصلی'));
    await tester.pump();
    expect(pressed, isTrue);
  });

  testWidgets('ContactTile and InfoBanner render correctly', (tester) async {
    bool isChecked = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Column(
            children: [
              ContactTile(
                displayName: 'علی رضایی',
                phoneNumber: '+989121111111',
                isSelected: isChecked,
                badgeText: 'جدید',
                onSelectedChanged: (val) {
                  isChecked = val ?? false;
                },
              ),
              const InfoBanner(
                message: 'پیام تست هشدار',
                type: BannerType.warning,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('علی رضایی'), findsOneWidget);
    expect(find.text('+989121111111'), findsOneWidget);
    expect(find.text('جدید'), findsOneWidget);
    expect(find.text('پیام تست هشدار'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(isChecked, isTrue);
  });
}
