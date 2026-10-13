# R23 — cenário ocupa a área inteira do aplicativo

R22: orientação horizontal aprovada pelo usuário no A05. Reprovado o mapa
centralizado com faixas claras laterais. R23 corrige o enquadramento da Zona 1.

## Causa e mudança

R22 encaixava um quadro fixo 1360×906,6667 (3:2) com BoxFit.contain, margem de
4 e SafeArea externo. Uma tela horizontal mais larga deixa espaço nas laterais.
R23 calcula a altura do quadro lógico a partir da proporção real do viewport.
Sua largura segue 1360; altura = alturaDisponível / (larguraDisponível / 1360).
Assim a transformação do quadro ocupa exatamente toda a largura e altura.
Elimina margem externa e arredondamento nos cantos do cenário nesse modo.

A arte continua usando o BoxFit.cover proporcional já existente em
Zone1NeighborhoodArt. Reenquadra as bordas da ilustração conforme a proporção
real: em telas largas pode cortar trechos do topo/base; em telas mais altas,
trechos das laterais. Não estica a arte e não aplica cover aos controles.
O mesmo quadro interno 1536×1024 contém imagem e pinturas de faixa, ciclovia
 e iluminação, mantendo o alinhamento entre elas durante o reenquadramento.
Não se afirma que todos os pixels da ilustração original continuam visíveis.
O cenário preenche a tela; todos os controles continuam dentro da área útil.

KPIs, navegação, missões, Melo e melhorias mantêm sua organização sobre o
cenário. Insets do Android são convertidos à escala do quadro e aplicados
somente aos painéis: o desenho passa por trás dessas áreas sem faixas claras.
Não acrescenta rolagem ao mapa. O fallback de retrato fica disponível apenas
para montagem interna/testes; o gate global aprovado continua ocultando o jogo
na vertical. Orientação, gate, janela de perguntas e Melo de perguntas têm
os mesmos bytes da R22. Não altera motor, recompensas, assets ou dependências.

## Homologação

A R23 ainda depende de testes e builds no Windows e conferência no A05,
Chrome e tablet. Não promete precisão de toque de 48 dp após o escalonamento.
Conferir leitura, toques, cenário reenquadrado, compras, dia/noite e seis missões.
A área ocupada é a área do aplicativo; barras do sistema são controladas pelo
Android. Voz e cronômetro seguem para etapa posterior. Sem commit/push/merge.
