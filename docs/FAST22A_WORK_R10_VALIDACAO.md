# FAST22A WORK R10 — pontuação dentro do cenário

12/10/2026. Pré-requisito: R9 aplicada, conforme capturas enviadas pelo usuário.

## Alterações

HUD único dentro da imagem, com os mesmos quatro valores reais do jogo: Cidadania, Conhecimento, Moedas e Estrelas. Desktop: canto superior direito. Celular: parte inferior interna, com área reservada para não cobrir os marcadores. Os valores continuam reagindo às notificações do controller, inclusive após comprar uma melhoria. A referência visual não introduz níveis, vidas ou pontos na carteira novos.

Faixas não pintam dentro do corredor da ciclovia, incluindo a ponta arredondada. O limite reserva a largura da faixa vermelha e uma pequena margem. O desenho e os símbolos da ciclovia são idênticos à R9. Três travessias continuam como a mesma melhoria FAIXA_SEGURA, com o mesmo custo.

Caminho Seguro movido para cima da área do cadeirante no desktop. Em 800 px, posição alternativa à esquerda evita colisão com outros marcadores. Em celular, a distribuição compacta foi preservada. Clique e rota permanecem os mesmos.

Melo: posição aprovada pelo usuário, busto, balão e estilos preservados. Iluminação e simulação noturna preservadas. Não houve mudança em regras, missões, custos, compras, moedas, estrelas, progressão ou persistência. Bairro Vivo continua como proposta futura.

## Verificação

- Flutter 3.44.4 / Dart 3.12.2, execução CI.
- dart format: PASS.
- flutter analyze: 0 issues.
- verificações dedicadas: 30 testes PASS.
- suíte completa: 246 testes PASS (242 da R9 + 4 novos).
- FAST9 Z1/theme/390.0/installed isolado: PASS.
- Web release: PASS.
- git diff --check e arquivos novos: PASS.
- 63 arquivos protegidos de motor/conteúdo, 85 arquivos de testes R9 e três assets preservados em bytes.
- Implementação do Melo e métodos de desenho da ciclovia preservados em bytes.
- Novos testes: HUD dentro do mapa e sem cobertura do mentor/marcadores em 390/800/1280, exibição dos dados reais e atualização após compra, área do cadeirante livre em desktop/tablet, pixels da ciclovia idênticos com e sem faixas nos pontos verificados.
- Capturas de cena e comparação de melhorias em 390/800/1280 inspecionadas. Dados das capturas são simulados e incluem reparo/bonificação normal da inicialização do controller.
- APK release: não reexecutado neste ambiente, que não dispõe do SDK Android. O instalador inclui obrigatoriamente esse gate no Windows antes de declarar VALIDACAO TECNICA = PASS.

## Aplicação e homologação

O instalador PowerShell 5.1 confere HEAD fa15589, branch feat/fast-22a-zona1-visual-mestre, hashes dos arquivos da entrada R9 e do payload, arquivos protegidos e assets antes de escrever. Faz backup e log e repete análise, testes e builds Web/APK. Aceita reaplicação se os hashes finais forem idênticos.

Execução PowerShell e homologação visual da R10 pendentes no Windows do usuário. Aprovação registrada: posição do Melo. Conferir pontuação, faixas, cadeira de rodas, ciclovia, iluminação e seis cliques. Nenhum commit, push ou merge foi executado.
