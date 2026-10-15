# FAST22A R33 — Grandes Vias

Baseline: main R32 9834819258ce79ec0069b8068e97e701316e9f2f.
Branch: feat/fast-22a-grandes-vias-r33.

## Escopo aprovado
Mapa da Zona 5 no padrão homologado das Zonas 1–4. Tela horizontal única, 1672×941, cenário ilustrativo de grandes avenidas de Fortaleza, sem pretensão georreferenciada. A referência aprovada está em referencias/mapa_zona5_aprovado.png. Preservar seis pontos, Melo, avatar e HUD com dados reais. O fundo preenche a janela e o tabuleiro completo encaixa na área segura, sem rolagem. Melhorias em painel próprio.

Missões existentes mantidas: Travessia de Grande Avenida, Ponto Cego, Velocidade e Distância, Acesso e Conversão, Fluxo Intenso e especial Corredor em Equilíbrio. Sem mudanças nos conteúdos, controladores, catálogos, regras ou persistência. Zona 5 requer Zona 4 e GUARDIAO_DA_CULTURA. Especial requer cinco missões regulares e nove estrelas. Mantidos medalha GUARDIAO_DAS_VIAS, bônus de 60 moedas e avanço condicionado à Zona 6 — Polo Castelão.

Melhorias do catálogo: TRAVESSIA_GRANDE_VIA (60), ILUMINACAO_CORREDOR (80), REFUGIO_PEDESTRE (100). Infraestrutura desenhada integra o cenário; o painel mostra a compra persistente. Iluminação do Corredor produz brilho visual no mapa e na cena da pergunta somente no modo Noite e após compra. Não altera recompensas nem desbloqueios.

Diálogos seguem etapas homologadas: título branco sobre azul, Melo e pergunta, escolha e confirmação explícita, consequência, feedback, resultado. Cancelamento/seleção não premiam; bloqueio durante salvamento e repetição segura em falha preservados. Ícone de voz reservado. Vídeos de dez segundos, perguntas curtas, decisões na cena, exploração 3D e cronômetro permanecem evoluções futuras. Concluir as fases atuais primeiro; proposta de carros permanece congelada.

## Artes
Referência aprovada gerada: exec-4453b01a-756a-4a27-a041-735f6ece0f14.png. Edições imagegen para produção: mapa com HUD e avatar ilustrativo removidos; cenário sem interface; template R32 com cena de grande avenida, criança aguardando com adulto antes da travessia. Mantidos painéis, Melo e botões no padrão. Dados do jogador desenhados em Flutter.

## Aplicação e proteção
Instalador exige main R32 limpa na baseline exata ou a branch R33 no mesmo HEAD para repetição. Hashes conferidos antes da cópia e depois dos gates; texto admite equivalência CRLF/LF. Cria backup dos arquivos e APK anterior, com logs. Protege arquivos rastreados fora do payload. Não executa commit, push ou merge.
