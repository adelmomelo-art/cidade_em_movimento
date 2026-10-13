# R21 — conteúdo completo sem rolagem

13/10/2026. Usuário aprovou tamanho da janela e Melo. Ajuste solicitado:
Melo, texto, alternativas e ação devem caber simultaneamente em cada etapa,
sem rolagem na janela. Não aumentar janela nem redimensionar o personagem.

Mantidos parâmetros geométricos R20/R20A: largura31,4% do mapa no desktop,
proporção1,87:1, piso360px no horizontal, posição e cabeçalho. Assets e
quadro do Melo preservados. Mapa e motor inalterados.

Removidos os dois SingleChildScrollView do diálogo e seu ScrollController.
Apenas conteúdo de texto/ações passa por FittedBox(scaleDown), com largura
de layout limitada à área útil e altura natural. Janela, cabeçalho e Melo
ficam fora desse ajuste. No horizontal o personagem permanece à esquerda;
no vertical mantém180 x225 acima da área de conteúdo.

Reduzidos fontes, margens, ícones de estado e altura base dos botões. Texto
base horizontal10px, destaque12px, alternativas/ação10px antes do ajuste
final; fontes verticais14/18. Sem reticências, corte de palavras ou remoção
do contexto. O ajuste final pode reduzir mais a escala para textos longos
e fonte ampliada; todos os textos/ações precisam continuar visíveis.
Botões de conteúdo também acompanham a escala; os controles do cabeçalho
continuam48px. A prioridade aprovada é caber tudo no quadro, não o alvo
anterior de48px para todas as alternativas. Cliques reais testados nos
retângulos finais; sem chamar handlers diretamente.

Etapas: introdução, pergunta/seleção, consequência, explicação e resultado.
Continuação/confirmar/voltar ficam na mesma área. Rotação conserva etapa e
seleção. Voz/cronômetro futuros. Persistência, erros, retry e recompensas
inalterados. Sem expansão para outras zonas.

Teste novo cobre seis missões em quatro telas/escalas, confere todos os
Text/ações dentro do quadro, ausência de Scrollable e ausência de
sobreposição entre botões, mantendo janela/Melo entre as etapas. Testes
anteriores adaptados só ao novo contrato de ausência de rolagem e área
visível dos botões. Capturas passam para build/fast22a_r21_evidencias.
