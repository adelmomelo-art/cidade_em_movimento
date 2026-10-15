# FAST22A R32 — Cultura / Eventos

Baseline: main R31 6549e26a77b02d6ff1ffa77fd90c7d7f39c0c620.
Branch: feat/fast-22a-cultura-eventos-r32.

## Escopo
Integra a Zona 4 ao padrão aprovado das Zonas 1–3. Mapa horizontal em tela única, arte nativa 1672×941, cenário cultural de Fortaleza estilizado, não georreferenciado. Centro cultural ilustrativo, praça de evento, acesso organizado, travessia, embarque, bloqueios e saída. Referência aprovada incluída em referencias/mapa_zona4_aprovado.png.

Melo, seis pontos de missão, avatar conforme perfil e HUD com valores reais substituindo os números ilustrativos. Fundo cobre janela e tabuleiro completo encaixa dentro da área segura sem rolagem. Melhorias em painel próprio; infraestrutura desenhada faz parte do cenário, enquanto estado de compra é mostrado no painel, seguindo R30/R31.

Missões preservadas: Chegada ao Evento, Travessia com Multidão, Embarque Organizado, Área de Bloqueio, Saída Segura e especial Cidade em Festa. Conteúdo e motor existentes intactos. Zona 4 requer Zona 3 e GUARDIAO_DA_ORLA. Especial requer cinco regulares e nove estrelas; medalha GUARDIAO_DA_CULTURA e bônus de 60 moedas mantidos. Avanço à Zona 5 — Grandes Vias segue o desbloqueio existente.

Melhorias: TRAVESSIA_EVENTO_SEGURA (60), SINALIZACAO_TEMPORARIA (80), EMBARQUE_EVENTO_ORGANIZADO (100). Sem compra de iluminação nesta zona.

Diálogo com cabeçalho azul/texto branco, Melo e pergunta, respostas com confirmação explícita, feedback, resultado e persistência. Seleção/cancelamento não premiam; bloqueio ao salvar e repetição segura em falha mantidos. Sem cronômetro ou voz implementada. Vídeos curtos, decisões na cena e exploração 3D permanecem propostas futuras; concluir fases atuais primeiro. Animação de carros continua congelada.

## Artes de produção
Imagegen: referência aprovada exec-667ca00c-825a-4250-955f-6fc0226c5526.png. Edições: mapa com HUD e avatar ilustrativo removidos; cenário sem interface; template de missão R31 com entorno cultural/evento, mantendo posições dos painéis, Melo e botões. Dados reais são renderizados em Flutter. Sem substituir artes homologadas das demais zonas.

## Aplicação protegida
Instalador exige baseline exata e main limpa, ou branch R32 na mesma baseline para repetição. Valida hashes e conteúdos protegidos antes da cópia; aceita conversão CRLF/LF em texto. Cria backup, preserva APK anterior e logs. Não executa commit, push ou merge. Arquivos rastreados fora do payload são verificados antes e depois.
