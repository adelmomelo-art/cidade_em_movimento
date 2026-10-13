# FAST22A R22 — mapa inteiro e orientação horizontal

Escopo aprovado: jogo na horizontal; mapa principal da Zona 1 inteiro, sem rolagem,
em celular, tablet e Web. Mantém a composição R15 restaurada pelo R17:
KPIs/navegação no topo, missões na base esquerda, Melo à direita das missões,
melhorias dentro do cenário. Mantém os bytes da janela de perguntas R21,
o Melo, o cenário, os assets e a lógica de recompensas.

## Implementação

A composição original é desenhada em 1360 × 906,6667 pixels lógicos, razão 3:2.
FittedBox.contain aplica uma transformação única para caber no SafeArea real,
com margem de quatro pixels lógicos. Não corta nem estica a imagem e não há
Scrollable no mapa. Pode sobrar área nas laterais de telas mais largas.
A escala usa o menor fator entre largura/1360 e altura/906,6667 disponíveis.
Os pixels físicos dependem da densidade do aparelho; não são uma resolução
fixa de janela. Nenhum painel é movido para fora da imagem.

Na entrada Android, SystemChrome solicita landscapeLeft e landscapeRight.
Android pode recusar o bloqueio em telas grandes (por exemplo API 36/600 dp).
O gate global usa a orientação real: em retrato mostra “Gire a tela para jogar”.
Na Web, que não depende de bloqueio nativo, a mesma regra orienta o usuário
para girar o aparelho ou alargar a janela. Navigator e suas rotas permanecem
montados em Offstage; TickerMode e ExcludeFocus pausam animações/foco ocultos.
A missão e a resposta selecionada voltam ao retornar à horizontal.

## Limites de homologação

O enquadramento proporcional também reduz textos e áreas visuais de toque.
Os alvos conservam suas dimensões no quadro original; não se afirma que tenham
48 pixels lógicos depois da transformação. Os testes passam a verificar tanto
as dimensões originais quanto visibilidade/clique e ausência de sobreposição.
Conferir leitura e precisão dos toques no A05 e tablet reais antes de aceitar.
A janela de perguntas mantém o cálculo de tamanho aprovado R20/R21 em função
da janela do aplicativo; não é recalculada a partir do mapa agora reduzido.
Os demais mapas não receberam nova composição nesta entrega. O gate horizontal
abrange o aplicativo; regras, progressão, compras e persistência permanecem.

Voz e cronômetro continuam previstos para etapa posterior.
