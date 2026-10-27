# R44.1 — Sobreposição nas perguntas e Meu Progresso

## Evidência e causa

Na homologação R44, Mais opções e Progressão Global receberam PASS visual. A captura Z1_M01 mostrou um polígono de asfalto sobre o Melo. Zone1ArtworkBoard aplicava Zone1GroundRepair a qualquer arte. A posição do reparo B pertence ao mapa e coincide com o mascote na moldura das missões.

## Correções

- Aplicar o reparo B no board somente quando asset == zone1MapArtwork. Os reparos internos de Zone1MissionScene e Zone1ConstructionArt continuam intactos: a faixa B segue removida do mapa e dos cenários.
- Apresentar PlayerProgressScreen na CityUtilityPage existente, com a arte aprovada de progresso, título Meu Progresso, recursos, zonas, medalhas, melhorias e rolagem. Os atalhos Progresso da Zona 1 e Medalhas do mapa Fortaleza mantêm suas rotas e passam a mostrar essa composição.
- Preservar o acesso ao painel pedagógico, agora no cartão de identificação do jogador. Corrigir os caracteres corrompidos de concluída/concluídas nesta tela e a expectativa correspondente no teste.
- Manter o conteúdo das listas construído em um SliverToBoxAdapter, com rolagem, para conservar a leitura e as verificações de recursos/conquistas fora da primeira janela.

Não altera CityUtilityPage, Mais opções, Progressão Global, rotas, controllers, serviços, economia, missões, compras ou armazenamento. Não modifica o arquivo gerado macOS. Não realiza commit, push, merge ou deploy.

## Verificação

Conferência de sintaxe Dart/PowerShell e integridade do pacote no ambiente de preparação. Flutter indisponível aqui: analyze, testes Flutter e builds PENDENTES até execução do instalador. Novos testes cobrem reparo B no mapa, ausência de reparo indevido na moldura das seis missões e navegação dos dois atalhos com recursos reais, painel pedagógico, rolagem, retorno e save preservado.

## Homologação local

Após os gates: conferir todas as perguntas da Zona 1, especialmente o canto inferior esquerdo do Melo; verificar que o mapa continua sem a faixa B; abrir Progresso na Zona 1 e Medalhas em Fortaleza; conferir recursos, rolagem, medalhas e melhorias, painel pedagógico e Voltar. Confirmar em Chrome e A05 horizontal. Mais opções e Progressão Global já possuem PASS visual do usuário na R44.
