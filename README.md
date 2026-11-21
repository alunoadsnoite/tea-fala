# TEA Fala

**Comunicação aumentativa e alternativa em um quadro simples e offline.**

`Flutter · Dart · Android`

[Reportar problema](https://github.com/alunoadsnoite/tea-fala/issues) · [Licença](LICENSE)

<img src="fastlane/metadata/android/pt-BR/images/icon.png" alt="Ícone do TEA Fala" width="104">

TEA Fala - Quadro de Comunicação Offline para o público TEA

Um aplicativo Flutter, Dart e Kotlin para auxiliar pessoas com TEA (Transtorno do Espectro Autista) na comunicação aumentativa e alternativa (CAA), sem conta e sem rastreamento. O quadro funciona offline.

## Funcionalidades

- **Quadro de comunicação**: 54 ícones organizados em 5 categorias (Necessidades, Pessoas, Emoções, Lugares, Ações)
- **Síntese de fala (TTS)**: fala em português do Brasil, inglês ou espanhol, velocidade reduzida para melhor compreensão
- **Frase completa**: monta frases tocando ícones e lê tudo junto
- **Texto livre**: digite qualquer texto e ouça em voz alta
- **Configurações**: tema claro/escuro/automático, idiomas (Português/Inglês/Espanhol)
- **Modo somente imagens**: exibe apenas ícones, sem textos
- **Contato com desenvolvedor**: envie e-mail diretamente pelo app

## Privacidade

- O quadro funciona sem internet. Ao usar a voz sintetizada, o texto é entregue ao serviço de voz do Android. O funcionamento offline depende da voz instalada no aparelho e do serviço selecionado.
- O aplicativo guarda preferências e pode reproduzir áudios gravados por versões anteriores. A versão atual não usa o microfone. Em **Configurações**, você pode apagar essas gravações locais.
- O app solicita ao Android que exclua seus dados de backups automáticos e transferências entre aparelhos. Excluir gravações locais não apaga cópias feitas anteriormente.
- Falar com o desenvolvedor abre o aplicativo de e-mail. Você escolhe o que escrever e se quer enviar. Evite incluir diagnósticos, gravações ou dados de crianças.
- O app não exige conta e não usa publicidade nem rastreamento.

## Tecnologia

- Flutter 3.47.9
- Dart 3.13.7
- Android

## Pacote

`br.com.valdenor.teafala`

## Desenvolver e testar

Use a versão de Flutter indicada acima, com Android SDK e Java configurados.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
```

O APK local fica em `build/app/outputs/flutter-apk/app-release.apk`. A assinatura usada na distribuição precisa ser mantida para permitir atualizações da mesma instalação.

## Licença

Consulte a [GNU General Public License v3.0](LICENSE).

## Desenvolvedor

Valdenor — valdenor.sa@proton.me

## Como contribuir

Sugestões, traduções e relatos de problemas são bem-vindos. Abra uma issue com o contexto e o comportamento esperado. Para alterações de código, explique a mudança e os testes realizados no pull request. Use dados fictícios nos exemplos e nas capturas.
