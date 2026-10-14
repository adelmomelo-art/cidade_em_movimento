# FAST22A WORK R27B — referência renderizada e diagnóstico de pixels

14/10/2026. Na execução Windows da R27A passaram os outros 70 testes dedicados, incluindo estados, navegação, perfis e teclado. Falhou somente native cathedral, pier and lighthouse retain approved pixels. O teste isolado informou diferença em (450,100), canal 0, sem os valores RGBA.

A R27B altera somente o teste de comparação visual: a referência aprovada agora é pintada por Image.asset/Flutter e capturada por RepaintBoundary, como a tela real. A versão anterior comparava bytes diretos de instantiateImageCodec com os de uma superfície renderizada. As mesmas duas regiões, grade de amostragem e tolerância de 1 por canal permanecem. A discrepância anterior pode decorrer da diferença entre esses caminhos de imagem; sua origem precisa ser confirmada pela execução no Windows.

As duas capturas são independentes: primeiro a tela real completa, depois a referência estática aprovada. Dimensões nativas de ambas são verificadas. As asserções de comparação ficam fora de runAsync, para exibir a causa diretamente. São salvos r27b_actual_map.png, r27b_approved_reference.png e r27b_pixels.txt em build/fast22a_r27_evidencias. Em diferença, o erro mostra RGBA esperado/obtido e o relatório conta as amostras divergentes.

Código do aplicativo, arte, sprites, navegação, motor, recompensas e outros testes são idênticos à R27A. O instalador aceita R26/R27/R27A/R27B e mantém a branch feat/fast-22a-mapa-fortaleza-r27 no HEAD 2adfd2d. Executa o teste isolado antes do analyze demorado e, se passar, prossegue com todos os gates completos.

Formatação/sintaxe Dart, integridade dos arquivos e ZIP verificadas na preparação. Analyze, teste corrigido, suíte e builds PENDENTES de execução no Windows por ausência do cache de dependências neste ambiente. Nenhum PASS técnico nem homologação visual declarados. Não faz commit/push/merge.
