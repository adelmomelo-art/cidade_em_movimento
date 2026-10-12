# FAST-22A — WORK/CODEX R7

Data: 12/10/2026. Entrada: R6 aplicada e validada tecnicamente pelo usuário. Baseline Git: `fa15589743485be4eb35bec9c8abd7c41f2d6eda`. Branch de aplicação: `feat/fast-22a-zona1-visual-mestre`.

## Resultado

O bairro e o Melo passam a usar assets ilustrados produzidos a partir das referências aprovadas. Os seis marcadores continuam sendo widgets Flutter reais, com disponibilidade, estrelas e rotas vindas do motor. Faixa segura, iluminação escolar e trecho cicloviário são pintados em camadas independentes sobre a imagem-base, conforme as compras reais do jogador.

O cenário base não inclui os três upgrades. ANTES permanece sem eles; AGORA responde aos mesmos IDs de `progress.purchasedUpgrades`. Imagem e infraestrutura usam as mesmas coordenadas e transformação. O Melo é um recorte RGBA separado; sua transparência foi verificada na composição e em teste de pixels.

Em 390 px, a cena mantém a proporção 3:2 e usa marcadores numerados com estrelas. Os nomes completos continuam na lista de missões, tooltip e semântica. Em larguras maiores, os nomes também aparecem nos marcadores. As áreas de clique não se sobrepõem.

## Gates executados

Ambiente: Flutter 3.44.4 / Dart 3.12.2, Linux, SDK Android 36 e JDK 17. Configuração do projeto preservada.

| Gate | Resultado |
|---|---|
| Motor e conteúdo | PASS — 63 arquivos protegidos, bytes preservados |
| Testes existentes | PASS — 82 arquivos preservados, sem flexibilização |
| dart format lib test | PASS |
| flutter analyze | PASS — 0 issues |
| Cidade Evolutiva | PASS — 3 testes |
| FAST-22A contrato | PASS — 1 teste |
| FAST-22A widget | PASS — 1 teste |
| Interação da R6 | PASS — 4 testes, incluindo rotas e bloqueios |
| Assets ilustrados | PASS — 9 testes: bundle, alpha e 8 combinações de upgrades |
| FAST9 Z1 390 installed | PASS — execução isolada |
| Suíte completa final | PASS — 234 testes |
| FAST9 390/800/1280, clean/legacy/installed | PASS — incluído na suíte completa |
| Web release | PASS |
| APK release | PASS — 57,2 MB neste ambiente |
| git diff --check | PASS |
| Renderização visual | Inspecionada em 390/800/1280 px |

Os logs finais estão em `evidencias`. A captura visual temporária não integra a suíte final de 234 testes nem o payload. As imagens de evidência foram renderizadas com progresso simulado e todas as melhorias instaladas.

## Escopo preservado

Nenhuma alteração em recompensas, custos, desbloqueios, progressão, estrelas persistidas, moedas, cidadania, conhecimento, missões, rotas, storage, backend, Faixita ou dashboard. Nenhuma propagação para Zonas 2–6. Nenhum FAST-22B implementado.

Assets gerados com imagegen integrado. Caminhos de produção: `assets/zone_1/bairro_escola_base_r7.png` e `assets/zone_1/melo_mentor_r7.png`. Prompts incluídos em `PROMPTS_ARTE_R7.txt`. A publicação dos assets faz parte de `pubspec.yaml`; não depende de URLs externas durante o jogo.

O pacote inclui os arquivos completos de apresentação, os dois assets, o teste novo, a atualização de documentação, manifesto SHA-256 e aplicação com backup. O script confere a versão da R6 antes de escrever e repete os gates no computador do usuário. Ele foi preparado para PowerShell 5.1; sua execução é verificada no Windows do usuário.

## Estado de homologação

R7 = pronta para homologação manual no Chrome.

A aceitação do acabamento em relação ao mockup, da disposição dos elementos e da experiência no dispositivo depende do usuário. As capturas e testes automatizados não substituem essa homologação.

COMMIT = NÃO EXECUTADO.
PUSH = NÃO EXECUTADO.
MERGE = NÃO EXECUTADO.

Não fechar o FAST-22A nem avançar ao FAST-22B antes da aprovação visual.
