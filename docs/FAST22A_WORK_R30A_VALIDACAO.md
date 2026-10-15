# FAST22A WORK R30A — Prefixo do teste

Baseline: main R29 `4f08d2a`. Mesma branch `feat/fast-22a-centro-historico-r30`.

## Falha recebida

G1 analyze do R30 encontrou uma informação `library_prefixes` em `test/fast22a_r30_centro_historico_test.dart:19:51`: o prefixo de importação `oldFlow` não segue lower_case_with_underscores.

## Correção

Renomeado o prefixo para `old_flow` na importação e na chamada `old_flow.DelayedStorage`. Sem mudança de comportamento no teste ou na implementação. Nenhum lint foi desabilitado. Único arquivo de código diferente de R30: o teste acima.

## Validação e aplicação

- Formatação do teste corrigido: PASS local.
- Conferência de todos os prefixos de importação dos arquivos Dart entregues e ausência de `oldFlow`: PASS local.
- Conferência da diferença entre os payloads R30/R30A e hashes: PASS local.
- Execução Flutter completa continua pendente no Windows; não executada neste ambiente.

Pacote completo com backup, todos os gates e aceitação dos hashes do R30 já aplicado. Aplicar sobre a branch R30 atual sem reset/clean. Arte, controladores, regras, progresso, mapa e telas são idênticos ao R30. Só homologar após técnica e visual PASS. Sem commit, push ou merge automático.
