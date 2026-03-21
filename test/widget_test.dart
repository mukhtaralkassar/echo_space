// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:echo_space/data/data_sources/local/audio_note_local_data_source.dart';
import 'package:echo_space/data/repositories/audio_note_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:echo_space/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  // We need to ensure Hive is initialized for tests using a mock directory or standard init
  setUpAll(() async {
    await Hive.initFlutter();
  });

  testWidgets('EchoSpace app smoke test', (WidgetTester tester) async {
    // 1. Initialize the required dependencies
    final localDataSource = AudioNoteLocalDataSourceImpl();
    final repository = AudioNoteRepositoryImpl(localDataSource: localDataSource);

    // 2. Build our app and trigger a frame
    await tester.pumpWidget(EchoSpaceApp(repository: repository));

    // Wait for the FutureBuilder/Bloc to settle
    await tester.pumpAndSettle();

    // 3. Verify that the app title is present on the screen
    expect(find.text('EchoSpace'), findsOneWidget);
    
    // Verify that the FloatingActionButton is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}