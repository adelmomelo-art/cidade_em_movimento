# R17 — validação e homologação

## Preparação

SHA-256 dos 12 arquivos restaurados comparado com o pacote R15 original.
Arquivos Dart/testes restaurados sem alterações funcionais. Formatação
verificada na preparação; manifesto e ZIP conferidos.

O pacote R15 original traz evidência histórica de analyze sem issues,
272 testes e build Web. Essa evidência não é uma execução da R17.
O cache Flutter atual está indisponível aqui: analyze, testes e builds
R17 deverão ser executados pelo instalador no Windows. Não há PASS
técnico R17 declarado antes desses resultados. PowerShell e SDK Android
não disponíveis neste ambiente.

## Gates Windows obrigatórios

Dependências, formatação, analyze, dedicado FAST22A até R15, FAST9 390,
suite completa, build Web release, build APK release, git diff --check,
hashes dos arquivos restaurados, arquivos protegidos e ausência dos dois
arquivos específicos da abordagem R16 retirada.

## Homologação visual

- Conferir composição anterior à R16 no Chrome e no A05.
- KPIs, navegação, missões, melhorias e Melo no cenário conforme R15.
- Seis missões abrem a janela sobre o cenário, explicação e resultado.
- Cancelamento, repetição sem prêmio duplicado e progresso preservado.
- Compras, estrelas, medalha e iluminação seguem o progresso real.
- Volta ao mapa de Fortaleza e liberação da próxima zona corretas.
- Restauração não exige mapa sem rolagem: esse ajuste permanece pendente.
- Perguntas ainda usam o layout R15; proposta 3 será implementada depois.

Só considerar homologado após aceite visual explícito. Commit, push e
merge permanecem pendentes.
