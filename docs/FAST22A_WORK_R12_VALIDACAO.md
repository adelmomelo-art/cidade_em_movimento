# FAST22A WORK R12 — composição dentro do quadro principal

12/10/2026. Pré-requisito: R11 aplicada. Referências: image(20261012-200253).png, image(20261012-200709).png e image(20261012-200828).png.

## Alterações

Missões no canto inferior esquerdo, dentro da imagem principal. Mantido o quadro de círculos, setas e estrelas da R11; no desktop/tablet a sequência é horizontal. As melhorias agora são três balões brancos à direita, também dentro do quadro, com estados de compra reais. Não há janela externa ou segunda seção de melhorias.

Quadro de missões limitado a 62% da largura no desktop/tablet; balões de melhorias ocupam 18% no desktop e 20% em larguras intermediárias. Balões ajustam-se ao espaço disponível para não cortar a última melhoria. A distribuição deixa o cadeirante visível. No celular o mesmo quadro principal tem altura adicional e fundo do bairro para conter os controles legíveis, mantendo a cena na parte superior.

A largura do balão de fala do Melo foi reduzida em 50% em relação à R11. Frase curta: Vamos cuidar da escola! O balão está alinhado ao topo para liberar o nome ESCOLA. Busto, pose e asset preservados.

Retirada a faixa lateral junto à árvore/praça que parecia flutuar. Árvore e imagem-base preservadas. Permanecem as duas faixas próximas ao abrigo do ônibus, na mesma melhoria FAIXA_SEGURA e com o mesmo custo. Geometria e símbolos da ciclovia e iluminação preservados.

Pontuação real e medalha Protetor da Escola junto às estrelas preservadas. Não houve alteração em motor, custos, recompensas, desbloqueios, medalhas, persistência, missões ou rotas. Bairro Vivo segue proposta futura.

## Verificação

- Flutter 3.44.4 / Dart 3.12.2, modo CI.
- dart format: PASS.
- flutter analyze: 0 issues.
- verificações dedicadas: 39 testes PASS.
- suíte completa: 255 testes PASS (251 da R11 + 4 novos).
- FAST9 Z1/theme/390.0/installed isolado: PASS.
- Web release: PASS.
- git diff --check e arquivos novos: PASS.
- 63 arquivos protegidos de motor/conteúdo, 86 arquivos de testes anteriores e três assets preservados em bytes.
- Teste de layout da R11 atualizado para a nova exigência: missões dentro do quadro principal. Verificações de medalha real, ausência de prêmio não persistido e progresso preservadas.
- Novos testes: missões e três balões dentro do quadro nas três larguras, separação das áreas interativas/HUD, fala com metade da largura, cadeirante livre em desktop/tablet, compra real por botão com débito e bloqueio de compra duplicada, pintura lateral removida.
- Capturas de cena/evolução em 390/800/1280 inspecionadas. Capturas usam progresso simulado.
- APK release: não reexecutado neste ambiente sem SDK Android. Instalador executa obrigatoriamente esse gate no Windows antes de declarar VALIDACAO TECNICA = PASS.

## Aplicação e homologação

Instalador PowerShell 5.1 verifica HEAD fa15589, branch feat/fast-22a-zona1-visual-mestre, hashes da entrada R11 e do payload, motor, testes e assets antes de escrever. Faz backup e log e repete análise, testes e builds Web/APK.

Execução PowerShell e homologação visual da R12 pendentes no Windows. Conferir proporção dos balões, missões dentro do cenário no canto inferior esquerdo, nome ESCOLA livre, cadeirante visível e árvore preservada sem faixa lateral flutuante. Conferir duas faixas restantes, ciclovia, medalha, seis cliques e compras. Nenhum commit, push ou merge executado.
