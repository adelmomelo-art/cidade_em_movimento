# R27C — sincronizacao das imagens no teste

As evidencias R27B mostram controles nativos pintados, mas cenario e avatares ausentes. Todas as 5092 amostras comparadas divergem; a primeira tem alpha zero. A referencia posterior esta completa.

O teste agora aguarda precacheImage dos provedores Image montados em runAsync, com limite de 30 segundos e verificacao de erros. Depois bombeia os frames e verifica que cada RawImage possui imagem decodificada antes da captura. A mesma preparacao e usada na referencia e nas capturas auxiliares.

Arte e codigo do aplicativo identicos a R27B. Regioes, passo 7 e tolerancia de 1 por canal preservados. Nao atualiza golden nem ignora falhas.

Validacao local: formatacao Dart e integridade do pacote. Flutter analyze, teste isolado, regressoes e builds dependem da execucao no Windows; nao declarados PASS na preparacao.
