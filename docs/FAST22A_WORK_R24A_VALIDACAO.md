# R24A — correção do encerramento dos testes

Diagnóstico do log tela_inicial_R24_e_golden.log recebido em 14/10/2026:
11 falhas iguais: “A SemanticsHandle was active at the end of the test”.
Uma no widget_test e dez nas combinações de viewport/perfil da R24.
Nenhuma asserção de imagem, geometria, navegação ou progresso falhou no log.
Comparação nativa pixel a pixel, teclado e FAST21 concluíram sem falha (3 testes).
Isso não fecha a homologação visual do aplicativo nem os builds pendentes.

Causa: tester.ensureSemantics() criava um handle extra; addTearDown o liberava
somente depois da verificação de invariantes do binding. A correção remove esse
handle manual e usa semanticsEnabled: true nos testWidgets relevantes. O Flutter
ativa e libera a semântica automaticamente antes de _endOfTestVerifications.
Confirmado no código do SDK usado: flutter_test/src/widget_tester.dart e binding.dart.
Acessibilidade continua verificada; não remove asserções nem desativa o teste.

Somente test/widget_test.dart e test/fast22a_r24_home_mockup_test.dart mudam.
HomeScreen, PNG, pubspec e os 220 arquivos protegidos permanecem iguais à R24.
Mantém o golden sem atualização automática, capturas, navegação, teclado,
progresso, análise, suíte completa e builds Web/APK.

Verificação local: fonte do SDK, formatação/sintaxe, hashes e pacote.
Execução Flutter R24A, analyze, testes/golden, builds e homologação: PENDENTES
no Windows; dependências pub indisponíveis neste ambiente. Não declarar PASS
antes de completar todos os gates. Não há commit, push ou merge automático.

Aplicar sobre R24 interrompida, ou main R23 limpa, usando o script completo.
A branch continua feat/fast-22a-tela-inicial-r24 e HEAD 3f2e327.
Depois de VALIDACAO TECNICA = PASS, conferir novo APK/Chrome/A05 e capturas
em build/fast22a_r24_evidencias; aprovar arte inteira e quatro ações corretas.
