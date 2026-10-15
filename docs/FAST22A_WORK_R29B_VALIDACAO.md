# FAST22A WORK R29B — Contrato visual atualizado

Baseline R28 `36f60bb`. Mesma branch `feat/fast-22a-zona1-identidade-r29`.

## Evidência recebida

R29A passou G1, o teste R11 isolado e G2. A suíte completa G3 terminou com 368 testes passando e uma falha: `fast22a_zone1_visual_contract_test.dart`, teste “FAST-22A R2 integra visual mestre sem alterar o motor”. Resumo recebido sem stack trace.

## Defeito confirmado por inspeção

O teste de contrato R2 ainda exigia a string `Zone1VisualScene` no código da tela. R29 usa `Zone1ArtworkBoard`, portanto a expectativa era incompatível com a implementação aprovada. As demais strings verificadas continuam presentes.

A correção atualiza a expectativa para `Zone1ArtworkBoard` e verifica que a tela abre `Zone1MissionDialog`, que instancia `MissionController(mission: widget.mission)` e chama `widget.player.completeMission`. Mantém verificações de pins, HUD e disponibilidade dos componentes legados. Os testes funcionais do motor continuam no G2 e na suíte completa.

## Escopo

Único arquivo de código diferente do pacote R29A: `test/fast22a_zone1_visual_contract_test.dart`. Nenhuma alteração em arte, implementação, controladores, dados ou progresso. Nenhum skip ou atualização de golden.

Pacote completo, aplicável sobre R29/R29A parcial reconhecido, sem limpar a árvore. O manifesto passa a tratar o teste corrigido como payload, aceitando o hash da baseline e o novo, e continua protegendo todos os demais arquivos fora do escopo.

## Verificações

- Formatação e análise estática do teste corrigido: executadas localmente.
- Conferência das expectativas contra os fontes e integridade do pacote: executadas localmente.
- Execução Flutter local: não realizada pelo bloqueio do SDK já descrito em R29. Não houve tentativa de contornar o bloqueio.
- Gates completos R29B: PENDENTES no Windows.

O contrato visual corrigido roda isolado antes de G1 analyze e também integra G2, para falhar cedo se houver outro problema. G3 executa a suíte completa; G4/G5 fazem builds Web e APK; G6 verifica integridade. Só homologar após técnica e visual PASS. Nenhum commit, push ou merge automático.
