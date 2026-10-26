# R43 — Estado da validação

Data: 18/10/2026. Status: PACOTE CANDIDATO PARA APLICAÇÃO E HOMOLOGAÇÃO.

## Verificações realizadas neste ambiente

- Base local conferida contra os objetos Git do commit R42 3f4f63c: correspondência integral dos fontes recuperados.
- Revisão sintática dos arquivos Dart modificados: sem erro de parsing.
- Os 18 IDs, preços e descrições originais permanecem iguais; há 12 novos IDs únicos, com custos 40/60 por zona.
- As três compras anteriores de Meu Bairro permanecem intactas.
- Catálogo: 30 melhorias oficiais; 33 incluindo Meu Bairro; custo de 2.200 moedas.
- Preservação do campo claimedR43ZoneBonuses em todas as reconstruções de progresso revisada.
- git diff --check: sem erros de whitespace.
- Manifesto e hashes do pacote verificados antes da entrega.

## Não executado / não homologado

Flutter analyze, testes Flutter, builds web/APK e execução visual do aplicativo NÃO foram concluídos neste ambiente. A preparação do Flutter 3.44.4 foi interrompida pela revisão automática de segurança ao tentar acessar o endpoint de metadados da infraestrutura. Nenhuma aprovação de teste ou build é inferida dessa tentativa. A revisão sintática não substitui análise de tipos ou testes Flutter.

O instalador executa esses gates no computador do usuário. O pacote contém testes novos de economia/migração, concorrência de compra, falha de persistência, cancelamento, confirmação, acesso às zonas, saldo insuficiente, opções legadas e viewports. Os testes anteriores afetados foram adaptados para cinco melhorias, adicional de 130 e compra com confirmação.

## Homologação a preencher

```text
ANALYZE = PENDENTE
TESTES R43 = PENDENTE
SUÍTE COMPLETA = PENDENTE
BUILD WEB = PENDENTE
BUILD APK = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE
MIGRAÇÃO DE SAVE R42 = PENDENTE
COMPRA / CANCELAMENTO / SEM DUPLICAÇÃO = PENDENTE
TRANSFORMAÇÃO VISUAL NAS SEIS ZONAS = PENDENTE
```

Em caso de falha, encaminhar o log indicado pelo script. Não realizar commit/push/merge como versão homologada antes dos gates e da aprovação visual.

## Revisão do instalador — R43.1

Corrigidos os hashes das três dependências UTF-8 com BOM: mission.dart, mission_option.dart e mission_result.dart. A normalização agora corresponde a ReadAllText do PowerShell: ignora BOM e normaliza CRLF para LF. Conferidos todos os hashes de arquivos e dependências com as variações LF/CRLF e com/sem BOM. Nenhum código de jogo foi alterado por esta revisão. Gates Flutter e homologação continuam pendentes.
