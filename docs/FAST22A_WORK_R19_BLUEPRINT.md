# FAST22A WORK R19 — fidelidade à proposta 3

13/10/2026. Usuário reprovou R18A visualmente. Esta revisão aplica o padrão
a todas as etapas: introdução, pergunta, consequência, explicação e resultado.

Janela com proporção 16:9 quando há altura suficiente; largura máxima 1050
pixels lógicos. Em telas horizontais baixas a altura respeita o espaço
disponível, com rolagem apenas no conteúdo à direita. Vertical reorganiza
Melo acima do conteúdo, conservando leitura e estado ao girar.

Melo ocupa 34% da largura nas telas horizontais e permanece visível enquanto
o conteúdo rola. Novo recorte transparente baseado no mockup aprovado: arquivo
assets/zone_1/melo_perguntas_r19.png. Artes anteriores preservadas.
Título central em branco sobre azul; balão amarelo com borda e ponta para
Melo; cenário com gradiente de 50% ao fundo. Nenhum painel branco das etapas
R14 permanece. Todas as etapas usam a mesma posição de personagem e cabeçalho.

Pergunta mostra contexto original da missão e o enunciado original, sem
reescrever a fonte pedagógica. Alternativas com fonte 18, A/B/C amarelos,
botões azuis e seleção amarela. Confirmar resposta tem fundo azul sólido,
borda amarela e texto branco, inclusive quando desativado sem seleção.

Ícone de voz permanece desativado; cronômetro não implantado. Motor, perguntas,
recompensas, bloqueios e persistência inalterados. Layout do mapa R17 preservado.
Pubspec R13 recebe apenas a declaração do novo asset, sem nova dependência.

Novo teste atravessa seis estados (inclui seleção) em desktop, horizontal,
vertical e texto ampliado; confere proporção, uniformidade, presença do Melo,
cores, visibilidade do botão desativado e recompensa. Produz 24 capturas
Flutter em build/fast22a_r19_evidencias durante a execução Windows.
Capturas de widget test podem usar fonte de teste e não substituem a conferência
real do Chrome e A05. Testes de missão e persistência anteriores mantidos.
