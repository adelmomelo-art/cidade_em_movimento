# FAST22A R24 — tela inicial fiel ao mockup aprovado

Baseline: main 3f2e3272c613bed717c4dcff9b7c011e5021393e, PR #2 merged.
R23: validação técnica e visual PASS informadas pelo usuário em 13/10/2026.
R24: nova tela inicial autorizada após aprovação do mockup com quatro botões.

## Arte e interação

Usa o próprio PNG aprovado, sem alteração de pixels, 1672×941.
SHA-256: b1a72e2d193d864480be77214079987371becff931f5ab188a25b29393fc5a9c
Arquivo: assets/home/tela_inicial_r24.png.
Título, Melo, balão, ícones, cores, textos, bordas e relevo são a arte aprovada.
Áreas clicáveis transparentes acompanham exatamente a transformação da imagem.
Não substitui os botões por controles de aparência semelhante.
Hover, foco e pressionamento acrescentam apenas feedback visual transitório.
Leitores de tela recebem título/apresentação e rótulos/hints reais para botões.
O teclado usa Tab e Enter. Não há rolagem na tela inicial.

| Botão visual | Jogador com perfil | Jogador sem perfil |
| --- | --- | --- |
| JOGAR (verde) | Mapa de Fortaleza, continuando o progresso | Escolha de perfil |
| MAPA DA CIDADE (azul) | Mapa de Fortaleza | Escolha de perfil |
| MINHAS MISSÕES (laranja) | Mapa/seleção das missões da Zona 1 | Escolha de perfil |
| CONQUISTAS (roxo) | Tela existente Meu Progresso | Escolha de perfil |

Mantém JOGAR como rótulo visual do mockup também para quem retorna. O hint
explica “Continuar sua jornada”; não apaga perfil nem recompensas.
Não cria novas telas de missões/conquistas. Para novos jogadores, o cadastro
continua pelo fluxo existente de perfil/avatar/apresentação/mapa.

## Proporções e limites

A composição nítida usa BoxFit.contain dentro do SafeArea: não corta título,
Melo, balão ou botões, e não deforma o PNG. Telas mais largas/altas que o
mockup recebem a mesma imagem desfocada/escurecida por trás, preenchendo toda
a área do app. Essa extensão ambiente não é uma nova ilustração e pode ser
vista nas laterais do A05; não há faixas brancas. Não se declara identidade
pixel a pixel do viewport inteiro em proporções diferentes. A identidade é da
composição nítida, que conserva sua proporção original.

Textos gráficos fazem parte do PNG e não aumentam com TextScaler. Os rótulos
semânticos continuam disponíveis. Conferir leitura e precisão dos toques no
A05 real e fontes ampliadas; não se declara alvo efetivo mínimo de 48 dp em
todas as telas. Não há timer, voz, configurações novas ou troca do cenário Z1.

## Escopo

Altera apenas HomeScreen, o registro de um asset no pubspec e teste inicial;
adiciona arte, teste dedicado e documentação. Protege mapas, perguntas, gate,
orientação, controllers, serviços, persistência e demais fontes da R23.
Branch separada: feat/fast-22a-tela-inicial-r24. Sem commit/push/merge automáticos.
