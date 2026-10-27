# R44 — Mais opções e Progresso Global, mockups aprovados

Base: main no commit 21afb752d739224423ddff9eabaadaa53d708c69. As duas propostas visuais foram aprovadas pelo usuário em 26/10/2026. Esta implementação ainda é candidata para execução dos gates e homologação dentro do aplicativo.

## Implementação

As duas telas seguem as artes aprovadas: Melo à esquerda, cenário da cidade, cabeçalho azul, logomarca e painel claro à direita. As artes foram preparadas pelo editor de imagens integrado, removendo os números e textos de exemplo para permitir renderização nativa. Nenhum número do jogador é gravado em uma imagem. Assets novos: assets/utility/r44/mais_opcoes_base.png e progresso_global_base.png.

CityUtilityPage mantém o registro proporcional de 1672 x 941 usado no restante do jogo, com fundo ambiente nas margens. As artes, áreas de toque e textos partilham a mesma transformação. A marca e os ícones decorativos dos quatro botões seguem a referência aprovada.

Mais opções mantém Faixita, Duelo das Placas, Progressão Global e Tela inicial, FECHAR e Voltar. Recorde do Duelo e resumo global continuam lendo os dados reais do controlador. As quatro ações ficam visíveis sem rolagem. O diálogo ocupa a tela e preserva o comportamento de fechar o menu antes de abrir o destino.

Progresso Global conserva os indicadores, chaves de teste, conquistas, pilares e condições de conclusão. O resumo e os critérios foram compactados visualmente conforme o mockup, sem alterar cálculos. O restante dos indicadores é acessível pela rolagem vertical dentro do painel. A entrada é exibida como Progressão Global no menu e PROGRESSÃO GLOBAL no cabeçalho; duas expectativas de texto dos testes anteriores acompanham a grafia e caixa.

## Preservação

Controller, GlobalProgressService, modelos, armazenamento, economia, missões, cenas das zonas e compras não são alterados. O significado atual dos indicadores de Construa o Bairro é preservado. Não há reinicialização do progresso, demonstração com dados falsos ou alteração de saldo.

Cinco arquivos existentes são modificados: as duas telas, pubspec para registrar o novo diretório de assets e duas expectativas de títulos nos testes. Acrescentados o componente compartilhado, testes de regressão, dois PNGs e este registro. A alteração local gerada do macOS fica fora do pacote.

## Validação

Preparação: parsing Dart/PowerShell, hashes e integridade do ZIP conferidos. Flutter não está disponível neste ambiente. Analyze, testes, build web, build APK e homologação no aplicativo estão PENDENTES.

Testes acrescentados: três viewports horizontais, texto ampliado no menu, quatro destinos acessíveis, fechamento sem alterar save, presença dos indicadores e navegação para Progresso Global/retorno. As verificações anteriores de recorde, resumo global e abertura das rotas devem continuar passando.

O instalador confere a base e os hashes antes de alterar fontes, cria a branch fix/fast-22a-opcoes-progresso-r44, faz backup e executa os gates. Não faz commit/push/merge/deploy. Depois dos gates, homologar ambas as telas no Chrome, A05 horizontal e tablet, incluindo FECHAR/Voltar, recorde, indicadores e rolagem.

## Produção das artes

Modo utilizado: editor de imagens integrado. Prompts: manter composição, Melo, cidade, logomarca e molduras das duas imagens aprovadas; na imagem do menu, retirar textos do cabeçalho, FECHAR, títulos/subtítulos dos quatro botões e legenda de mockup, preservando os quatro ícones e os botões; na imagem de progresso, limpar o interior do painel e o título, retirando valores ilustrativos e legenda de mockup, preservando a moldura e todos os elementos externos. Os arquivos originais aprovados permanecem como referência; o produto usa as duas bases novas e dados nativos.
