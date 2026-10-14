# FAST22A R25 — escolha do perfil no padrão aprovado

Baseline: main c070a943b4b6d705e4afc5b4c4f73eaa4c0329ad, PR #3 merged.
R24A técnica/visual PASS e fechamento Git confirmados pelo usuário.
R25: mockup horizontal dos três perfis e Voltar aprovado em 14/10/2026.

## Fidelidade e ações

Usa o PNG aprovado de 1672×940, sem modificar pixels.
Asset: assets/profile/escolha_perfil_r25.png.
SHA-256: d7458c581f3904f7b4701edad735d4fe317a5070040e048a83de49954468688c
Título, subtítulo, personagens, cores, cartões, descrições e botão Voltar
permanecem na arte. Áreas clicáveis transparentes usam o mesmo quadro lógico;
retrato, rótulo e descrição de cada cartão são selecionáveis. Hover, foco e
toque acrescentam feedback temporário. Rótulos e instruções são semânticos,
com Tab/Enter. Não adiciona etapa de confirmação nem rolagem.

| Cartão | Argumento enviado à rota existente de avatar |
| --- | --- |
| Criança — Explorador da Cidade (azul) | PlayerType.child |
| Adolescente — Cidadão em Formação (amarelo/laranja) | PlayerType.teen |
| Adulto — Condutor Consciente (verde) | PlayerType.adult |

Tocar no cartão apenas abre AppRoutes.avatar com o tipo correto, como antes.
Não cria nem grava perfil nesta tela. A tela de avatar original continua
oferecendo Menino/Menina para criança e opções existentes para os demais.
Voltar retorna à rota anterior; se não existir, substitui a rota pela inicial.

## Proporções e limites

Composição nítida inteira dentro do SafeArea com BoxFit.contain. Nenhuma cabeça,
descrição ou ação é cortada ou esticada. Usa a mesma solução aprovada na R24A
para proporções distintas: fundo com a própria imagem desfocada/escurecida,
preenchendo laterais/topo/base disponíveis sem áreas brancas.
Textos gráficos são pixels do PNG, não aumentam com TextScaler. Leitores de
tela recebem rótulos/hints reais. Conferir leitura e toque no A05; não se promete
alvo de 48 dp em todas as dimensões. O golden compara a composição nítida,
não declara que viewports de proporções distintas têm pixels idênticos.

## Escopo e proteção

Somente ProfileScreen e registro de um asset no pubspec mudam em produção.
Acrescenta PNG, teste e documentação. HomeScreen/arte R24A, avatar, rotas,
controllers, persistência, mapas, perguntas, gate e orientação ficam protegidos.
Branch: feat/fast-22a-perfis-r25. Sem commit/push/merge automáticos.
Voz, cronômetro, novo cenário e redesenho de avatar continuam futuros.
