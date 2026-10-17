# R36C — Verificação dos limites do rótulo

Evidência Windows R36B: 18 casos de ajuste de texto falharam; os três casos Embarque Seguro (criança, adolescente, adulto) passaram. Caso isolado: Conhecimento, teste linha 47, canto inferior direito da caixa de seleção fora de RenderParagraph.size.

## Revisão
A comparação anterior usava apenas o tamanho interno do parágrafo, não o espaço reservado ao rótulo pelo widget. As caixas de seleção da fonte podem exceder métricas internas do parágrafo, sem demonstrar por si só um corte na área destinada ao texto.

Agora o teste identifica o SizedBox que reserva a área do rótulo, transforma as caixas de seleção para as mesmas coordenadas globais e verifica sua contenção nessa área. Mantém a tolerância anterior de 0,6 unidade, a conferência do texto integral e o limite de linhas. Se houver falha, a mensagem inclui o retângulo selecionado, a área disponível e o tamanho do parágrafo para localizar o excesso.

Foi incluído um controle negativo: texto Conhecimento com fonte propositalmente grande em uma área 96×24 recortada. O verificador deve detectar esse excesso.

## Preservação
Nenhum arquivo de lib/, cenário, Melo, fonte nominal, janela, controlador, conteúdo pedagógico ou recompensa muda nesta revisão. R36C preserva a compatibilidade do registro VideoPlayerPlugin conferido na R36B. O pacote é completo, aplicável sobre R34, R35 ou uma R36 parcial reconhecida, no HEAD eb09fc1 e nas branches permitidas.

## Verificação
Formatador e análise estática: verificar resultado da preparação. Testes Flutter, Web/APK e homologação visual continuam pendentes no Windows. Esta revisão corrige o critério do teste; não constitui PASS dos 18 casos sem nova execução.

VALIDACAO TECNICA = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE

Sem commit, push ou merge automático.
