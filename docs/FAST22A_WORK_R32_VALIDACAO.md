# FAST22A R32 — Validação

## Preparação executada
- Formatação Dart dos seis arquivos: PASS.
- Análise estática dos três arquivos de implementação com SDK/fontes locais e regras flutter_lints/lints: PASS, sem apontamentos.
- git diff --check, geometria dos seis alvos, limites dos recortes, integridade PNG e proteção de escopo: PASS.

## Gates completos no Windows — PENDENTES
Este ambiente não possui Flutter operacional e dependências de testes disponíveis. Flutter analyze completo, testes widget/regressões e builds Web/APK não foram executados aqui. O instalador só imprime VALIDACAO TECNICA = PASS depois de todos os gates passarem.

G1: pub get, format, analyze. G2: tela e compra isoladas; R32 e conteúdo/estrutura/progressão/compras/cenário/persistência existentes; regressões R29/R30/R31, mapa Fortaleza e barcos. G3: suíte completa. G4: Web release. G5: APK release. G6: diff check e hashes dos arquivos protegidos/payload.

## Homologação visual — PENDENTE
Chrome, A05 horizontal e tablet. Conferir mapa completo sem rolagem/cortes; seis pontos, Melo, avatar de cada perfil e HUD; seleção, confirmação, resposta errada, cancelamento, tentativa novamente, resultado, recarregamento sem perda nem prêmio duplicado; noite; progresso; três melhorias e compra persistente; bloqueios/especial/medalha/avanço à Zona 5; voltar ao mapa de Fortaleza. Perguntas e Melo devem caber com texto ampliado; rotação preserva seleção.

Capturas: build/fast22a_r32_evidencias. Guardar logs do backup. Fechar no Git somente após técnica e visual PASS. Nenhum commit, push ou merge executado na preparação.
