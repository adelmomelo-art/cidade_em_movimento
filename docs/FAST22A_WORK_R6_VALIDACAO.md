# FAST-22A — WORK/CODEX R6

Data: 12/10/2026. Baseline remota verificada: `fa15589743485be4eb35bec9c8abd7c41f2d6eda`.
Branch esperada para aplicação: `feat/fast-22a-zona1-visual-mestre`.

O ZIP recebido não contém metadados Git. A branch e o working tree do computador do usuário não foram inspecionados diretamente. A comparação foi feita com uma cópia de revisão da `main` remota; o instalador verifica a branch e o HEAD locais antes da aplicação.

## Diagnóstico comprovado

O teste legado `Z1/theme/390.0/installed layout and mouse scroll` passou **antes** de qualquer mudança no código. A falha histórica mencionada no handoff não se reproduziu nesta entrada. Os ajustes responsivos da Cidade Evolutiva já estavam presentes e foram preservados integralmente.

O novo teste de interação reproduziu sobreposição dos marcadores em 390, 800 e 1280 px. Os alinhamentos originais, combinados com a largura e a altura dos marcadores, faziam missões disputarem a mesma área de clique. O log `pins-before.log` contém as falhas, incluindo colisões com a missão especial. Também havia caracteres de estrelas corrompidos na lista de missões.

## Intervenção

- Distribuição de marcadores em duas colunas no celular, largura suficiente para os nomes e mais espaço vertical no cenário.
- Redistribuição dos pontos no desktop e reposicionamento do mentor para evitar a área das missões.
- Estrelas e símbolo especial renderizados como ícones; descrição semântica preserva a contagem real.
- Nome da missão especial visível, além do tratamento de cor e borda.
- Refinamento da arte vetorial: fachada e profundidade da escola, painéis solares, portão, calçadas, sombras, sinalização e trecho cicloviário junto à via.
- Melo com rosto, boné, uniforme refletivo, rádio, cinturão e gesto de acolhimento.
- RepaintBoundary na arte do bairro para isolar a pintura durante a rolagem.

Nenhuma regra de desbloqueio, custo, recompensa, progressão, persistência, conteúdo de missão, rota ou backend foi alterada. Os arquivos de controllers, models, services e data foram conferidos byte a byte contra a entrada. Os testes existentes também foram preservados byte a byte.

## Verificação técnica

Ambiente: Flutter 3.44.4, Dart 3.12.2, Linux. Builds usam as configurações originais do projeto.

| Gate | Resultado |
|---|---|
| Motor e conteúdo preservados | PASS |
| dart format lib test | PASS — 179 arquivos, 0 alterações na conferência final |
| flutter analyze | PASS — 0 issues |
| Cidade Evolutiva | PASS — 3 testes |
| FAST-22A contrato | PASS — 1 teste |
| FAST-22A widget | PASS — 1 teste |
| Novo teste de interação | PASS — 4 testes |
| FAST9 Z1 390 installed, execução isolada | PASS |
| Suíte completa | PASS — 225 testes |
| Responsividade e mouse scroll, FAST9 | PASS — 45 casos em 390/800/1280 px, estados clean/legacy/installed |
| Web release | PASS |
| Android APK release | PASS — APK release gerado (51,6 MB) |
| git diff --check | PASS |
| Whitespace dos arquivos novos | PASS |

O novo teste verifica ausência de sobreposição, áreas de clique de pelo menos 48 px, abertura das seis rotas esperadas, bloqueios e preservação do progresso durante a interação. Não flexibiliza nenhum teste legado.

A instalação do SDK Flutter, SDK Android, NDK e JDK foi realizada somente neste ambiente de trabalho. Caminhos locais gerados por ferramentas (`android/local.properties` e `.flutter-plugins-dependencies`) não fazem parte do payload.

## Arquivos completos da entrega

1. `lib/screens/zone_1_map/zone_1_map_screen.dart`
2. `lib/widgets/zone_1_visual_scene.dart`
3. `lib/widgets/zone_1_art.dart`
4. `test/fast22a_zone1_pin_interaction_test.dart`
5. `docs/FAST22A_WORK_R6_VALIDACAO.md`

`Zone1EvolvingScene`, o sistema visual global e os dois testes originais do FAST-22A permanecem na versão recebida. O manifesto contém hashes de entrada/saída do payload e de 63 arquivos protegidos de motor e conteúdo.

## Homologação

A arte vetorial foi renderizada e inspecionada em 390, 800 e 1280 px. As capturas foram produzidas em widget tests com progresso simulado; não representam o progresso do usuário.

A aceitação visual como modelo mestre e a comparação com o mockup permanecem **PENDENTES da homologação manual no Chrome**. Não há declaração de aprovação visual final nem propagação para outras zonas.

COMMIT = NÃO EXECUTADO.
PUSH = NÃO EXECUTADO.
MERGE = NÃO EXECUTADO.

O pacote inclui aplicação com backup e hashes, execução local dos gates, logs e checklist. O script PowerShell não foi executado neste ambiente Linux.
