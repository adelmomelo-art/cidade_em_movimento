# FAST22A R25 — validação e homologação

Local: sintaxe/formatação, dimensões/SHA do PNG e integridade do pacote.
Dependências Flutter/pub indisponíveis aqui; analyze/testes/golden/builds e
conferência visual R25: PENDENTES no Windows. Não declarar PASS antes dos gates.

Teste R25:
- 600×390, 800×360, 844×390, 1280×800 e 1366×768; SafeArea e texto 1,4.
- Composição inteira, proporcional, sem rolagem; fundo ocupa viewport.
- Três cartões/Voltar visíveis e dentro da área segura; cartões sem sobreposição.
- Retrato e descrição de cada cartão abrem avatar com enum correto.
- Sem gravação prematura de perfil ou alteração do progresso nessa escolha.
- Integração com AvatarScreen original para os três tipos, mantendo Menino/Menina.
- Voltar com rota anterior e com seleção aberta diretamente como rota raiz.
- Teclado Tab/Enter; leitor de tela via semanticsEnabled: true administrado pelo
  próprio testWidgets, sem criar handle manual pendente como na falha R24.
- Renderização nativa comparada pixel a pixel ao PNG aprovado, sem atualizar golden.
- Capturas de viewport: build/fast22a_r25_evidencias.

O instalador exige pub get, format, analyze, testes R25/R24A/widget/FAST21,
suíte completa, Web release, APK release, git diff --check e hashes protegidos.
Backup e logs individuais. Nenhum commit/push/merge. Somente imprime
VALIDACAO TECNICA = PASS após todos esses gates.

Depois de PASS, conferir no Chrome, A05 e tablet:
1. Jogar sem perfil abre a composição aprovada; título/cartões/descrições inteiros.
2. Criança, Adolescente e Adulto abrem o avatar correspondente.
3. Voltar do avatar e da escolha do perfil mantém navegação e dados corretos.
4. Completar cadastro pelo avatar continua na apresentação/mapa existentes.
5. Leitura, toques e ambas as posições horizontais; vertical mantém gate R23.
6. Tela inicial R24A e uma missão Z1 mantêm aparência e funcionamento aprovados.

Se um gate falhar, enviar o log desde a primeira exceção. A fonte e o asset
serem íntegros não equivalem à execução do golden/analyze/build.
