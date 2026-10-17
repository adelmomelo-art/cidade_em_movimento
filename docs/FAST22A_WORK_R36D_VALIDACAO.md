# R36D — Isolamento dos testes técnicos do vídeo R35

## Evidência Windows
R36C avançou pela G2 e chegou à suíte completa com 464 testes aprovados e duas falhas nos testes R35. Execução isolada: três testes R35 aprovados, dois falhos.

1. silent manual controls, replay and disposal: esperava dispose antes do descarte assíncrono do controlador terminar.
2. decode failure keeps the approved scene visible: o simulador emitia PlatformException sem message. video_player 2.11.1 usa e.message! no errorListener (linha 663), causando erro de null em vez do fluxo normal de falha de decodificação.

## Correções limitadas aos testes
- Erro simulado agora contém code e message.
- A plataforma simulada registra quais players concluíram o descarte, após fechar o stream.
- Ao desmontar, os testes avançam frames simulados até receber todas as confirmações, com limite de 50 frames de 20 ms. O teste continua falhando se o descarte não terminar.
- Todos os cinco casos encerram os players antes de restaurar a plataforma global, impedindo interferência entre casos.
- G2 executa o teste R35 antes dos testes R36 e antes da suíte completa, somente quando R35 está aplicada.

Nenhum arquivo de lib/, asset, cenário, Melo, fonte nominal, janela, conteúdo pedagógico, recompensa ou dependência é alterado nesta revisão. A experiência de vídeo permanece pausada. O arquivo de teste R35 só é aplicado quando o pubspec R35 é reconhecido; numa R34 sem vídeo, não é criado nem incluído na formatação. Backup e proteções anteriores preservados, com hashes de antes/depois para o teste corrigido.

## Verificação
Sintaxe/formatação e análise estática: consultar resultado de preparação. Testes Flutter e builds não executados neste ambiente. Gates completos e homologação local continuam necessários; não registrar PASS antes da execução.

VALIDACAO TECNICA = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE

Pacote completo, substitui R36/R36A/R36B/R36C. Sem commit, push ou merge automático.
