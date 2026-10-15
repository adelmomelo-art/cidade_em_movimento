# FAST22A R34 — Polo Castelão

Baseline: main R33 74e34220d6ffe4c4a1374d21095501eb81466b25.
Branch: feat/fast-22a-polo-castelao-r34.

## Escopo aprovado
Mapa da Zona 6 no padrão homologado das Zonas 1–5. Tela horizontal única, arte nativa 1672×941, cenário estilizado da Arena Castelão e seu entorno, sem pretensão georreferenciada. Referência aprovada em referencias/mapa_zona6_aprovado.png. Melo, seis pontos, avatar conforme perfil e HUD com valores reais. Fundo cobre a janela e tabuleiro completo encaixa na área segura sem rolagem. Melhorias em painel próprio.

Missões existentes mantidas: Chegada ao Castelao, Travessia da Torcida, Embarque e Desembarque, Bloqueio Temporario, Saida do Estadio e especial Operacao Dia de Jogo. Arte e alvos visuais usam acentuação; títulos e textos do motor não foram modificados. Zona 6 depende da Zona 5 e GUARDIAO_DAS_VIAS. Especial requer cinco regulares e nove estrelas. Mantidos medalha GUARDIAO_DO_CASTELAO e bônus de 60 moedas.

Última zona do catálogo atual: não há Zona 7. Ao concluir Zona 6 aparece botão de troféu com indicação de conclusão e acesso à tela existente de Progresso Global. Conclusão e medalha permanecem no modelo de progresso existente. Retorno ao mapa de Fortaleza segue disponível. Não foi criada nova tela final nem alterado o motor.

Melhorias: CORREDOR_PEDESTRE_CASTELAO (60), ILUMINACAO_ENTORNO_CASTELAO (80), EMBARQUE_INTEGRADO_CASTELAO (100). Estado de compra persistente no painel; a infraestrutura desenhada integra o cenário. Iluminação produz brilho visual somente à noite, no mapa e na pergunta, quando adquirida.

Diálogos mantêm cabeçalho azul com letra branca, Melo/pergunta, seleção e confirmação, consequência, feedback e resultado. Cancelamento/seleção não premiam; bloqueio durante salvamento, repetição em falha e proteção contra recompensa duplicada preservados. Sem implementação de voz, cronômetro, vídeos curtos, decisões na cena ou exploração 3D. Essas propostas permanecem para evolução futura; carros continuam congelados.

## Artes
Referência aprovada imagegen: exec-f4fdf3c3-f006-48e6-8b3e-bf7485f140a4.png. Edições de produção: HUD limpo e avatar ilustrativo removido, preservando Melo; cenário sem interface; template R33 com ambiente de chegada ao estádio e controles nos mesmos lugares. Dados reais renderizados em Flutter. Artes das zonas homologadas preservadas.

## Aplicação protegida
Exige baseline exata em main limpa ou branch R34 no mesmo HEAD para repetição. Valida hashes e conteúdo protegido antes de copiar; aceita equivalência CRLF/LF em texto. Cria backup de arquivos, APK anterior e logs. Verifica novamente payload e arquivos protegidos depois dos gates. Nenhum commit, push ou merge automático.
