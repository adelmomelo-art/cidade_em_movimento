# FAST22A WORK R29A — Contenção inclusiva do painel de missões

Baseline: main `36f60bb` (R28). Aplicação permitida sobre main limpa ou branch R29 parcialmente aplicada, ainda no mesmo HEAD.

## Evidência recebida

O usuário executou o pacote R29 no Windows. O gate G1 passou e G2 terminou com 61 testes passando e três falhas, todas no teste R11 “one mission window inside the main frame and earned medal beside stars”, nas larguras 390, 800 e 1280. Foi recebido o resumo das falhas, sem o stack trace da expectativa.

## Defeito confirmado na revisão

O painel de missões R29 ocupa a largura do quadro aprovado. Nas três configurações, sem insets, sua borda direita coincide com a borda direita do mapa. A expectativa antiga `imageRect.contains(panelRect.bottomRight)` retorna falso nessa condição: `Rect.contains` inclui topo/esquerda e exclui direita/base. Essa semântica foi confirmada no fonte local oficial do Flutter, `dart:ui/geometry.dart`.

A correção compara explicitamente as quatro bordas, incluindo a igualdade, com precisão geométrica de 0,01 pixel lógico. Mantém a exigência de que o painel inteiro permaneça dentro do mapa. Verificações dos seis pins, medalha, posição junto às estrelas, ausência de prêmio indevido e persistência continuam ativas.

## Escopo

Único arquivo de código diferente de R29: `test/fast22a_r11_mission_window_test.dart`.
Arte, implementação, regras, motor, pontos e navegação são idênticos aos do pacote R29. Nenhum skip, golden atualizado ou tolerância de pixels de imagem foi introduzido.

## Validação

- Formatação do teste e `git diff --check`: PASS neste ambiente.
- Conferência da diferença R29 → R29A e hashes do pacote: PASS.
- Execução Flutter local: não realizada; permanece o bloqueio de preparação do SDK descrito no documento R29.
- G1 e 61 testes G2 de R29: PASS informado pelo usuário. Teste R11 corrigido, suíte completa e builds R29A: PENDENTES.

O script R29A faz backup, aplica o pacote completo e roda o R11 isolado antes dos demais gates para mostrar rapidamente qualquer erro residual. Se falhar, enviar o bloco completo da primeira `EXCEPTION CAUGHT`, incluindo a linha do teste. Só imprimir PASS técnico após todos os gates; homologação visual continua pendente.
