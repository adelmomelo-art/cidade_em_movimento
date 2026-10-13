# FAST22A WORK R15 — validação

12/10/2026. Base main R13 1c1739f. Pacote inclui R14 integral e os refinamentos R15. Pode aplicar sobre main R13 sincronizada ou R14 aplicada sem commit, na branch local feat/fast-22a-zona1-missoes-integradas.

## Resultado

Navegação dentro do cenário ao lado dos KPIs na tela larga e em segunda linha no celular estreito. Avanço só quando Zona 2 está liberada. Medalha, missões e melhorias livres de sobreposição. Aviso recomenda horizontal, sem bloquear vertical; pode ser fechado. Cena responsiva, arte original proporcional; pode haver rolagem em telas baixas para preservar legibilidade e toque.

Melo em 152x144 px nas perguntas/orientações/resultados (dobro de 76x72). Enunciado amarelo suave, texto azul-escuro, alternativas brancas. Fluxo inteiro na mesma janela. Voz registrada somente como melhoria futura.

## Verificação

- Flutter 3.44.4 / Dart 3.12.2 em modo CI.
- Formatação PASS; flutter analyze: 0 issues.
- 56 testes dedicados PASS.
- Suíte completa: 272 testes PASS (266 da R14 + 6 novos).
- FAST9 390 installed isolado: PASS.
- Build Web release: PASS.
- git diff --check e arquivos novos: PASS.
- Capturas de bairro, pergunta, orientação, resultado e noite em 390x844, 844x390 e 1280x900 inspecionadas, com dados simulados.
- Novos testes: navegação descendente do cenário, separada dos KPIs/medalha/missões/melhorias, toque mínimo 48 px, dia/noite sem alteração de progresso, rotas de progresso/avanço, avanço oculto quando bloqueado, retorno ao mapa de Fortaleza, aviso vertical dispensável, missão acessível nas duas orientações, Melo exatamente duplicado, rotação durante a pergunta sem reiniciar a etapa, cor amarela do enunciado e conclusão real.
- Testes anteriores de seis missões nos três perfis, salvamento/retry/cancelamento, medalha, idempotência, compras, persistência e fonte ampliada mantidos.
- Motor, conteúdo, custos, regras, persistência e quatro assets preservados.
- APK release e PowerShell 5.1 não executados neste ambiente sem SDK Android/PowerShell. Instalador exige APK no Windows antes de PASS.

## Aplicação e homologação

Guarda backup, APK anterior e log. Verifica HEAD 1c1739f, hashes do payload e variantes aprovadas R13/R14 antes de escrever; aceita apenas diferença de CRLF/LF em conteúdo protegido. Cria branch local ao iniciar na main, executa gates e confere hashes depois. Sem commit, push ou merge.

Homologação R15 Web/celular pendente: conferir controles internos, medalha, quatro KPIs, modo noite, avanço bloqueado/liberado, vertical sem bloqueio, horizontal, pergunta amarela, Melo maior e fluxo até retornar ao bairro. Reinstalar APK novo para testar. R13 PASS anterior não substitui esta homologação.
