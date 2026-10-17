# R36A — Compatibilidade do instalador com o registro gerado R35

Falha observada antes da aplicação: Conteudo protegido mudou: macos/Flutter/GeneratedPluginRegistrant.swift.

## Causa e correção
A R35 adicionou video_player. O Flutter regenera o registro do macOS mesmo em um projeto desenvolvido/testado no Windows. A proteção R36 reconhecia apenas o registro R34, que continha shared_preferences_foundation.

R36A aceita a baseline e, somente quando o pubspec R35 é reconhecido, o arquivo completo esperado com import video_player_avfoundation e registro FVPVideoPlayerPlugin. O formato foi conferido no gerador do SDK Flutter e na declaração oficial do plugin video_player_avfoundation 2.9.0. Qualquer outra diferença continua bloqueada. Não foi criada uma exclusão genérica para arquivos gerados.

O arquivo é validado antes/depois dos gates, preservado (não é substituído pelo pacote) e incluído no backup antes do pub get. Cenários, Melo, conteúdo e motores continuam protegidos. Todos os 19 arquivos Dart são idênticos aos entregues no R36; fontes e janelas não recebem outra modificação nesta revisão.

## Verificação de preparação
- Integridade do payload R36 preservada.
- Registro baseline aceito; registro esperado do vídeo aceito só com R35.
- CRLF aceito por normalização; alteração desconhecida rejeitada.
- Sem execução de PowerShell, testes Flutter ou builds neste ambiente. A validação técnica local continua pendente.

Execute o instalador R36A completo. Não é necessário aplicar R36 antes. Se houver outro conteúdo não reconhecido, o script para antes de alterar o projeto.

VALIDACAO TECNICA = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE

Sem commit, push ou merge automático.
