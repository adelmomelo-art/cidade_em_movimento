# FAST22A WORK R28 — tres veleiros

Base homologada: d09d90e082be56722f5569d4911b8c242672b49a, PR #5.
Branch: feat/fast-22a-barcos-r28.

## Escopo aprovado

Tres veleiros: pequeno ao horizonte, medio no mar central e maior proximo a orla. Aparencia, distribuicao e ritmo da previa aprovados em 14/10/2026. Percursos de ida e volta, sem fade ou teletransporte. Carros e pessoas fora desta entrega.

A imagem nova mapa_sem_barcos_r28.png remove as embarcacoes estaticas. A arte R27 permanece arquivada no projeto. A nova imagem foi apresentada e aprovada na previa; nenhuma alteracao no motor, recompensas, perfis, navegacao ou persistencia.

## Implementacao

CustomPainter em camada decorativa IgnorePointer / ExcludeSemantics, com RepaintBoundary proprio. Um AnimationController pinta os tres veleiros sem reconstruir a tela a cada frame. Coordenadas do mapa 1672x941; camada do mar em (1100,100,572,500).

Periodos completos de ida e volta: horizonte 190s, central 150s, orla 120s, com fases distintas e tamanhos .48, .8 e .92. O relogio de 11400s e multiplo dos tres periodos. Retorno suave com mudanca de orientacao, sem transparencias. Desenho reproduz as formas e cores da previa aprovada.

O relogio para com TickerMode desabilitado, ciclo de vida fora de resumed e MediaQuery.disableAnimations. Retoma da fase preservada; dispose libera ticker e observador. Movimento reduzido mantem tres veleiros estaticos.

## Testes

flutter_test_config.dart ativa movimento reduzido por padrao nos testes funcionais e de imagem. Animacao infinita nao e compativel com pumpAndSettle; os testes especificos R28 reativam movimento e avancam frames com duracoes limitadas. Nenhum teste e removido ou ignorado.

ApprovedArtworkPage recebe chave opcional para uma camada isolada de fundo. O teste de pixels R27 compara esse fundo renderizado com a nova arte aprovada, mantendo regioes, passo e tolerancia. Movimento, pausa, continuidade, limites, ausencia de colisao e passagem de toques sao verificados separadamente em R28.

## Gates e fechamento

Instalador confere baseline e hashes, faz backup, cria branch e aplica pacote. Executa dependencias, formatacao, testes R28 e pixels, analyze, regressoes R24-R27, suite completa, builds Web/APK e integridade. Commit, push e merge somente apos tecnica e visual PASS.
