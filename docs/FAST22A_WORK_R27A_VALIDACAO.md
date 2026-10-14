# FAST22A WORK R27A — correção de analyze

14/10/2026. O analyze da R27 no Windows identificou uma única ocorrência: sort_child_properties_last no Tooltip da medalha em fortaleza_map_screen.dart:286. O parâmetro key estava depois de child. A R27A move key antes de message/child e não altera comportamento, desenho, dados, testes ou assets.

A formatação/sintaxe Dart e os hashes do pacote foram conferidos na preparação. Todos os outros arquivos de código, testes e oito assets são iguais à R27. O pacote é completo, aceita entrada R26, R27 ou R27A nos arquivos declarados e mantém a mesma branch feat/fast-22a-mapa-fortaleza-r27 e HEAD 2adfd2d.

Análise, execução dos testes e builds continuam PENDENTES no Windows. Reexecute o instalador completo: analyze, testes dedicados/regressões, suíte, Web, APK e integridade. Só após todos passarem imprime VALIDACAO TECNICA = PASS. Homologação visual permanece pendente. Nenhum commit/push/merge executado.
