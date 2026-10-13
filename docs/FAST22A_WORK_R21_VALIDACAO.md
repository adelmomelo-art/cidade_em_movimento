# R21 — validação e homologação

Conferido aqui: formatação/parser Dart, ausência de scroll no diálogo,
mapa/assets/pubspec/manifesto protegido preservados, hashes e ZIP.
Não executados aqui: analyze, testes/renderização Flutter e builds Web/APK
(cache de dependências ausente). Sem PASS técnico ou visual antecipado.
O instalador Windows continua exigindo todos os gates antes do PASS.

## Homologação

- Janela e Melo mantêm os tamanhos aprovados.
- Introdução: contexto e INICIAR visíveis sem rolar.
- Pergunta: contexto, enunciado, todas alternativas e CONFIRMAR RESPOSTA
  visíveis simultaneamente; trocar seleção antes de confirmar funciona.
- Consequência e explicação: texto completo e continuação visíveis.
- Resultado: estrelas, pontuação/recompensas, explicação e ações visíveis.
- Não há scrollbar nem gesto de rolagem dentro da janela.
- Chrome e A05 horizontal/vertical: conferir leitura, botões, texto longo
  e rotação. Se a leitura precisar ajuste, informar com captura sem mudar
  o quadro aprovado automaticamente.
- Cancelamento, erro/retry, repetição, salvamento e progresso preservados.
- Voz e cronômetro não implementados. Mapa restaurado continua inalterado.

Capturas de teste em build/fast22a_r21_evidencias; usar também capturas reais
Chrome/A05 porque fontes de widget test podem diferir.
Nenhum commit, push ou merge executado.
