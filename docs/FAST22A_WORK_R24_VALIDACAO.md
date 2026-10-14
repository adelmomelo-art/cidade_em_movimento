# FAST22A R24 — validação

Status local: sintaxe/formatação e integridade verificadas; PNG idêntico ao
mockup aprovado por SHA-256. Dependências Flutter/pub indisponíveis aqui.
Flutter analyze, testes/golden, Web/APK e aceite do app renderizado: PENDENTES
no Windows. Não declarar PASS antes dos gates e da conferência real.

Novo teste dedicado R24:
- 600×390, 800×360, 844×390, 1280×800 e 1366×768; jogador novo/retornando.
- SafeArea com câmera/barra, TextScaler 1,4, composição inteira/proporcional.
- Fundo ambiente ocupa o viewport; zero Scrollable; quatro botões legíveis
  para o leitor de tela, visíveis, sem sobreposição e com toques no PNG
  abrindo a rota correta. Tocar no rosto do Melo não navega.
- Progresso preservado durante navegação/retorno.
- Renderização da composição nativa comparada pixel a pixel ao PNG aprovado
  por matchesGoldenFile; não usa --update-goldens nem aceita diferença silenciosa.
- Tab e Enter ativam JOGAR com progresso intacto.
- Capturas reais geradas em build/fast22a_r24_evidencias.

Gates do instalador: pub get, format, analyze, testes R24 + widget/FAST21,
suíte completa (inclui R23/mapas/perguntas), Web release, APK release,
git diff --check e integridade de todos os arquivos protegidos. Backup e logs
separados. Nenhum commit, push ou merge. Após VALIDACAO TECNICA = PASS:

1. Instalar APK recém-gerado; conferir no A05 e Chrome/tablet.
2. Comparar título, Melo, balão e botões com o mockup, sem cortes/distorções.
3. Conferir a extensão suave do cenário nas laterais em telas mais largas.
4. Jogador novo: cada botão abre escolha de perfil; fluxo cadastra normalmente.
5. Jogador existente: Jogar/Mapa abrem Fortaleza, Missões abre Zona 1,
   Conquistas abre Meu Progresso. Voltar mantém dados e imagem.
6. Conferir textos gráficos e toques no A05 nas duas posições horizontais.
7. Validar rotação/gate e uma missão da Zona 1, sem regressão da R23.

Se houver falha, enviar o log desde a primeira exceção. Golden é uma comparação
real no Flutter; verificação do SHA sozinha não equivale ao resultado do golden.
