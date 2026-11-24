import 'dart:io';

import 'package:tea_fala/core/language/translation_service.dart';
import 'package:tea_fala/core/theme/audio_player_service.dart';
import 'package:tea_fala/core/theme/tts_service.dart';
import 'package:tea_fala/data/models/communication_item.dart';
import 'package:tea_fala/data/repositories/custom_audio_repository.dart';

const essentialPortugueseAudio = {
  'sim': 'audio/essential/sim.wav',
  'nao': 'audio/essential/nao.wav',
  'parar': 'audio/essential/parar.wav',
  'ajuda': 'audio/essential/ajuda.wav',
  'descanso': 'audio/essential/descanso.wav',
  'banheiro': 'audio/essential/banheiro.wav',
};

Future<void> speakCommunicationItem(
  CommunicationItem item,
  TtsService tts,
  TranslationService tr,
) async {
  final player = AudioPlayerService.instance;
  final path = await CustomAudioRepository.instance.get(item.id);

  if (path != null && await File(path).exists() && await player.play(path)) {
    return;
  }

  final asset = tr.languageCode == 'pt'
      ? essentialPortugueseAudio[item.id]
      : null;
  if (asset != null && await player.playAsset(asset)) return;

  await tts.speak(tr.t(item.id));
}
