# R28B — camada dos barcos e menu

Causa confirmada pelo log: Positioned com StackParentData foi inserido nas actions do AlertDialog, que usa OverflowBar. Isso gerava ParentDataWidget incorreto e tamanho infinito ao abrir o menu.

Correcao: FortalezaBoats e posicionado nas actions do ApprovedArtworkPage, cujo pai visual e Stack. Dialogo contem somente seu botao FECHAR. Arte e trajetos preservados; correcao de API R28A mantida. Teste R27 de menu agora exige exatamente uma camada de barcos e nenhuma dentro do AlertDialog. Gates de menus executados antes do analyze.

Formatacao e integridade locais; execucao Flutter pendente no Windows.
