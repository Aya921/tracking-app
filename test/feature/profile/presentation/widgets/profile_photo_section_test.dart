import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/core/assets_manager/assets_manger.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/profile_photo_section.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return SizeProvider(
      baseSize: const Size(375, 812),
      height: 812,
      width: 375,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('renders default image when no photoUrl or selectedPhoto provided', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(ProfilePhotoSection(onPickPhoto: () {})),
    );

    final avatar = tester.widget<CircleAvatar>(
      find.byKey(const Key(AppWidgetsKeys.photoAvatar)),
    );

    expect(avatar.backgroundImage, isA<AssetImage>());
    final image = avatar.backgroundImage as AssetImage;
    expect(image.assetName, equals(ImgAssets.defaultUserPhoto));
  });

  testWidgets('renders FileImage when selectedPhoto is provided', (tester) async {
    final fakeFile = File('path/to/fake_image.jpg');

    await tester.pumpWidget(
      makeTestableWidget(
        ProfilePhotoSection(
          selectedPhoto: fakeFile,
          onPickPhoto: () {},
        ),
      ),
    );

    final avatar = tester.widget<CircleAvatar>(
      find.byKey(const Key(AppWidgetsKeys.photoAvatar)),
    );

    expect(avatar.backgroundImage, isA<FileImage>());
  });

  testWidgets('renders NetworkImage when photoUrl is provided', (tester) async {
    const fakeUrl = 'https://example.com/image.jpg';

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        makeTestableWidget(
          const ProfilePhotoSection(
            photoUrl: fakeUrl,
            onPickPhoto: _noop,
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(
        find.byKey(const Key(AppWidgetsKeys.photoAvatar)),
      );

      expect(avatar.backgroundImage, isA<NetworkImage>());
      final image = avatar.backgroundImage as NetworkImage;
      expect(image.url, equals(fakeUrl));
    });
  });

  testWidgets('calls onPickPhoto when icon is tapped', (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      makeTestableWidget(
        ProfilePhotoSection(onPickPhoto: () => pressed = true),
      ),
    );

    final iconButton = find.byKey(const Key(AppWidgetsKeys.photoSelectIcon));
    expect(iconButton, findsOneWidget);

    await tester.tap(iconButton);
    await tester.pump();

    expect(pressed, isTrue);
  });
}

void _noop() {}
