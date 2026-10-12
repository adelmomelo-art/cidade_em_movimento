# FAST-22A - Zona 1 Visual Mestre

## Objetivo
Transformar a Zona 1 - Bairro / Escola na primeira tela de jogo visualmente
inspirada no mockup oficial, preservando integralmente o motor homologado.

## Baseline
fa15589

## Principios
- o mockup e referencia visual, nao uma imagem estatica clicavel;
- cada missao permanece um elemento Flutter real;
- bloqueios continuam vindo do motor;
- estrelas continuam vindo do progresso;
- melhorias continuam sendo compradas pelo PlayerController;
- a cena reage as melhorias ja instaladas;
- Web e Android usam a mesma composicao responsiva.

## Elementos do mockup representados
- HUD de Cidadania, Conhecimento, Moedas e Estrelas;
- cabecalho Zona 1 - Bairro / Escola;
- Melo como mentor;
- escola e bairro;
- onibus, carros, bicicleta e vias;
- seis marcadores de missao;
- missao especial bloqueada/desbloqueada;
- trilho de missoes;
- melhorias da Zona 1;
- resultado visual das melhorias.

## Fora do FAST-22A
- assets ilustrados finais do Melo;
- arte final isometrica definitiva;
- redesenho interno das telas de missao;
- animacoes de transicao;
- mudancas no motor.

## Proximo
FAST-22B - Template Visual das Missoes.
## R2 - Polimento Visual Mestre
A homologacao visual R1 aprovou motor, HUD, bloqueios, rotas,
responsividade e estrutura, mas reteve o fechamento visual.

R2 adiciona:
- arte vetorial responsiva do bairro/escola;
- escola incorporada ao cenario;
- vias, praca, predios, vegetacao, veiculos e pedestres;
- Melo como personagem vetorial;
- marcador especial diferenciado;
- comparacao ilustrada ANTES/AGORA;
- Unicode seguro para estrelas;
- preservacao total do motor.

## R7 — Integracao ilustrada
A R6 passou nos gates tecnicos, mas nao atingiu a referencia visual.
R7 integra o cenario e Melo como assets ilustrados com fundo transparente,
marcadores Flutter reais e infraestrutura em camadas acionadas pelos upgrades
existentes. As exclusoes de assets finais da proposta inicial foram superadas
pelo escopo visual autorizado desta revisao.

Arquitetura: FAST22A_WORK_R7_BLUEPRINT.md.
Validacao: FAST22A_WORK_R7_VALIDACAO.md.
Homologacao visual no Chrome pendente; nao avancar para FAST-22B antes dela.
