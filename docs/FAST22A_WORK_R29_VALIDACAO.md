# FAST22A WORK R29 — Validação

## Estado na entrega

**VALIDAÇÃO TÉCNICA COMPLETA: PENDENTE. VALIDAÇÃO VISUAL NO APP: PENDENTE.**
Mockups aprovados pelo usuário. Aprovação de mockup não equivale à homologação do app.

Executado neste ambiente:
- Recuperação da baseline Git R28 / `36f60bb`.
- Inspeção das artes de referência e das três artes de produção.
- Formatação Dart dos arquivos alterados.
- Análise estática offline dos três arquivos de implementação e dos testes R18, R19, R20, R22, R23 e R29: sem problemas após correções.
- Revisão dos testes legados adaptados. A análise dos testes R10–R15 e visual_widget encontra a dependência `shared_preferences` ausente neste ambiente; não foi substituída por código simulado.
- `git diff --check` e verificação do manifesto/pacote.

Não executado aqui:
- `flutter analyze` completo, execução de widget tests, suite completa, build Web e APK.
- A preparação local do Flutter foi bloqueada pela revisão automática por uma tentativa de acesso a metadados da infraestrutura. Não houve nova tentativa dessa operação. Análise estática foi feita com Dart, arquivos locais e regras públicas oficiais, sem modificar dependências do projeto.
- Homologação visual renderizada pelo Flutter em Chrome/A05/tablet.

## Gates no computador do usuário

1. Dependências, formatação e `flutter analyze` (zero issues).
2. Testes dedicados da Zona 1, incluindo seleção, confirmação, seis missões, recompensas, falha de gravação, rotação, layout e evidências R29.
3. `flutter test` completo — inclui regressões dos barcos R28, mapa R27, perfis R25/R26 e home R24.
4. `flutter build web --release`.
5. `flutter build apk --release`.
6. `git diff --check`, integridade dos arquivos entregues e dos arquivos protegidos.

O script só imprime `VALIDACAO TECNICA = PASS` após todos os gates. Logs e backup ficam em `C:\Projetos\cidade_FAST22A_R29_backup_<data>`.

## Homologação visual/manual

- Chrome, Samsung A05 horizontal e tablet: mapa inteiro, sem rolagem, arte proporcional e sem bordas brancas.
- Melo, escola e seis pins nos locais da referência. Avatar correto para cada perfil; HUD com números reais.
- Pin bloqueado não inicia missão; estrelas acompanham a conclusão. Especial desbloqueia conforme regras existentes.
- Travessia Segura: título azul/branco, Melo à esquerda, cena central, alternativas à direita e confirmação amarela. Comparar diretamente ao mockup aprovado.
- Todos os textos completos com tamanho padrão e ampliado; todos os botões tocáveis; nenhum corte.
- Escolher alternativa apenas seleciona. Confirmar abre consequência. Errar permite tentar novamente. Resultado concede prêmio uma única vez.
- Voltar/fechar/Android Back antes do resultado não recompensa. Rotacionar mantém missão e resposta pendente.
- Melhorias abre o painel, compra desconta valor uma vez, estado INSTALADA persiste. Noite reflete iluminação adquirida.
- Retornar ao mapa de Fortaleza mantém os três barcos e os destinos existentes.

Retorno esperado:
```
VALIDACAO TECNICA = PASS / FAIL
CHROME = PASS / FAIL
A05 HORIZONTAL = PASS / FAIL
TABLET = PASS / FAIL
FIDELIDADE AOS DOIS MOCKUPS = PASS / FAIL
OBSERVACOES =
```

Fechar no Git somente após técnica e visual PASS. Não usar atualização automática de goldens para esconder divergências. Evidências: `build/fast22a_r29_evidencias`.
