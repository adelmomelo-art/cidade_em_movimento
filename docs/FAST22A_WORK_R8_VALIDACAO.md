# FAST22A WORK R8 — resultado e validação

12/10/2026. Entrada: R7 aplicada e validada no computador do usuário.

## Alterações

Melo em busto e mão aberta, em painel acima do mapa, sem flutuar sobre os telhados. A imagem anterior de corpo inteiro permanece intacta e disponível no bundle.

Três travessias nas aproximações das esquinas. Todas pertencem à mesma melhoria FAIXA_SEGURA; nenhum custo adicional. A terceira foi ajustada na renderização para permanecer na via lateral.

Postes escolares maiores e comparação noturna adicional, com cones de luz e áreas iluminadas na calçada. Antes não tem melhoria; depois reflete as compras reais. Trata-se de simulação visual, sem mudança no motor.

Ciclovia preservada: geometria, cores, separador e símbolos iguais à R7. Base ilustrada preservada.

## Validação

- Flutter 3.44.4 / Dart 3.12.2, Android SDK 36, JDK 17.
- analyze: 0 issues.
- suíte completa: 241 testes PASS (234 da R7 + 7 novos).
- gates dedicados: 25 testes PASS.
- FAST9 Z1/theme/390.0/installed isolado: PASS.
- Web release: PASS.
- APK release: PASS, 57,2 MB neste ambiente.
- git diff --check e arquivos novos: PASS.
- 63 arquivos de motor/conteúdo e 83 arquivos de testes da R7 preservados em bytes.
- base ilustrada e asset Melo R7 preservados por SHA-256.
- renderização inspecionada em 390, 800 e 1280 px. Capturas em evidencias, com progresso simulado e três melhorias instaladas.

Não houve alteração em missões, rotas, persistência, recompensas, moedas, estrelas, desbloqueios ou custos. Não houve propagação para outras zonas.

## Aplicação

O instalador confere HEAD fa15589, branch feat/fast-22a-zona1-visual-mestre, hashes da entrada R7 e arquivos protegidos antes de escrever. Cria backup de cada arquivo afetado e log; então repete os gates. Suporta reaplicação com hashes finais idênticos. A execução PowerShell 5.1 precisa ser validada no Windows do usuário; não foi executada no Linux.

## Homologação

Proposta aprovada; homologação visual da implementação R8 pendente no Chrome do usuário. Conferir agente, três faixas, iluminação diurna/noturna, ciclovia e seis cliques.

Commit, push e merge não executados. FAST22A não encerrado; FAST22B não iniciado.
