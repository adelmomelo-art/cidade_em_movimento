# FAST22A WORK R11 — cenário e janela única de missões

12/10/2026. Pré-requisito: R10 aplicada. Referências fornecidas: image(20261012-185105).png e image(20261012-191118).png.

## Alterações

Desktop: cenário à esquerda e quadro único das seis missões à direita. Tablet: quadro horizontal abaixo do cenário, próximo à referência. Celular: quadro vertical abaixo para manter legibilidade e áreas de clique.

Foram removidos os marcadores sobrepostos à imagem e a lista duplicada anterior. O quadro usa azul escuro, círculos claros, setas de progressão e estrelas amarelas. Estados bloqueados seguem cinza e com cadeado. Estrelas, disponibilidade e rotas seguem o controller. Não houve mudança nos nomes ou no conteúdo das missões.

A medalha Protetor da Escola aparece dentro do desenho, junto ao total de estrelas no HUD, quando progress.medals contém PROTETOR_DA_ESCOLA, o ID oficial já definido no motor. Tooltip e semântica identificam o prêmio. A tela não concede nem persiste medalhas.

Melo e balão, pontuação real, base ilustrada, faixas, ciclovia, iluminação e simulação noturna preservados. Nenhuma alteração em motor, regras, custos, recompensas, persistência, estrelas, missões, rotas ou outras zonas. Bairro Vivo permanece proposta futura.

## Verificação

- Flutter 3.44.4 / Dart 3.12.2, execução CI.
- dart format: PASS.
- flutter analyze: 0 issues.
- verificações dedicadas: 35 testes PASS.
- suíte completa: 251 testes PASS (246 da R10 + 5 novos).
- FAST9 Z1/theme/390.0/installed isolado: PASS.
- Web release: PASS.
- git diff --check e arquivos novos: PASS.
- 63 arquivos protegidos de motor/conteúdo e 86 arquivos de testes R10 preservados em bytes.
- Arte completa, incluindo o painter de infraestrutura e os três assets, preservada em bytes. Implementação do Melo e balão preservada.
- Cinco novos testes: janela única fora do cenário em 390/800/1280, medalha conquistada junto às estrelas sem alterar progresso, medalha ausente quando a recompensa não está persistida, inclusive com flag legada de zona concluída.
- Testes anteriores de cliques nas seis rotas, bloqueios, estrelas, HUD e infraestrutura mantidos e aprovados.
- Capturas de cenário e evolução em 390/800/1280 inspecionadas. Capturas usam progresso simulado com medalha já conquistada.
- APK release: não reexecutado neste ambiente, sem SDK Android. Instalador executa esse gate no Windows antes de declarar VALIDACAO TECNICA = PASS.

## Aplicação e homologação

O instalador PowerShell 5.1 confere HEAD fa15589, branch feat/fast-22a-zona1-visual-mestre, hashes da entrada R10 e do payload, motor, testes e assets antes de escrever. Cria backup e log, aplica arquivos completos e repete análise, testes e builds Web/APK.

Execução PowerShell e homologação visual da R11 pendentes no Windows do usuário. Conferir composição à esquerda/direita, painel único, seis cliques, bloqueios, estrelas, medalha ao lado do total, Melo e infraestrutura. Nenhum commit, push ou merge executado.
