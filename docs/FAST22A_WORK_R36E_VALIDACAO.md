# R36E — Descarte entre zona assíncrona real e FakeAsync

## Evidência
R36D falhou na confirmação de descarte: Expected 1, Actual 0, linha 97. Aumentar frames de tempo simulado não resolveu.

Foi criado e executado um programa Dart isolado com StreamController, cancelamento de assinatura e FakeAsync 1.3.3, pré-aquecendo o futuro de cancelamento na zona real, como ocorre no ambiente de testes. Após 50 avanços de 20 ms, o descarte permanecia pendente. Após uma passagem pela fila assíncrona real e flush das microtarefas simuladas, o cancelamento, fechamento do stream e confirmação terminavam. O programa foi compilado e executado com Dart 3.12.2. A reprodução consta em diagnostico/ neste pacote, fora do payload do aplicativo.

Também foi conferida a versão oficial video_player 2.11.1: seus próprios testes de widget usam tester.runAsync(controller.dispose). Apenas avançar o relógio do FakeAsync não libera a fila assíncrona real.

## Correção limitada ao teste
Depois de desmontar o widget, o teste alterna uma passagem real via tester.runAsync/Future.delayed(Duration.zero) e um pump para drenar microtarefas simuladas, até todos os players confirmarem o descarte. Mantém limite de 50 passagens e a mesma exigência de descarte efetivo; não aprova se algum player continuar aberto. Em caso de falha, mostra chamadas, streams fechados e presença de listeners.

Mantidos o erro simulado com mensagem, a cobertura dos cinco casos R35 e a execução desses casos antes da suíte completa. Os arquivos de lib/, cenários, Melo, fontes, janelas e motores são byte a byte os mesmos da R36D. A experiência com vídeo continua pausada.

## Verificação de preparação
- Reprodução do bloqueio e liberação entre as duas zonas assíncronas: PASS em programa Dart executado.
- Sintaxe/formatação do teste: PASS no formatador Dart.
- Integridade dos arquivos e compatibilidade com teste R36D: conferidas.
- Nova análise Flutter, testes de widget, Web/APK e homologação visual: PENDENTES no Windows. A reprodução isolada não equivale ao PASS da suíte Flutter.

VALIDACAO TECNICA = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE

Pacote completo: substitui R36 até R36D, com backup. Sem commit, push ou merge automático.
