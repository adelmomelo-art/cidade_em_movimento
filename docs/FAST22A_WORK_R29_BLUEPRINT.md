# FAST22A WORK R29 — Zona 1 no padrão aprovado

Data: 14/10/2026. Baseline: `36f60bb2945f64582710aa666a42ccd2b998e2f3` (R28, PR #6).
Branch de trabalho: `feat/fast-22a-zona1-identidade-r29`.

## Referências aprovadas

- Mapa horizontal da Zona 1 — Bairro / Escola, aprovado pelo usuário nesta conversa.
- Mockup “Travessia segura_ decida antes de atravessar.png”, aprovado pelo usuário.
- Tela horizontal; composição inteira visível; cenário nas margens excedentes, sem bordas brancas e sem rolagem do mapa/missão.

## Implementação

1. Mapa ilustrado com seis alvos reais nos pins do desenho; bloqueios e estrelas consultam o progresso persistido.
2. Avatar no início e retrato no HUD seguem as seis variantes existentes. O modelo atual não possui nome livre do jogador; nenhum campo ou migração foi criado.
3. HUD mostra cidadania, conhecimento, moedas e estrelas reais; medalha somente se conquistada.
4. Missão em composição horizontal completa: Melo à esquerda, cenário central e decisão à direita. Título branco sobre azul; alternativas azuis; ação principal amarela, conforme o mockup aprovado.
5. Etapas Observe / Decida / Consequência / Aprenda ligadas ao MissionController existente. Consequência, explicação, erro de gravação e resultado usam o mesmo painel lateral.
6. Resposta pendente precisa de confirmação. Fechar/voltar não recompensa. Salvamento bloqueia saída, permite repetir a gravação e mantém a proteção contra prêmio duplicado do controlador.
7. Fonte ajustada ao espaço medindo texto completo; sem reticências ou rolagem. Texto ampliado e áreas de sistema entram nos testes.
8. M01 usa o cenário aprovado de Travessia Segura. M02–M05 e especial usam enquadramentos da arte limpa do bairro (ônibus, ciclovia, parada, praça e escola), preservando textos por perfil do catálogo atual.
9. Melhorias ficam acessíveis pelo botão Melhorias. Compras e custos existentes preservados; a visualização noturna consulta a iluminação comprada. Faixa/ciclovia já fazem parte da nova arte-base; a condição de instalação aparece no painel de melhorias, sem reutilizar os traços do cenário antigo em coordenadas incompatíveis.
10. Voz: ícone com informação “Voz em breve”, sem ação. Cronômetro permanece futuro. Veículos animados e Zona 2 fora do escopo. Mapa de Fortaleza e três barcos R28 intactos.

## Artes e geração

Três PNGs preparados com a ferramenta integrada de imagens (não CLI), a partir dos mockups aprovados:
- `assets/zone_1/r29/mapa_aprovado.png`: HUD esvaziado e personagem inicial removido para renderização dinâmica; demais elementos mantidos.
- `assets/zone_1/r29/missao_template.png`: campos de texto esvaziados; bordas, botões, Melo, logo e cena mantidos. Semáforo corrigido para uma única luz vermelha acesa.
- `assets/zone_1/r29/cenario_bairro.png`: cenário do mapa sem interfaces, pins e personagem guia, para enquadramentos das missões.

Prompts finais: remoção apenas dos campos dinâmicos no mapa; remoção de textos dinâmicos na missão com conservação da composição; extração do cenário limpo; correção pontual da lâmpada amarela para apagada. Coordenadas lógicas comuns 1672 × 941; PNGs da missão e cenário têm largura 1671 e são ajustados por 1 pixel no desenho.

## Regressões

Os testes R10–R23 que exigiam a janela de 206/656 ou a faixa inferior antiga foram adaptados ao novo contrato aprovado. Nenhum teste foi marcado como skip. Permanecem os fluxos de seis missões/três perfis, recompensa única, persistência, falha de gravação, compra, navegação e rotação. Os testes independentes dos antigos painters continuam disponíveis.

R29 acrescenta capturas por avatar e por missão com área segura e texto ampliado. R19/R22/R23 passam a salvar evidências em `build/fast22a_r29_evidencias`, aguardando decodificação das imagens antes de capturar.

## Entrega

Pacote completo com arquivos finais, manifesto SHA-256, backup automático, script PS5.1 e seis grupos de validação. Não faz commit, push, merge, publicação ou reset do jogador.
