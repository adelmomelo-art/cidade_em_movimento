# R23 — validação e aceite

Status local: formatação/sintaxe Dart e integridade conferidas.
Flutter analyze, testes, Web e APK: PENDENTES de execução no Windows.
As dependências do Flutter/pub não estão disponíveis neste ambiente.
Homologação visual R23: PENDENTE. R22 horizontal: aprovado pelo usuário.

O instalador conserva backup, logs individuais e hashes antes/depois. Exige
pub get, format, analyze, testes dedicados até R23, FAST9, suíte completa,
build Web release, build APK release, git diff --check e arquivos protegidos.
Somente então imprime VALIDACAO TECNICA = PASS.

Testes R22 atualizados: bordas do mapa coincidem com a tela, painéis dentro
 dos insets de segurança, zero Scrollable, todas as missões acessíveis e
seleção/State preservados na rotação. Capturas agora em R23.
Novo teste R23: 800×360 em densidades 1 e 2, recorte de câmera/barra nas duas
orientações; tablet 1024×768 com insets; Web 1366×768. Verifica quatro bordas,
sem cantos vazios, pintura proporcional e cobertura total da imagem, identidade
das transformações de imagem/infraestrutura de dia e à noite, controles dentro
da área segura e progresso intacto. Gera capturas de dia/noite.

Depois de PASS:
- Instalar o APK recém-gerado e abrir Zona 1 no A05 horizontal.
- Conferir cenário chegando às quatro bordas da área do app, sem faixas claras.
- Repetir com o aparelho girado para o outro lado (câmera/barra invertidas).
- Conferir a composição reenquadrada, leitura e toque dos painéis.
- Dia/noite e melhorias: faixa, iluminação e ciclovia continuam alinhadas.
- Abrir seis missões; janela de perguntas/Melo iguais à R22, sem rolagem.
- Selecionar resposta, girar para vertical e retornar: seleção preservada.
- Compras, progresso, fechar sem prêmio e concluir com prêmio único.
- Repetir no Chrome e tablet; sem rolagem ou painéis cortados.

Capturas: build/fast22a_r23_evidencias. Etapas de perguntas continuam em
build/fast22a_r21_evidencias. Enviar log desde a primeira exceção se um gate
falhar. Resumo “Failing tests” sozinho não mostra a causa.
