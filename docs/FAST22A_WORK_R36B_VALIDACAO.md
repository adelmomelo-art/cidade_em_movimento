# R36B — Registro real do plugin de vídeo

Evidência fornecida pelo usuário em 16/10/2026: Get-Content e git diff do arquivo macos/Flutter/GeneratedPluginRegistrant.swift. A saída adiciona import video_player_avfoundation e registro VideoPlayerPlugin. O blob Git exibido é f7ba5ff.

R36A previa a classe FVPVideoPlayerPlugin de uma versão anterior do plugin. R36B usa exatamente o registro enviado, cujo blob Git foi conferido contra f7ba5ff. O SHA-256 normalizado desse arquivo é a única exceção R35 à baseline do registro macOS, habilitada somente quando o pubspec R35 também é reconhecido. Outras diferenças continuam bloqueadas.

O arquivo gerado permanece preservado, não é copiado pelo instalador e tem backup antes de pub get. São mantidos todos os ajustes R36 de fonte e rótulos nas seis zonas. O pacote é completo e substitui R36 e R36A; não é necessário aplicar os anteriores.

## Verificações
- Conteúdo Swift reproduz exatamente a evidência e o blob Git f7ba5ff.
- Baseline original aceita.
- Registro real enviado aceito somente com R35; CRLF normalizado aceito.
- Registro divergente e alterações adicionais rejeitados.
- Arquivos Dart, assets e motores inalterados em relação ao R36/R36A.
- Integridade do pacote e payload conferidas.
- Execução do PowerShell, testes Flutter, builds e homologação visual continuam pendentes no Windows.

VALIDACAO TECNICA = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE

Sem commit, push ou merge automático.
