# FAST22A R42 — Duelo das Placas

Base: main 7b842137c141cc86bc345f7af213a6b23e053696 (R41 / PR14).
Visual horizontal aprovado em 17/10/2026: Melo, rua de Fortaleza, cabeçalho azul, letras brancas, placa ilustrada, alternativas azuis/brancas, confirmação verde.

## Regras aprovadas
- Criança: 20 segundos; adolescente: 15; adulto: 10, por pergunta.
- Selecionar não pontua. É possível trocar a seleção antes de confirmar.
- Confirmar encerra o tempo e mostra a resposta correta e Melo explica.
- Tempo esgotado encerra a rodada sem pontuação, mesmo com opção selecionada. O jogador lê a explicação e avança manualmente.
- Não há limite de tempo na explicação nem no resultado.
- Cronômetro pausa em aplicativo inativo, rota coberta e orientação bloqueada. Retoma os segundos restantes.
- Saída antecipada não chama a gravação do resultado.

## Preservação
Seis perguntas, IDs, opções, índices corretos e explicações existentes preservados. R-19 mantém 40 km/h, conforme a pergunta; 60 km/h no mockup foi exemplo. Há três alternativas no catálogo atual, preservadas. Não foram inventadas alternativas para preencher quatro espaços.

PlayerController e persistência não alterados: 100 pontos/acerto, conhecimento apenas pela melhoria do recorde, gravação após as seis rodadas. Durante a gravação, bloqueia retorno e nova submissão. Falha de gravação mostra mensagem e não permite reenviar o mesmo resultado: o controlador existente atualiza memória antes da persistência, portanto retry automático poderia contar duas partidas.

Arte de fundo derivada do mockup aprovado, sem textos interativos gravados na imagem. Placas desenhadas por CustomPainter, controles Flutter sobre coordenadas 1672×941 e composição completa ajustada à área segura. Texto reutiliza a regra de ajuste aprovada Zone1ArtText. Demais telas permanecem intactas.

## Arquivos
- Alterados: tela do Duelo, pubspec.yaml, teste legado do Duelo (confirmação explícita).
- Novos: sign_duel_art.dart, fundo duelo_base.png, testes R42 e documentos.
- Nenhuma dependência adicionada, nenhuma alteração no catálogo, controlador ou arquivos de outras zonas.

## Validação
Teste legado preserva o percurso perfeito de seis rodadas e recompensa. Testes R42 cobrem tempos por perfil, confirmação, timeout, replay, persistência, pausa, saída antecipada e quatro viewports com três escalas de texto.
O script faz preflight de hashes, backup, pub get, format, analyze, testes direcionados, suíte completa, builds web/APK e git diff --check.
