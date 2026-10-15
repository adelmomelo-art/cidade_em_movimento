# FAST22A R31 — Orla / Praia de Iracema

Baseline: main R30 d9f8cc92d9b795f5cc91c240344f9a411e95c457.
Branch: feat/fast-22a-orla-iracema-r31.

## Escopo aprovado
Mapa horizontal no padrão das Zonas 1 e 2, cenário costeiro estilizado com Estoril e Ponte dos Ingleses, seis pontos de missão, Melo, avatar real e HUD dinâmico. Arte nativa 1672 × 941. Fundo cobre a janela e tabuleiro completo encaixa na área segura, sem rolagem. A localização é ilustrativa, não georreferenciada.

Missões existentes: Travessia na Beira-Mar, Ciclovia Compartilhada, Desembarque na Orla, Olhos na Orla, Fluxo da Praia e Orla em Equilíbrio. Conteúdo, motor, pré-requisitos, recompensas, compras e persistência existentes preservados. Zona 3 depende da Zona 2 e GUARDIAO_DO_CENTRO; a especial mantém cinco missões e nove estrelas como requisitos; medalha GUARDIAO_DA_ORLA libera a Zona 4.

O avatar reflete o perfil salvo. Indicadores reais substituem números ilustrativos do mockup. Melhorias usam o catálogo existente: TRAVESSIA_ORLA_SEGURA (60), CICLOVIA_CONECTADA (80), EMBARQUE_ORGANIZADO (100). Infraestrutura ilustrada faz parte do cenário; estado de aquisição é exibido no painel, como na Zona 2. Não há compra de iluminação nesta zona.

Diálogo conserva etapas, seleção e confirmação, cancelamento sem recompensa, bloqueio durante salvamento e repetição segura em falha. Título branco sobre azul, Melo e pergunta juntos, botões no padrão, sem rolagem. Ícone de voz reservado para futura implementação. Cronômetro e animações novas não fazem parte desta entrega; proposta de carros permanece congelada.

## Artes
Referência aprovada: exec-2e150f8c-593a-4acf-9f21-a3779c06b29d.png, incluída em referencias. Edições por imagegen: mapa com HUD vazio e avatar ilustrativo removido; cenário costeiro sem interface; template de missão baseado no homologado R30 com ambiente da Orla. Arquivos originais de produção incluídos em assets/zone_3/r31. Sem alteração das artes das demais zonas.

## Proteção
Instalador exige baseline exata, main limpa ou branch R31 na mesma baseline, verifica hashes antes de copiar, cria backup e logs e protege arquivos rastreados fora do payload. Não executa commit, push ou merge.
