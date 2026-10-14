# FAST22A WORK R27 — validação e homologação

## Preparação

- Mapa e direção visual: aprovados pelo usuário antes da implementação.
- Código completo, oito assets, registros pubspec, formatação/sintaxe Dart 3.12.2, baseline Git e hashes: conferidos.
- Arte mapa_aprovado_r27.png: igual em bytes à imagem selecionada pelo usuário, 1672×941. O retângulo do personagem é a única região de cenário com uma camada editada; UI dinâmica substitui os estados e valores do mockup.
- Seis sprites: PNG RGBA com transparência, corpo inteiro e pequenas dimensões de decodificação no aplicativo. O retrato do HUD usa a arte R26 já homologada.
- Testes/regressões são fornecidos e executados obrigatoriamente pelo instalador. Flutter analyze/test/build não foram executados no ambiente de preparação, sem cache de dependências Flutter. Não há PASS técnico local declarado.
- Execução PS 5.1, testes, goldens/pixels, builds Web/APK e homologação do aplicativo: PENDENTES no Windows.

## Validação técnica no Windows

1. Dependências + formato sem modificar arquivos protegidos.
2. flutter analyze: zero issues.
3. Testes dedicados R27, testes anteriores do mapa/rotas/hub, FAST21 e regressões R24/R25/R26.
4. Suíte completa.
5. Builds release Web e APK.
6. git diff --check + integridade final do payload e arquivos protegidos.

O instalador imprime VALIDACAO TECNICA = PASS somente após todos os checks. Se qualquer um falhar, interrompe mantendo backup e logs; não faz rollback automático sobre dados em uso.

## Homologação Chrome, tablet e Samsung A05 horizontal

1. COMEÇAR ou JOGAR abre o mapa aprovado completo, sem cortes, distorção ou rolagem. Compare marcos, Melo, cartões, footer, rótulos de Ponte/Farol e INÍCIO.
2. Confira o personagem escolhido no INÍCIO e no retrato superior: os seis perfis/gêneros devem corresponder. Para testar cadastro use sessões de teste, sem apagar progresso real.
3. Confira os valores reais de conhecimento, cidadania e moedas com Meu Progresso. Abrir o mapa não concede recompensas.
4. Em perfil novo, Zona 1 e MINHAS MISSÕES abrem a Zona 1; as outras cinco zonas estão bloqueadas. No perfil evoluído, desbloqueios, checks, medalhas e nós seguem o progresso salvo.
5. MINHA CIDADE abre Construa o Bairro; MEDALHAS abre Meu Progresso; faixa inferior abre Progressão Global. Confira retorno para o mapa sem perder dados.
6. Engrenagem abre Mais opções: Faixita, Duelo das Placas, progresso global e Tela inicial. Confirme todas as funções existentes e retorno, incluindo Android back e Tab/Enter no Chrome.
7. Após uma conclusão real, o mapa reflete os valores e zonas novos. Reinicie e confirme continuidade e ausência de recompensa duplicada.

Capturas automáticas dos testes: build/fast22a_r27_evidencias, cinco tamanhos, seis personagens e seis zonas concluídas com progresso simulado. As amostras de pixels dos marcos são comparadas à própria arte aprovada, excluindo controles dinâmicos.

Entregar VALIDACAO TECNICA = PASS e VALIDACAO VISUAL = PASS antes de fechar R27 no Git. Nenhum commit, push ou merge é executado pelo pacote. Animações ficam para etapa seguinte.
