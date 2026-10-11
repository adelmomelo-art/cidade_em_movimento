# FAST-21 - Sistema Visual Oficial

## Objetivo
Integrar a linguagem visual oficial do Cidade em Movimento ao motor homologado,
sem alterar regras de jogo, progressao, economia, desbloqueios ou persistencia.

## Baseline
e04a880

## Escopo
- sistema global de cores e componentes;
- tema Material 3 revisado;
- Home com identidade de jogo;
- selecao de perfil com identidade de jogo;
- Mapa de Fortaleza com fundo visual oficial;
- preservacao integral das rotas e do motor.

## Direcao visual
- cidade brasileira educativa, moderna e acolhedora;
- linguagem colorida, limpa e contemporanea;
- referencias de jogo sem infantilizar o publico adulto;
- paineis arredondados;
- hierarquia forte de progresso;
- uso de azul, ciano, verde, amarelo e laranja;
- elementos que possam receber ilustracoes 2D/3D futuras sem refatorar o motor.

## Regra de congelamento
FAST-21 nao cria:
- nova zona;
- nova missao;
- nova moeda;
- novo desbloqueio;
- nova regra de pontuacao;
- novo backend.

Visual pode mudar. Motor permanece congelado.

## Fases seguintes
FAST-22:
- integracao visual das seis zonas e missoes.

FAST-23:
- polimento, microanimacoes, UX e performance.

## Observacao
Os componentes visuais deste FAST usam Flutter nativo e Material Icons.
Assets ilustrados definitivos podem ser adicionados posteriormente sem alterar
o contrato funcional fechado aqui.