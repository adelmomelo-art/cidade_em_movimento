# FAST22A WORK R16 — mapa na tela disponível

Zona 1 na horizontal ajustada à largura E à altura úteis, respeitando a SafeArea.
A ilustração mantém proporção 3:2 e fica inteira; controles ficam em áreas reservadas,
sem reduzir seus alvos de toque com FittedBox. KPIs à esquerda, navegação e melhorias
à direita, missões abaixo da ilustração e Melo no canto direito.

Abaixo de 360 px úteis de altura, as ações de navegação usam o menu OPÇÕES.
Melhorias compactas abrem detalhes com descrição, saldo e compra pelo motor existente.
A pergunta aparece primeiro e a rolagem da janela volta ao topo ao mudar a etapa.
Perguntas e detalhes podem rolar; o mapa adaptado não possui ScrollView.

Modo adaptado: largura útil >= 500, altura útil >= 240, horizontal e cenário natural
mais alto que a tela. Vertical, desktop com altura suficiente e telas menores mantêm
layout R15. Orientação não é bloqueada. Fontes ampliadas até 1,4 são cobertas pelos
novos casos de teste, cuja execução nesta revisão está pendente.

GameSceneViewport é um componente reutilizável. As demais zonas ainda não foram
alteradas: aplicar nelas após PASS real da Zona 1 no A05. Conteúdo, assets, motor,
persistência, compras e regras de liberação são preservados.
