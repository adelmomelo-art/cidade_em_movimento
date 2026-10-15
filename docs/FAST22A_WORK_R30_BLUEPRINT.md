# FAST22A WORK R30 — Centro Histórico

Data: 15/10/2026. Baseline: main `4f08d2aed17b7c3cd676da25e917fbb4f1903f5c` (R29 homologado, PR #7).
Branch: `feat/fast-22a-centro-historico-r30`.

## Referência aprovada

Mockup horizontal da Zona 2 aprovado nesta conversa: `exec-8748a6b4-a119-4b7a-a6b1-3656aaf1b8a0.png`. Cópia de referência no pacote em `referencias/mapa_zona2_aprovado.png`.

Mapa inspirado no Centro de Fortaleza, com Catedral, Mercado Central e Praça do Ferreira. É uma composição ilustrada do jogo, não uma planta geográfica. Cabeçalho vermelho/branco, HUD azul, Melo à esquerda, seis pins e navegação inferior conforme a proposta aprovada.

## Escopo

- Substituir a tela antiga de cards/rolagem por mapa inteiro, proporcional, com cenário preenchendo as margens excedentes.
- Avatar inicial e retrato do HUD seguem as seis variantes já cadastradas. Números vêm do progresso real; medalha consulta `GUARDIAO_DO_CENTRO`.
- Cinco missões regulares e especial já existentes, sem alterar dados ou recompensas:
  1. Z2_M01 — Cruzamento em Movimento.
  2. Z2_M02 — Ponto Certo.
  3. Z2_M03 — Calçada é de Todos.
  4. Z2_M04 — Só Vou Parar Aqui.
  5. Z2_M05 — Rotas que se Encontram.
  6. Z2_SPECIAL — Centro em Harmonia.
- Abertura de missão exige Zona 2 desbloqueada, perfil presente e missão liberada.
- A Zona 2 mantém pré-requisitos existentes: conclusão da Zona 1 e medalha Protetor da Escola. Especial mantém cinco regulares e mínimo de nove estrelas. Conclusão concede a medalha, bônus e desbloqueio de Zona 3 pelos controladores existentes.
- Missões usam a composição aprovada da Zona 1: título branco sobre azul, Melo à esquerda, cenário central, perguntas/alternativas à direita, confirmação amarela. Observe / Decida / Consequência / Aprenda, resultado e erro de salvamento mantêm o painel.
- M01 usa a cena de travessia no Centro preparada a partir do template R29. Demais missões usam enquadramentos da arte limpa da Zona 2, nos pontos correspondentes de ônibus, calçada, parada de carro e encontro de rotas.
- Seleção pendente só responde após confirmação. Cancelar não recompensa; erro permite tentar novamente; gravação bloqueia fechar e oferece repetição segura, com a proteção contra prêmio duplicado já existente.
- Melhorias permanecem acessíveis pelo botão próprio, com custos existentes 60/80/100. Compras e estado INSTALADA são persistidos. Infraestrutura desenhada é parte da arte-base; estado de instalação aparece no painel, sem pintar traços do cenário antigo em coordenadas novas.
- Noite é uma prévia visual; catálogo da Zona 2 não inclui compra de iluminação. Progresso, retorno ao mapa de Fortaleza e avanço à Orla, quando liberado, continuam disponíveis.
- Voz mantém ícone informativo sem ação; cronômetro futuro. Veículos não receberam animações.

## Isolamento

Controladores, serviços, modelos, catálogos e textos/regras das missões não foram alterados. Nenhuma modificação na Zona 1 homologada, no mapa de Fortaleza ou nos três barcos. Rotas diretas legadas de missões da Zona 2 continuam existentes. O novo mapa abre as missões sobre o próprio cenário, mantendo seu estado.

Os componentes ilustrados foram isolados em `zone_2_approved_art.dart` e `zone_2_mission_dialog.dart`, reaproveitando a estrutura homologada R29, sem refatorar os componentes da Zona 1 nesta entrega.

## Artes de produção

Ferramenta integrada de imagens, modo de edição por referências (sem CLI):
- `assets/zone_2/r30/mapa_aprovado.png`: mapa aprovado; apenas HUD esvaziado e jogador inicial retirado para dados/avatares dinâmicos. Preservados pins, textos estáticos, Melo, posição dos prédios e controles.
- `assets/zone_2/r30/cenario_centro.png`: extração do cenário sem interfaces, para ambiente e enquadramentos das missões.
- `assets/zone_2/r30/missao_template.png`: template R29 com mesmo Melo, bordas, botões e proporções, substituindo cenário escolar pelo Centro. Campos de texto vazios recebem conteúdo do catálogo em tempo de execução.

Prompts: remover somente dados do HUD/jogador do mapa aprovado; extrair cenário sem UI com preservação dos marcos e posições; adaptar somente a ambientação do template de perguntas R29 para Centro Histórico. Coordenadas lógicas 1672 × 941.

## Testes

- Nova suíte R30: seis missões nos três perfis, prêmio único, persistência, falha de gravação, cancelamento, rotação, texto ampliado, áreas seguras, seis avatares, destinos e capturas.
- `zone_2_map_screen_test.dart`: substitui materialização/rolagem da antiga SliverList por alvos do mapa, compra única e persistência da melhoria.
- FAST9: Zona 2 passa a ser validada como tela fixa, junto da Zona 1. Demais zonas mantêm testes de rolagem.
- Suítes antigas de conteúdo, estrutura, progressão, melhorias e cena evolutiva continuam intactas; nenhum skip ou golden atualizado.

## Entrega

Pacote completo com manifesto SHA-256, guardas de baseline/arquivos, backup e seis grupos de gates. Sem commit, push, merge ou publicação automáticos. Homologar no Chrome, A05 horizontal e tablet antes de fechar no Git.
