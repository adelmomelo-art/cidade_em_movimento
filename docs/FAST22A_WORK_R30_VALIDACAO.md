# FAST22A WORK R30 — Validação

**VALIDAÇÃO TÉCNICA COMPLETA: PENDENTE. VALIDAÇÃO VISUAL NO APP: PENDENTE.**
Mockup do mapa aprovado em 15/10/2026; aprovação da imagem não substitui homologação da implementação.

## Executado neste ambiente

- Recuperação da baseline Git R29 `4f08d2a`.
- Inspeção da arte aprovada e das três artes preparadas para produção.
- Formatação Dart dos arquivos alterados.
- Análise estática offline dos três arquivos de implementação da Zona 2: sem problemas. Utilizados fontes locais do Flutter e regras públicas oficiais do linter; não houve alteração de dependências do projeto.
- Revisão das adaptações dos testes e conferência de integridade do pacote.
- `git diff --check`.

Não executados aqui: widget tests, suíte Flutter completa, `flutter analyze` completo e builds Web/APK. O ambiente não dispõe da ferramenta Flutter pronta e das dependências completas. O bloqueio anterior durante preparação do SDK não foi contornado. Os gates completos serão executados pelo script no computador do usuário. Não afirmar PASS antes desse resultado.

## Gates do instalador

1. Dependências, formatação e `flutter analyze` (zero issues).
2. Teste rápido da tela/compra, suíte R30, motor da Zona 2 e regressões da Zona 1, mapa e barcos.
3. `flutter test` completo, sem skips acrescentados por esta entrega.
4. Web release.
5. APK release.
6. `git diff --check`, integridade do payload e arquivos protegidos.

O script só emite `VALIDACAO TECNICA = PASS` após todos os grupos. Backup, APK anterior e logs por gate ficam em `cidade_FAST22A_R30_backup_<data>`, ao lado do projeto. Capturas dos testes: `build/fast22a_r30_evidencias`.

## Homologação manual

Chrome, Samsung A05 horizontal e tablet:
- Comparar mapa inteiro à referência aprovada; sem rolagem, cortes ou margens brancas. Melo, seis pins, HUD e cenário nas proporções aprovadas.
- Perfil criança/adolescente/adulto e gênero: avatar inicial e retrato corretos; números reais do progresso, sem valores fixos da prévia.
- Zona bloqueada não abre missões; primeira missão libera após Zona 1; sequência e especial seguem regras existentes.
- Seis missões: observar, selecionar, confirmar, consequência, explicação, repetir após erro e resultado. Texto completo, controles visíveis e sem rolagem.
- Sair/Android Back antes de concluir não concede prêmio. Rotacionar e retornar mantém etapa e alternativa pendente.
- Concluir uma vez concede recompensas, medalha e bônus; repetir não duplica. Reabrir app preserva progresso.
- Melhorias: três custos corretos, desconto uma vez, INSTALADA após compra e após reinício. Noite não altera progresso.
- Progresso e Faixita abrem/retornam; mapa de Fortaleza preserva barcos e destinos; avanço à Zona 3 aparece somente após liberação.
- Reabrir Zona 1: identidade R29 e funcionamento preservados.

Retorno:
```
VALIDACAO TECNICA = PASS / FAIL
CHROME = PASS / FAIL
A05 HORIZONTAL = PASS / FAIL
TABLET = PASS / FAIL
FIDELIDADE AO MOCKUP = PASS / FAIL
OBSERVACOES =
```

Em falha, enviar o primeiro bloco completo EXCEPTION CAUGHT e a linha do teste; logs no backup. Não apagar testes nem atualizar goldens para obter PASS. Fechamento Git somente após técnica e visual PASS.
