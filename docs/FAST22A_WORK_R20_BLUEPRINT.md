# FAST22A WORK R20 — proporção da referência enviada

13/10/2026. Referência: image(20261013-153541).png, 760 x 486 pixels.
Medição visual aproximada: mapa de x54 a710/y29 a468 =656 x439 px;
janela de x190 a396/y199 a309 =206 x110 px. Tolerância de poucos pixels
pelas bordas da captura.

Padrão: largura da janela =206/656 da largura do cenário (31,40%).
Proporção horizontal =206/110 (1,8727:1). A altura equivale a aproximadamente
25% da altura do mapa 3:2. Centro horizontal por volta de 37% da largura
do mapa, sem ocupar a coluna direita de melhorias. Centralização vertical
na área útil.

A R19 chegava a1050 x590,625 pixels lógicos (16:9). Exemplo com mapa
1340 px de largura: janela nova420,79 x224,70, cerca de60% menor na largura
e62% menor na altura que o máximo R19.

No horizontal, piso de360 pixels lógicos para leitura/toque, limitado à
largura útil caso a tela seja menor. Assim, em celulares a fração pode ser
maior que31%; o piso é uma adaptação de usabilidade, não tamanho fixo de
todas as telas. Na vertical a janela utiliza a largura útil. Altura nunca
ultrapassa o espaço disponível. Rotação preserva a missão.

Cabeçalho compacto com botões de48 px e título central. Texto do balão13/16
px, respostas14 px, confirmação14 px e alvo mínimo48. Melo mantém34% da
largura do quadro na horizontal; não reduzir o quadro inteiro viaFittedBox.
Contexto/enunciado preservados, voz futura só na pergunta. Conteúdo longo
rola à direita do Melo; janela externa mantém tamanho entre etapas.

Mapa, assets, motor, progresso e regras inalterados. Identidade amarela/azul
da R19 em introdução, pergunta, consequência, explicação e resultado.
Cronômetro e voz futura. Atualizado contrato geométrico dos testes R15/R19
para a nova proporção; testes funcionais/recompensas mantidos. Novo teste
cobre desktop, A05 horizontal e janela muito estreita, dimensão, posição,
permanência entre etapas, alvo do fechamento e saída sem recompensa.
