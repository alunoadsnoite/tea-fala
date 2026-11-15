import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tea_fala/data/repositories/custom_audio_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'deletes legacy and orphaned recordings while preserving other files',
    () async {
      final directory = await Directory.systemTemp.createTemp('tea_fala_test');
      addTearDown(() => directory.delete(recursive: true));
      final linked = await File('${directory.path}/tea_fala_123.m4a').create();
      final orphan = await File('${directory.path}/tea_fala_456.m4a').create();
      final unrelated = await File('${directory.path}/other.m4a').create();
      final externalLink = await Link('${directory.path}/tea_fala_789.m4a')
          .create(unrelated.path);
      SharedPreferences.setMockInitialValues({
        'custom_audio_paths': '{"fome":"${linked.path}"}',
        'other_preference': true,
      });

      const channel = MethodChannel('plugins.flutter.io/path_provider');
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'getApplicationDocumentsDirectory');
        return directory.path;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      final repository = CustomAudioRepository.instance;
      expect(await repository.get('fome'), linked.path);
      await repository.deleteLegacyRecordings();
      await repository.deleteLegacyRecordings();

      expect(await linked.exists(), isFalse);
      expect(await orphan.exists(), isFalse);
      expect(await unrelated.exists(), isTrue);
      expect(await externalLink.exists(), isTrue);
      expect(await repository.get('fome'), isNull);
      expect(
        (await SharedPreferences.getInstance()).getBool('other_preference'),
        isTrue,
      );
    },
  );
}
